begin;

create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(63);

create temp table __hirfati_test_results (
  case_name text primary key,
  result jsonb not null
) on commit drop;

create or replace function public.__hirfati_test_seed_case(
  p_case_name text,
  p_client_id uuid,
  p_worker_user_id uuid,
  p_worker_id uuid,
  p_order_id uuid,
  p_client_balance numeric,
  p_worker_balance numeric,
  p_order_status text default 'completed',
  p_order_payment_status text default 'pending',
  p_order_price numeric default 30
)
returns void
language plpgsql
set search_path = public, pg_temp
as $$
declare
  v_category_id uuid := (
    '10000000-0000-0000-0000-' || lpad(right(replace(p_order_id::text, '-', ''), 12), 12, '0')
  )::uuid;
begin
  insert into auth.users (
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    raw_app_meta_data,
    raw_user_meta_data,
    created_at,
    updated_at
  )
  values
    (
      p_client_id,
      'authenticated',
      'authenticated',
      p_case_name || '-client@example.test',
      crypt('password', gen_salt('bf')),
      now(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      '{}'::jsonb,
      now(),
      now()
    ),
    (
      p_worker_user_id,
      'authenticated',
      'authenticated',
      p_case_name || '-worker@example.test',
      crypt('password', gen_salt('bf')),
      now(),
      '{"provider":"email","providers":["email"]}'::jsonb,
      '{}'::jsonb,
      now(),
      now()
    )
  on conflict (id) do nothing;

  insert into public.profiles (id, full_name, role, phone)
  values
    (p_client_id, p_case_name || ' client', 'client', '+10000000001'),
    (p_worker_user_id, p_case_name || ' worker', 'worker', '+10000000002')
  on conflict (id) do update set
    full_name = excluded.full_name,
    role = excluded.role,
    phone = excluded.phone;

  insert into public.categories (id, name, icon)
  values (v_category_id, p_case_name || ' category', 'build')
  on conflict (id) do nothing;

  insert into public.workers (
    id,
    user_id,
    category_id,
    experience_years,
    bio,
    price_min,
    price_max,
    is_available,
    approved,
    profile_completed
  )
  values (
    p_worker_id,
    p_worker_user_id,
    v_category_id,
    5,
    'Phase 1 settlement test worker',
    10,
    100,
    true,
    true,
    true
  )
  on conflict (id) do update set
    user_id = excluded.user_id,
    category_id = excluded.category_id,
    approved = excluded.approved,
    profile_completed = excluded.profile_completed;

  perform set_config('hirfati.settle_order_payment', 'true', true);

  insert into public.wallets (user_id, balance, created_at, updated_at)
  values
    (p_client_id, p_client_balance, now(), now()),
    (p_worker_user_id, p_worker_balance, now(), now())
  on conflict (user_id) do update set
    balance = excluded.balance,
    updated_at = excluded.updated_at;

  perform set_config('hirfati.settle_order_payment', 'false', true);

  insert into public.orders (
    id,
    client_id,
    worker_id,
    description,
    price,
    title,
    address,
    latitude,
    longitude,
    status,
    payment_status,
    created_by,
    created_at
  )
  values (
    p_order_id,
    p_client_id,
    p_worker_id,
    'Phase 1 settlement test order',
    p_order_price,
    p_case_name || ' order',
    'Test address',
    24.7136,
    46.6753,
    p_order_status,
    p_order_payment_status,
    'client',
    now()
  )
  on conflict (id) do update set
    status = excluded.status,
    payment_status = excluded.payment_status,
    price = excluded.price;
end;
$$;

create or replace function public.__hirfati_test_try_settle(
  p_user_id uuid,
  p_order_id uuid,
  p_idempotency_key text,
  p_payment_method text default 'wallet'
)
returns jsonb
language plpgsql
set search_path = public, pg_temp
as $$
declare
  v_result jsonb;
begin
  perform set_config('request.jwt.claim.sub', p_user_id::text, true);
  perform set_config('request.jwt.claim.role', 'authenticated', true);

  v_result := public.settle_order_payment(
    p_order_id,
    p_payment_method,
    p_idempotency_key
  );

  return jsonb_build_object('ok', true, 'result', v_result);
exception
  when others then
    perform set_config('hirfati.settle_order_payment', 'false', true);
    return jsonb_build_object(
      'ok',
      false,
      'error',
      sqlerrm,
      'sqlstate',
      sqlstate
    );
end;
$$;

create or replace function public.__hirfati_test_try_direct_order_paid(
  p_order_id uuid
)
returns text
language plpgsql
set search_path = public, pg_temp
as $$
begin
  perform set_config('hirfati.settle_order_payment', 'false', true);

  update public.orders
  set payment_status = 'paid',
      paid_at = now()
  where id = p_order_id;

  return 'ok';
exception
  when others then
    return sqlerrm;
end;
$$;

create or replace function public.__hirfati_test_try_direct_wallet_update(
  p_user_id uuid
)
returns text
language plpgsql
set search_path = public, pg_temp
as $$
begin
  perform set_config('hirfati.settle_order_payment', 'false', true);

  update public.wallets
  set balance = balance + 1
  where user_id = p_user_id;

  return 'ok';
exception
  when others then
    return sqlerrm;
end;
$$;

create or replace function public.__hirfati_test_try_direct_payment_insert(
  p_client_id uuid,
  p_order_id uuid
)
returns text
language plpgsql
set search_path = public, pg_temp
as $$
begin
  perform set_config('hirfati.settle_order_payment', 'false', true);

  insert into public.payments (
    order_id,
    amount,
    payer_id,
    transfer_group,
    currency,
    created_by,
    payment_method,
    status,
    provider,
    idempotency_key,
    created_at
  )
  values (
    p_order_id,
    30,
    p_client_id,
    gen_random_uuid(),
    'SYP',
    'client',
    'wallet',
    'completed',
    'wallet',
    'phase1-direct-insert',
    now()
  );

  return 'ok';
exception
  when others then
    return sqlerrm;
end;
$$;

create or replace function public.__hirfati_test_fail_worker_credit()
returns trigger
language plpgsql
set search_path = public, pg_temp
as $$
begin
  if new.idempotency_key = 'phase1-h:worker_credit' then
    raise exception 'forced_test_failure_after_client_debit';
  end if;

  return new;
end;
$$;

select is(
  has_function_privilege(
    'anon',
    'public.settle_order_payment(uuid,text,text,text,text)',
    'execute'
  ),
  false,
  'settle_order_payment is not executable by anon'
);

select is(
  has_function_privilege(
    'authenticated',
    'public.settle_order_payment(uuid,text,text,text,text)',
    'execute'
  ),
  true,
  'settle_order_payment is executable by authenticated users'
);

select is(has_table_privilege('authenticated', 'public.wallets', 'insert'), false, 'authenticated cannot insert wallets directly');
select is(has_table_privilege('authenticated', 'public.wallets', 'update'), false, 'authenticated cannot update wallets directly');
select is(has_table_privilege('authenticated', 'public.payments', 'insert'), false, 'authenticated cannot insert payments directly');
select is(has_table_privilege('authenticated', 'public.payments', 'update'), false, 'authenticated cannot update payments directly');
select is(has_table_privilege('authenticated', 'public.wallet_transactions', 'insert'), false, 'authenticated cannot insert wallet ledger rows directly');
select is(has_table_privilege('authenticated', 'public.wallet_transactions', 'update'), false, 'authenticated cannot update wallet ledger rows directly');
select is(has_table_privilege('authenticated', 'public.wallet_transactions', 'delete'), false, 'authenticated cannot delete wallet ledger rows directly');

select public.__hirfati_test_seed_case(
  'phase1-a',
  '00000000-0000-0000-0000-000000000101',
  '00000000-0000-0000-0000-000000000102',
  '00000000-0000-0000-0000-000000000103',
  '00000000-0000-0000-0000-000000000104',
  100,
  20
);

insert into __hirfati_test_results
values (
  'a',
  public.__hirfati_test_try_settle(
    '00000000-0000-0000-0000-000000000101',
    '00000000-0000-0000-0000-000000000104',
    'phase1-a'
  )
);

select is((result->>'ok')::boolean, true, 'A: settlement succeeds') from __hirfati_test_results where case_name = 'a';
select is(((result->'result'->>'idempotent')::boolean), false, 'A: first settlement is not idempotent') from __hirfati_test_results where case_name = 'a';
select is((select balance from public.wallets where user_id = '00000000-0000-0000-0000-000000000101'), 70::numeric, 'A: client wallet is debited');
select is((select balance from public.wallets where user_id = '00000000-0000-0000-0000-000000000102'), 50::numeric, 'A: worker wallet is credited');
select is((select count(*) from public.payments where order_id = '00000000-0000-0000-0000-000000000104' and status = 'completed'), 1::bigint, 'A: one completed payment is created');
select is((select payer_id from public.payments where order_id = '00000000-0000-0000-0000-000000000104'), '00000000-0000-0000-0000-000000000101'::uuid, 'A: payment payer is the client');
select is((select payee_id from public.payments where order_id = '00000000-0000-0000-0000-000000000104'), '00000000-0000-0000-0000-000000000102'::uuid, 'A: payment payee is the worker user');
select is((select provider from public.payments where order_id = '00000000-0000-0000-0000-000000000104'), 'wallet', 'A: payment provider is wallet');
select is((select currency from public.payments where order_id = '00000000-0000-0000-0000-000000000104'), 'SYP', 'A: payment currency defaults to SYP');
select is((select payment_status from public.orders where id = '00000000-0000-0000-0000-000000000104'), 'paid', 'A: order is marked paid');
select is((select count(*) from public.wallet_transactions where order_id = '00000000-0000-0000-0000-000000000104'), 2::bigint, 'A: exactly two ledger rows are created');
select is((select count(distinct transfer_group_id) from public.wallet_transactions where order_id = '00000000-0000-0000-0000-000000000104'), 1::bigint, 'A: ledger rows share one transfer group');
select is((select count(*) from public.wallet_transactions where order_id = '00000000-0000-0000-0000-000000000104' and transaction_type = 'payment'), 2::bigint, 'A: ledger rows use payment transaction type');
select is((select count(*) from public.wallet_transactions where order_id = '00000000-0000-0000-0000-000000000104' and currency = 'SYP' and created_by = 'client'), 2::bigint, 'A: ledger rows include SYP currency and client actor');
select ok(exists(select 1 from public.wallet_transactions where order_id = '00000000-0000-0000-0000-000000000104' and wallet_user_id = '00000000-0000-0000-0000-000000000101' and direction = 'debit' and balance_before = 100 and balance_after = 70), 'A: client debit ledger has correct balances');
select ok(exists(select 1 from public.wallet_transactions where order_id = '00000000-0000-0000-0000-000000000104' and wallet_user_id = '00000000-0000-0000-0000-000000000102' and direction = 'credit' and balance_before = 20 and balance_after = 50), 'A: worker credit ledger has correct balances');
select is((select count(*) from public.payment_events pe join public.payments p on p.id = pe.payment_id where p.order_id = '00000000-0000-0000-0000-000000000104'), 1::bigint, 'A: payment event is created');
select is((select count(*) from public.notifications where user_id = '00000000-0000-0000-0000-000000000102' and type = 'payment'), 1::bigint, 'A: worker notification is created');

select public.__hirfati_test_seed_case(
  'phase1-b',
  '00000000-0000-0000-0000-000000000201',
  '00000000-0000-0000-0000-000000000202',
  '00000000-0000-0000-0000-000000000203',
  '00000000-0000-0000-0000-000000000204',
  10,
  20
);

insert into __hirfati_test_results
values (
  'b',
  public.__hirfati_test_try_settle(
    '00000000-0000-0000-0000-000000000201',
    '00000000-0000-0000-0000-000000000204',
    'phase1-b'
  )
);

select is(result->>'error', 'insufficient_wallet_balance', 'B: insufficient balance is rejected') from __hirfati_test_results where case_name = 'b';
select is((select balance from public.wallets where user_id = '00000000-0000-0000-0000-000000000201'), 10::numeric, 'B: client balance is unchanged');
select is((select balance from public.wallets where user_id = '00000000-0000-0000-0000-000000000202'), 20::numeric, 'B: worker balance is unchanged');
select is((select count(*) from public.payments where order_id = '00000000-0000-0000-0000-000000000204' and status = 'completed'), 0::bigint, 'B: no completed payment is created');
select is((select payment_status from public.orders where id = '00000000-0000-0000-0000-000000000204'), 'pending', 'B: order remains unpaid');
select is((select count(*) from public.wallet_transactions where order_id = '00000000-0000-0000-0000-000000000204'), 0::bigint, 'B: no ledger rows are created');
select is((select count(*) from public.notifications where user_id = '00000000-0000-0000-0000-000000000202' and type = 'payment'), 0::bigint, 'B: no success notification is created');

select public.__hirfati_test_seed_case(
  'phase1-c',
  '00000000-0000-0000-0000-000000000301',
  '00000000-0000-0000-0000-000000000302',
  '00000000-0000-0000-0000-000000000303',
  '00000000-0000-0000-0000-000000000304',
  100,
  20
);

insert into __hirfati_test_results
values (
  'c1',
  public.__hirfati_test_try_settle(
    '00000000-0000-0000-0000-000000000301',
    '00000000-0000-0000-0000-000000000304',
    'phase1-c'
  )
);
insert into __hirfati_test_results
values (
  'c2',
  public.__hirfati_test_try_settle(
    '00000000-0000-0000-0000-000000000301',
    '00000000-0000-0000-0000-000000000304',
    'phase1-c'
  )
);

select is((result->>'ok')::boolean, true, 'C: first idempotency-key settlement succeeds') from __hirfati_test_results where case_name = 'c1';
select is((result->>'ok')::boolean, true, 'C: repeated idempotency-key settlement succeeds') from __hirfati_test_results where case_name = 'c2';
select is(((result->'result'->>'idempotent')::boolean), true, 'C: repeated idempotency-key settlement is idempotent') from __hirfati_test_results where case_name = 'c2';
select is((select balance from public.wallets where user_id = '00000000-0000-0000-0000-000000000301'), 70::numeric, 'C: client is debited once');
select is((select balance from public.wallets where user_id = '00000000-0000-0000-0000-000000000302'), 50::numeric, 'C: worker is credited once');
select is((select count(*) from public.payments where order_id = '00000000-0000-0000-0000-000000000304' and status = 'completed'), 1::bigint, 'C: no duplicate completed payment is created');
select is((select count(*) from public.wallet_transactions where order_id = '00000000-0000-0000-0000-000000000304'), 2::bigint, 'C: no duplicate ledger pair is created');

insert into __hirfati_test_results
values (
  'd',
  public.__hirfati_test_try_settle(
    '00000000-0000-0000-0000-000000000301',
    '00000000-0000-0000-0000-000000000304',
    'phase1-d'
  )
);

select is(result->>'error', 'already_paid', 'D: different idempotency key for paid order is rejected') from __hirfati_test_results where case_name = 'd';
select is((select balance from public.wallets where user_id = '00000000-0000-0000-0000-000000000301'), 70::numeric, 'D: client balance remains unchanged');
select is((select balance from public.wallets where user_id = '00000000-0000-0000-0000-000000000302'), 50::numeric, 'D: worker balance remains unchanged');

select public.__hirfati_test_seed_case(
  'phase1-e',
  '00000000-0000-0000-0000-000000000401',
  '00000000-0000-0000-0000-000000000402',
  '00000000-0000-0000-0000-000000000403',
  '00000000-0000-0000-0000-000000000404',
  100,
  20
);
select public.__hirfati_test_seed_case(
  'phase1-e-other',
  '00000000-0000-0000-0000-000000000405',
  '00000000-0000-0000-0000-000000000406',
  '00000000-0000-0000-0000-000000000407',
  '00000000-0000-0000-0000-000000000408',
  100,
  20
);

insert into __hirfati_test_results
values (
  'e',
  public.__hirfati_test_try_settle(
    '00000000-0000-0000-0000-000000000405',
    '00000000-0000-0000-0000-000000000404',
    'phase1-e'
  )
);

select is(result->>'error', 'forbidden', 'E: unauthorized client is rejected') from __hirfati_test_results where case_name = 'e';
select is((select balance from public.wallets where user_id = '00000000-0000-0000-0000-000000000401'), 100::numeric, 'E: real client balance remains unchanged');
select is((select count(*) from public.payments where order_id = '00000000-0000-0000-0000-000000000404' and status = 'completed'), 0::bigint, 'E: no completed payment is created');

select public.__hirfati_test_seed_case(
  'phase1-f',
  '00000000-0000-0000-0000-000000000501',
  '00000000-0000-0000-0000-000000000502',
  '00000000-0000-0000-0000-000000000503',
  '00000000-0000-0000-0000-000000000504',
  100,
  20,
  'accepted'
);

insert into __hirfati_test_results
values (
  'f',
  public.__hirfati_test_try_settle(
    '00000000-0000-0000-0000-000000000501',
    '00000000-0000-0000-0000-000000000504',
    'phase1-f'
  )
);

select is(result->>'error', 'invalid_order_state', 'F: invalid order status is rejected') from __hirfati_test_results where case_name = 'f';
select is((select balance from public.wallets where user_id = '00000000-0000-0000-0000-000000000501'), 100::numeric, 'F: client balance remains unchanged');
select is((select count(*) from public.payments where order_id = '00000000-0000-0000-0000-000000000504' and status = 'completed'), 0::bigint, 'F: no completed payment is created');

insert into __hirfati_test_results
values (
  'card',
  public.__hirfati_test_try_settle(
    '00000000-0000-0000-0000-000000000501',
    '00000000-0000-0000-0000-000000000504',
    'phase1-card',
    'card'
  )
);
insert into __hirfati_test_results
values (
  'cash',
  public.__hirfati_test_try_settle(
    '00000000-0000-0000-0000-000000000501',
    '00000000-0000-0000-0000-000000000504',
    'phase1-cash',
    'cash'
  )
);

select is(result->>'error', 'payment_method_unavailable', 'Phase 1: card RPC path is unavailable') from __hirfati_test_results where case_name = 'card';
select is(result->>'error', 'payment_method_unavailable', 'Phase 1: cash RPC path is unavailable') from __hirfati_test_results where case_name = 'cash';

select is(public.__hirfati_test_try_direct_order_paid('00000000-0000-0000-0000-000000000504'), 'order_payment_settlement_is_server_managed', 'direct order paid update is blocked');
select is(public.__hirfati_test_try_direct_wallet_update('00000000-0000-0000-0000-000000000501'), 'wallet_balance_is_server_managed', 'direct wallet balance update is blocked');
select is(public.__hirfati_test_try_direct_payment_insert('00000000-0000-0000-0000-000000000501', '00000000-0000-0000-0000-000000000504'), 'payments_are_server_managed', 'direct payment insert is blocked');

create trigger __hirfati_test_fail_worker_credit_trigger
before insert on public.wallet_transactions
for each row execute function public.__hirfati_test_fail_worker_credit();

select public.__hirfati_test_seed_case(
  'phase1-h',
  '00000000-0000-0000-0000-000000000601',
  '00000000-0000-0000-0000-000000000602',
  '00000000-0000-0000-0000-000000000603',
  '00000000-0000-0000-0000-000000000604',
  100,
  20
);

insert into __hirfati_test_results
values (
  'h',
  public.__hirfati_test_try_settle(
    '00000000-0000-0000-0000-000000000601',
    '00000000-0000-0000-0000-000000000604',
    'phase1-h'
  )
);

select is(result->>'error', 'forced_test_failure_after_client_debit', 'H: forced post-debit failure is raised') from __hirfati_test_results where case_name = 'h';
select is((select balance from public.wallets where user_id = '00000000-0000-0000-0000-000000000601'), 100::numeric, 'H: client debit is rolled back');
select is((select balance from public.wallets where user_id = '00000000-0000-0000-0000-000000000602'), 20::numeric, 'H: worker credit is rolled back');
select is((select count(*) from public.payments where order_id = '00000000-0000-0000-0000-000000000604' and status = 'completed'), 0::bigint, 'H: completed payment is rolled back');
select is((select count(*) from public.wallet_transactions where order_id = '00000000-0000-0000-0000-000000000604'), 0::bigint, 'H: ledger rows are rolled back');
select is((select payment_status from public.orders where id = '00000000-0000-0000-0000-000000000604'), 'pending', 'H: order remains unpaid');

select ok(to_regclass('public.payments_one_completed_per_order_idx') is not null, 'unique completed-payment-per-order index exists');
select ok(exists(select 1 from pg_constraint where conname = 'wallet_transactions_idempotency_key_key'), 'ledger idempotency key constraint exists');

select * from finish();

rollback;
