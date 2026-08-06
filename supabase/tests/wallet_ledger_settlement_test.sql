begin;

create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select no_plan();

create temp table __wl_test_results (
  case_name text primary key,
  result jsonb not null
) on commit drop;

create or replace function public.__wl_test_seed_user(
  p_user_id uuid,
  p_role text,
  p_label text
)
returns void
language plpgsql
set search_path = public, pg_temp
as $$
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
  values (
    p_user_id,
    'authenticated',
    'authenticated',
    p_label || '-' || p_role || '@wallet-ledger.test',
    crypt('password', gen_salt('bf')),
    now(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{}'::jsonb,
    now(),
    now()
  )
  on conflict (id) do nothing;

  insert into public.profiles (id, full_name, role, phone)
  values (
    p_user_id,
    p_label || ' ' || p_role,
    p_role,
    '+99' || right(replace(p_user_id::text, '-', ''), 10)
  )
  on conflict (id) do update set
    full_name = excluded.full_name,
    role = excluded.role,
    phone = excluded.phone;
end;
$$;

create or replace function public.__wl_test_seed_case(
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
    '20000000-0000-0000-0000-' ||
    lpad(right(replace(p_order_id::text, '-', ''), 12), 12, '0')
  )::uuid;
begin
  perform public.__wl_test_seed_user(p_client_id, 'client', p_case_name);
  perform public.__wl_test_seed_user(p_worker_user_id, 'worker', p_case_name);

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
    p_case_name || ' wallet ledger test worker',
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

  perform set_config('hirfati.wallet_ledger_trusted', 'true', true);
  perform set_config(
    'hirfati.wallet_ledger_context',
    'settle_order_payment',
    true
  );

  insert into public.wallets (user_id, balance, created_at, updated_at)
  values
    (p_client_id, p_client_balance, now(), now()),
    (p_worker_user_id, p_worker_balance, now(), now())
  on conflict (user_id) do update set
    balance = excluded.balance,
    updated_at = excluded.updated_at,
    last_transaction_at = null;

  perform set_config('hirfati.wallet_ledger_trusted', 'false', true);
  perform set_config('hirfati.wallet_ledger_context', '', true);

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
    p_case_name || ' wallet ledger test order',
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

create or replace function public.__wl_test_try_settle(
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
  perform set_config('hirfati.wallet_ledger_trusted', 'false', true);
  perform set_config('hirfati.wallet_ledger_context', '', true);

  v_result := public.settle_order_payment(
    p_order_id,
    p_payment_method,
    p_idempotency_key
  );

  return jsonb_build_object('ok', true, 'result', v_result);
exception
  when others then
    perform set_config('hirfati.wallet_ledger_trusted', 'false', true);
    perform set_config('hirfati.wallet_ledger_context', '', true);

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

create or replace function public.__wl_test_try_as_authenticated(
  p_user_id uuid,
  p_sql text
)
returns text
language plpgsql
set search_path = public, pg_temp
as $$
declare
  v_error text;
begin
  perform set_config('request.jwt.claim.sub', p_user_id::text, true);
  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config('hirfati.wallet_ledger_trusted', 'false', true);
  perform set_config('hirfati.wallet_ledger_context', '', true);

  execute 'set local role authenticated';
  execute p_sql;
  execute 'reset role';

  return 'ok';
exception
  when others then
    v_error := sqlerrm;

    begin
      execute 'reset role';
    exception
      when others then
        null;
    end;

    return v_error;
end;
$$;

create or replace function public.__wl_test_try_owner_sql(p_sql text)
returns text
language plpgsql
set search_path = public, pg_temp
as $$
begin
  perform set_config('hirfati.wallet_ledger_trusted', 'false', true);
  perform set_config('hirfati.wallet_ledger_context', '', true);

  execute p_sql;

  return 'ok';
exception
  when others then
    return sqlerrm;
end;
$$;

create or replace function public.__wl_test_fail_worker_credit()
returns trigger
language plpgsql
set search_path = public, pg_temp
as $$
begin
  if new.idempotency_key = 'wallet-ledger-atomic:worker_credit' then
    raise exception 'forced_wallet_ledger_atomic_failure';
  end if;

  return new;
end;
$$;

select ok(
  exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'payments'
      and column_name in (
        'payer_id',
        'payee_id',
        'transfer_group',
        'parent_payment_id',
        'currency',
        'created_by',
        'provider'
      )
    group by table_schema, table_name
    having count(*) = 7
  ),
  'payments has final Wallet Ledger columns'
);

select ok(
  not exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'payments'
      and column_name = 'user_id'
  ),
  'payments.user_id has been removed'
);

select ok(
  exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'wallet_transactions'
      and column_name in (
        'transfer_group',
        'currency',
        'created_by',
        'created_by_user_id',
        'related_transaction_id',
        'idempotency_key'
      )
    group by table_schema, table_name
    having count(*) = 6
  ),
  'wallet_transactions has final Wallet Ledger columns'
);

select ok(
  not exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'wallet_transactions'
      and column_name = 'transfer_group_id'
  ),
  'wallet_transactions.transfer_group_id has been removed'
);

select ok(
  (
    select column_default
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'payments'
      and column_name = 'provider'
  ) in ('''wallet''::text', '''wallet'''),
  'payments.provider defaults to wallet'
);

select is(
  (
    select count(*)
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'profiles'
      and column_name in (
        'shamcash_pin',
        'shamcash_pin_hash',
        'shamcash_pin_failed_attempts',
        'shamcash_pin_locked_until',
        'pin_attempts',
        'last_pin_attempt'
      )
  ),
  0::bigint,
  'profiles has no ShamCash or legacy PIN columns'
);

select ok(
  to_regprocedure(
    'public.settle_order_payment(uuid,text,text,text,text)'
  ) is not null,
  'settle_order_payment five-argument RPC exists'
);

select like(
  pg_get_function_arguments(
    'public.settle_order_payment(uuid,text,text,text,text)'::regprocedure
  ),
  '%p_provider text DEFAULT ''wallet''::text%',
  'settle_order_payment provider default is wallet'
);

select is(
  has_function_privilege(
    'anon',
    'public.settle_order_payment(uuid,text,text,text,text)',
    'execute'
  ),
  false,
  'anon cannot execute settle_order_payment'
);

select is(
  has_function_privilege(
    'authenticated',
    'public.settle_order_payment(uuid,text,text,text,text)',
    'execute'
  ),
  true,
  'authenticated can execute settle_order_payment'
);

select is(has_table_privilege('authenticated', 'public.wallets', 'insert'), false, 'authenticated cannot insert wallets directly');
select is(has_table_privilege('authenticated', 'public.wallets', 'update'), false, 'authenticated cannot update wallets directly');
select is(has_table_privilege('authenticated', 'public.wallet_transactions', 'insert'), false, 'authenticated cannot insert wallet ledger rows directly');
select is(has_table_privilege('authenticated', 'public.wallet_transactions', 'update'), false, 'authenticated cannot update wallet ledger rows directly');
select is(has_table_privilege('authenticated', 'public.wallet_transactions', 'delete'), false, 'authenticated cannot delete wallet ledger rows directly');
select is(has_table_privilege('authenticated', 'public.payments', 'insert'), false, 'authenticated cannot insert payments directly');
select is(has_table_privilege('authenticated', 'public.payments', 'update'), false, 'authenticated cannot update payments directly');
select is(has_table_privilege('authenticated', 'public.payments', 'delete'), false, 'authenticated cannot delete payments directly');
select is(has_table_privilege('authenticated', 'public.payment_events', 'insert'), false, 'authenticated cannot insert payment events directly');
select is(has_table_privilege('authenticated', 'public.payment_events', 'update'), false, 'authenticated cannot update payment events directly');
select is(has_table_privilege('authenticated', 'public.payment_events', 'delete'), false, 'authenticated cannot delete payment events directly');

select public.__wl_test_seed_case(
  'wallet-ledger-success',
  '10000000-0000-0000-0000-000000000101',
  '10000000-0000-0000-0000-000000000102',
  '10000000-0000-0000-0000-000000000103',
  '10000000-0000-0000-0000-000000000104',
  100,
  20,
  'completed',
  'pending',
  30
);

insert into __wl_test_results
values (
  'success',
  public.__wl_test_try_settle(
    '10000000-0000-0000-0000-000000000101',
    '10000000-0000-0000-0000-000000000104',
    'wallet-ledger-success'
  )
);

select is((result->>'ok')::boolean, true, 'successful wallet payment RPC succeeds')
from __wl_test_results
where case_name = 'success';

select is(((result->'result'->>'idempotent')::boolean), false, 'first successful payment is not an idempotent retry')
from __wl_test_results
where case_name = 'success';

select is(
  (
    select count(*)
    from public.payments
    where order_id = '10000000-0000-0000-0000-000000000104'
  ),
  1::bigint,
  'successful payment creates exactly one payment row'
);

select is(
  (
    select payer_id
    from public.payments
    where order_id = '10000000-0000-0000-0000-000000000104'
  ),
  '10000000-0000-0000-0000-000000000101'::uuid,
  'payment payer_id is the client'
);

select is(
  (
    select payee_id
    from public.payments
    where order_id = '10000000-0000-0000-0000-000000000104'
  ),
  '10000000-0000-0000-0000-000000000102'::uuid,
  'payment payee_id is the worker profile user'
);

select is(
  (
    select provider
    from public.payments
    where order_id = '10000000-0000-0000-0000-000000000104'
  ),
  'wallet',
  'payment provider is wallet'
);

select is(
  (
    select payment_method
    from public.payments
    where order_id = '10000000-0000-0000-0000-000000000104'
  ),
  'wallet',
  'payment method is wallet'
);

select is(
  (
    select status
    from public.payments
    where order_id = '10000000-0000-0000-0000-000000000104'
  ),
  'completed',
  'payment status is completed'
);

select is(
  (
    select currency
    from public.payments
    where order_id = '10000000-0000-0000-0000-000000000104'
  ),
  'SYP',
  'payment currency is SYP'
);

select is(
  (
    select created_by
    from public.payments
    where order_id = '10000000-0000-0000-0000-000000000104'
  ),
  'client',
  'payment created_by is client'
);

select ok(
  (
    select transfer_group is not null
    from public.payments
    where order_id = '10000000-0000-0000-0000-000000000104'
  ),
  'payment transfer_group is populated'
);

select is(
  (
    select balance
    from public.wallets
    where user_id = '10000000-0000-0000-0000-000000000101'
  ),
  70::numeric,
  'client wallet balance decreases by order amount'
);

select is(
  (
    select balance
    from public.wallets
    where user_id = '10000000-0000-0000-0000-000000000102'
  ),
  50::numeric,
  'worker wallet balance increases by order amount'
);

select is(
  (
    select count(*)
    from public.wallets
    where user_id in (
      '10000000-0000-0000-0000-000000000101'::uuid,
      '10000000-0000-0000-0000-000000000102'::uuid
    )
      and last_transaction_at is not null
  ),
  2::bigint,
  'both wallets update last_transaction_at'
);

select is(
  (
    select count(*)
    from public.wallet_transactions
    where order_id = '10000000-0000-0000-0000-000000000104'
  ),
  2::bigint,
  'successful payment creates exactly two wallet ledger rows'
);

select ok(
  exists (
    select 1
    from public.wallet_transactions
    where order_id = '10000000-0000-0000-0000-000000000104'
      and wallet_user_id = '10000000-0000-0000-0000-000000000101'
      and direction = 'debit'
      and transaction_type = 'payment'
      and status = 'completed'
      and currency = 'SYP'
      and balance_before = 100
      and balance_after = 70
  ),
  'client ledger row is a completed SYP payment debit with correct math'
);

select ok(
  exists (
    select 1
    from public.wallet_transactions
    where order_id = '10000000-0000-0000-0000-000000000104'
      and wallet_user_id = '10000000-0000-0000-0000-000000000102'
      and direction = 'credit'
      and transaction_type = 'payment'
      and status = 'completed'
      and currency = 'SYP'
      and balance_before = 20
      and balance_after = 50
  ),
  'worker ledger row is a completed SYP payment credit with correct math'
);

select ok(
  exists (
    select 1
    from public.wallet_transactions client_tx
    join public.wallet_transactions worker_tx
      on worker_tx.related_transaction_id = client_tx.id
    join public.payments p on p.id = client_tx.payment_id
    where p.order_id = '10000000-0000-0000-0000-000000000104'
      and client_tx.direction = 'debit'
      and worker_tx.direction = 'credit'
      and client_tx.transfer_group = p.transfer_group
      and worker_tx.transfer_group = p.transfer_group
  ),
  'worker credit references client debit and both ledger rows share payment transfer_group'
);

select is(
  (
    select count(*)
    from public.payment_events pe
    join public.payments p on p.id = pe.payment_id
    where p.order_id = '10000000-0000-0000-0000-000000000104'
      and (pe.event_data->>'transfer_group')::uuid = p.transfer_group
  ),
  1::bigint,
  'exactly one payment event contains the same transfer_group'
);

select is(
  (
    select payment_status
    from public.orders
    where id = '10000000-0000-0000-0000-000000000104'
  ),
  'paid',
  'order is marked paid'
);

select ok(
  exists (
    select 1
    from public.orders
    where id = '10000000-0000-0000-0000-000000000104'
      and payment_transaction_id is not null
      and payment_reference is not null
      and paid_at is not null
  ),
  'order receives payment transaction id, reference, and paid_at'
);

insert into __wl_test_results
values (
  'retry',
  public.__wl_test_try_settle(
    '10000000-0000-0000-0000-000000000101',
    '10000000-0000-0000-0000-000000000104',
    'wallet-ledger-success'
  )
);

select is((result->>'ok')::boolean, true, 'idempotent retry succeeds')
from __wl_test_results
where case_name = 'retry';

select is(((result->'result'->>'idempotent')::boolean), true, 'idempotent retry is reported as idempotent')
from __wl_test_results
where case_name = 'retry';

select is((select count(*) from public.payments where order_id = '10000000-0000-0000-0000-000000000104'), 1::bigint, 'idempotent retry creates no second payment');
select is((select count(*) from public.wallet_transactions where order_id = '10000000-0000-0000-0000-000000000104'), 2::bigint, 'idempotent retry creates no additional ledger rows');
select is((select balance from public.wallets where user_id = '10000000-0000-0000-0000-000000000101'), 70::numeric, 'idempotent retry does not mutate client balance');
select is((select balance from public.wallets where user_id = '10000000-0000-0000-0000-000000000102'), 50::numeric, 'idempotent retry does not mutate worker balance');
select is((select count(*) from public.payment_events pe join public.payments p on p.id = pe.payment_id where p.order_id = '10000000-0000-0000-0000-000000000104'), 1::bigint, 'idempotent retry creates no duplicate payment event');

select public.__wl_test_seed_case(
  'wallet-ledger-conflict-a',
  '10000000-0000-0000-0000-000000000201',
  '10000000-0000-0000-0000-000000000202',
  '10000000-0000-0000-0000-000000000203',
  '10000000-0000-0000-0000-000000000204',
  100,
  20
);

select public.__wl_test_seed_case(
  'wallet-ledger-conflict-b',
  '10000000-0000-0000-0000-000000000201',
  '10000000-0000-0000-0000-000000000202',
  '10000000-0000-0000-0000-000000000203',
  '10000000-0000-0000-0000-000000000205',
  100,
  20
);

insert into __wl_test_results
values (
  'conflict-first',
  public.__wl_test_try_settle(
    '10000000-0000-0000-0000-000000000201',
    '10000000-0000-0000-0000-000000000204',
    'wallet-ledger-conflict'
  )
);

insert into __wl_test_results
values (
  'conflict-second',
  public.__wl_test_try_settle(
    '10000000-0000-0000-0000-000000000201',
    '10000000-0000-0000-0000-000000000205',
    'wallet-ledger-conflict'
  )
);

select is(result->>'error', 'idempotency_conflict', 'reusing idempotency key for another order is rejected')
from __wl_test_results
where case_name = 'conflict-second';

select is((select count(*) from public.payments where order_id = '10000000-0000-0000-0000-000000000205'), 0::bigint, 'idempotency conflict creates no payment for conflicting order');
select is((select count(*) from public.wallet_transactions where order_id = '10000000-0000-0000-0000-000000000205'), 0::bigint, 'idempotency conflict creates no ledger rows');
select is((select balance from public.wallets where user_id = '10000000-0000-0000-0000-000000000201'), 70::numeric, 'idempotency conflict does not mutate client balance again');
select is((select balance from public.wallets where user_id = '10000000-0000-0000-0000-000000000202'), 50::numeric, 'idempotency conflict does not mutate worker balance again');

select public.__wl_test_seed_case(
  'wallet-ledger-insufficient',
  '10000000-0000-0000-0000-000000000301',
  '10000000-0000-0000-0000-000000000302',
  '10000000-0000-0000-0000-000000000303',
  '10000000-0000-0000-0000-000000000304',
  10,
  20,
  'completed',
  'pending',
  30
);

insert into __wl_test_results
values (
  'insufficient',
  public.__wl_test_try_settle(
    '10000000-0000-0000-0000-000000000301',
    '10000000-0000-0000-0000-000000000304',
    'wallet-ledger-insufficient'
  )
);

select is(result->>'error', 'insufficient_wallet_balance', 'insufficient wallet balance is rejected')
from __wl_test_results
where case_name = 'insufficient';

select is((select balance from public.wallets where user_id = '10000000-0000-0000-0000-000000000301'), 10::numeric, 'insufficient balance leaves client balance unchanged');
select is((select balance from public.wallets where user_id = '10000000-0000-0000-0000-000000000302'), 20::numeric, 'insufficient balance leaves worker balance unchanged');
select is((select count(*) from public.payments where order_id = '10000000-0000-0000-0000-000000000304'), 0::bigint, 'insufficient balance creates no payment');
select is((select count(*) from public.wallet_transactions where order_id = '10000000-0000-0000-0000-000000000304'), 0::bigint, 'insufficient balance creates no ledger rows');
select is((select count(*) from public.payment_events pe join public.payments p on p.id = pe.payment_id where p.order_id = '10000000-0000-0000-0000-000000000304'), 0::bigint, 'insufficient balance creates no payment event');
select is((select payment_status from public.orders where id = '10000000-0000-0000-0000-000000000304'), 'pending', 'insufficient balance leaves order unpaid');

select public.__wl_test_seed_case(
  'wallet-ledger-invalid-state',
  '10000000-0000-0000-0000-000000000401',
  '10000000-0000-0000-0000-000000000402',
  '10000000-0000-0000-0000-000000000403',
  '10000000-0000-0000-0000-000000000404',
  100,
  20,
  'accepted',
  'pending',
  30
);

insert into __wl_test_results
values (
  'invalid-state',
  public.__wl_test_try_settle(
    '10000000-0000-0000-0000-000000000401',
    '10000000-0000-0000-0000-000000000404',
    'wallet-ledger-invalid-state'
  )
);

select is(result->>'error', 'invalid_order_state', 'non-completed order is rejected')
from __wl_test_results
where case_name = 'invalid-state';

select is((select balance from public.wallets where user_id = '10000000-0000-0000-0000-000000000401'), 100::numeric, 'invalid order state leaves client balance unchanged');
select is((select balance from public.wallets where user_id = '10000000-0000-0000-0000-000000000402'), 20::numeric, 'invalid order state leaves worker balance unchanged');
select is((select count(*) from public.payments where order_id = '10000000-0000-0000-0000-000000000404'), 0::bigint, 'invalid order state creates no payment');
select is((select count(*) from public.wallet_transactions where order_id = '10000000-0000-0000-0000-000000000404'), 0::bigint, 'invalid order state creates no ledger rows');

select public.__wl_test_seed_case(
  'wallet-ledger-unauthorized',
  '10000000-0000-0000-0000-000000000501',
  '10000000-0000-0000-0000-000000000502',
  '10000000-0000-0000-0000-000000000503',
  '10000000-0000-0000-0000-000000000504',
  100,
  20,
  'completed',
  'pending',
  30
);

select public.__wl_test_seed_user(
  '10000000-0000-0000-0000-000000000505',
  'client',
  'wallet-ledger-unauthorized-other'
);

insert into __wl_test_results
values (
  'unauthorized',
  public.__wl_test_try_settle(
    '10000000-0000-0000-0000-000000000505',
    '10000000-0000-0000-0000-000000000504',
    'wallet-ledger-unauthorized'
  )
);

select is(result->>'error', 'forbidden', 'non-client caller is rejected')
from __wl_test_results
where case_name = 'unauthorized';

select is((select balance from public.wallets where user_id = '10000000-0000-0000-0000-000000000501'), 100::numeric, 'unauthorized caller leaves real client balance unchanged');
select is((select balance from public.wallets where user_id = '10000000-0000-0000-0000-000000000502'), 20::numeric, 'unauthorized caller leaves worker balance unchanged');
select is((select count(*) from public.payments where order_id = '10000000-0000-0000-0000-000000000504'), 0::bigint, 'unauthorized caller creates no payment');
select is((select count(*) from public.wallet_transactions where order_id = '10000000-0000-0000-0000-000000000504'), 0::bigint, 'unauthorized caller creates no ledger rows');

drop trigger if exists __wl_test_fail_worker_credit_trigger
  on public.wallet_transactions;
create trigger __wl_test_fail_worker_credit_trigger
before insert on public.wallet_transactions
for each row execute function public.__wl_test_fail_worker_credit();

select public.__wl_test_seed_case(
  'wallet-ledger-atomic',
  '10000000-0000-0000-0000-000000000601',
  '10000000-0000-0000-0000-000000000602',
  '10000000-0000-0000-0000-000000000603',
  '10000000-0000-0000-0000-000000000604',
  100,
  20,
  'completed',
  'pending',
  30
);

insert into __wl_test_results
values (
  'atomic',
  public.__wl_test_try_settle(
    '10000000-0000-0000-0000-000000000601',
    '10000000-0000-0000-0000-000000000604',
    'wallet-ledger-atomic'
  )
);

select is(result->>'error', 'forced_wallet_ledger_atomic_failure', 'forced failure after client debit is surfaced')
from __wl_test_results
where case_name = 'atomic';

select is((select balance from public.wallets where user_id = '10000000-0000-0000-0000-000000000601'), 100::numeric, 'forced failure rolls back client debit');
select is((select balance from public.wallets where user_id = '10000000-0000-0000-0000-000000000602'), 20::numeric, 'forced failure rolls back worker credit');
select is((select count(*) from public.payments where order_id = '10000000-0000-0000-0000-000000000604'), 0::bigint, 'forced failure rolls back payment row');
select is((select count(*) from public.wallet_transactions where order_id = '10000000-0000-0000-0000-000000000604'), 0::bigint, 'forced failure rolls back ledger rows');
select is((select count(*) from public.payment_events pe join public.payments p on p.id = pe.payment_id where p.order_id = '10000000-0000-0000-0000-000000000604'), 0::bigint, 'forced failure rolls back payment event');
select is((select payment_status from public.orders where id = '10000000-0000-0000-0000-000000000604'), 'pending', 'forced failure leaves order unpaid');

drop trigger if exists __wl_test_fail_worker_credit_trigger
  on public.wallet_transactions;

select public.__wl_test_seed_case(
  'wallet-ledger-direct',
  '10000000-0000-0000-0000-000000000701',
  '10000000-0000-0000-0000-000000000702',
  '10000000-0000-0000-0000-000000000703',
  '10000000-0000-0000-0000-000000000704',
  100,
  20,
  'completed',
  'pending',
  30
);

select ok(
  public.__wl_test_try_as_authenticated(
    '10000000-0000-0000-0000-000000000701',
    format(
      'update public.wallets set balance = balance + 1 where user_id = %L::uuid',
      '10000000-0000-0000-0000-000000000701'
    )
  ) <> 'ok',
  'authenticated direct wallet balance update is rejected'
);

select ok(
  public.__wl_test_try_as_authenticated(
    '10000000-0000-0000-0000-000000000701',
    format(
      'insert into public.payments (order_id, amount, payer_id, payee_id, transfer_group, currency, created_by, payment_method, status, provider, metadata, idempotency_key, created_at, updated_at) values (%L::uuid, 30, %L::uuid, %L::uuid, gen_random_uuid(), ''SYP'', ''client'', ''wallet'', ''completed'', ''wallet'', ''{}''::jsonb, ''wallet-ledger-direct-payment'', now(), now())',
      '10000000-0000-0000-0000-000000000704',
      '10000000-0000-0000-0000-000000000701',
      '10000000-0000-0000-0000-000000000702'
    )
  ) <> 'ok',
  'authenticated direct payment insert is rejected'
);

select ok(
  public.__wl_test_try_as_authenticated(
    '10000000-0000-0000-0000-000000000701',
    format(
      'update public.orders set payment_status = ''paid'', paid_at = now() where id = %L::uuid',
      '10000000-0000-0000-0000-000000000704'
    )
  ) <> 'ok',
  'authenticated direct order paid update is rejected'
);

select ok(
  public.__wl_test_try_as_authenticated(
    '10000000-0000-0000-0000-000000000701',
    format(
      'insert into public.wallet_transactions (wallet_user_id, counterparty_user_id, order_id, transaction_type, direction, amount, balance_before, balance_after, status, transfer_group, currency, created_by, created_by_user_id, idempotency_key, metadata) values (%L::uuid, %L::uuid, %L::uuid, ''payment'', ''debit'', 30, 100, 70, ''completed'', gen_random_uuid(), ''SYP'', ''client'', %L::uuid, ''wallet-ledger-direct-ledger'', ''{}''::jsonb)',
      '10000000-0000-0000-0000-000000000701',
      '10000000-0000-0000-0000-000000000702',
      '10000000-0000-0000-0000-000000000704',
      '10000000-0000-0000-0000-000000000701'
    )
  ) <> 'ok',
  'authenticated direct wallet ledger insert is rejected'
);

select ok(
  public.__wl_test_try_as_authenticated(
    '10000000-0000-0000-0000-000000000701',
    format(
      'update public.payments set metadata = metadata || ''{"direct_update":true}''::jsonb where order_id = %L::uuid',
      '10000000-0000-0000-0000-000000000104'
    )
  ) <> 'ok',
  'authenticated direct payment update is rejected'
);

select ok(
  public.__wl_test_try_as_authenticated(
    '10000000-0000-0000-0000-000000000701',
    format(
      'delete from public.payments where order_id = %L::uuid',
      '10000000-0000-0000-0000-000000000104'
    )
  ) <> 'ok',
  'authenticated direct payment delete is rejected'
);

select ok(
  public.__wl_test_try_as_authenticated(
    '10000000-0000-0000-0000-000000000701',
    format(
      'update public.wallet_transactions set metadata = metadata || ''{"direct_update":true}''::jsonb where order_id = %L::uuid',
      '10000000-0000-0000-0000-000000000104'
    )
  ) <> 'ok',
  'authenticated direct wallet ledger update is rejected'
);

select ok(
  public.__wl_test_try_as_authenticated(
    '10000000-0000-0000-0000-000000000701',
    format(
      'delete from public.wallet_transactions where order_id = %L::uuid',
      '10000000-0000-0000-0000-000000000104'
    )
  ) <> 'ok',
  'authenticated direct wallet ledger delete is rejected'
);

select is(
  public.__wl_test_try_owner_sql(
    format(
      'update public.wallet_transactions set metadata = metadata || ''{"immutable":true}''::jsonb where order_id = %L::uuid and direction = ''debit''',
      '10000000-0000-0000-0000-000000000104'
    )
  ),
  'wallet_transactions_are_immutable',
  'ledger row cannot be updated directly, even by table owner without trusted context'
);

select is(
  public.__wl_test_try_owner_sql(
    format(
      'delete from public.wallet_transactions where order_id = %L::uuid and direction = ''debit''',
      '10000000-0000-0000-0000-000000000104'
    )
  ),
  'wallet_transactions_are_immutable',
  'ledger row cannot be deleted directly, even by table owner without trusted context'
);

select * from finish();

rollback;
