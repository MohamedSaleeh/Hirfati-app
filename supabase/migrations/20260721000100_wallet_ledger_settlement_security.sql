create extension if not exists pgcrypto;

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.role = 'admin'
  );
$$;

revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;

alter table public.wallets
  add column if not exists created_at timestamptz default now(),
  add column if not exists updated_at timestamptz default now();

alter table public.payments
  add column if not exists reference_number text,
  add column if not exists transaction_id text,
  add column if not exists paid_at timestamptz,
  add column if not exists idempotency_key text,
  add column if not exists provider text not null default 'hirfati',
  add column if not exists fee numeric not null default 0,
  add column if not exists metadata jsonb not null default '{}'::jsonb,
  add column if not exists updated_at timestamptz default now();

alter table public.orders
  add column if not exists paid_at timestamptz,
  add column if not exists payment_method text,
  add column if not exists payment_transaction_id text,
  add column if not exists payment_reference text;

alter table public.payment_events
  add column if not exists payment_id uuid null references public.payments(id) on delete cascade,
  add column if not exists event_type text,
  add column if not exists event_data jsonb not null default '{}'::jsonb,
  add column if not exists created_at timestamptz not null default now(),
  add column if not exists created_by uuid null references public.profiles(id) on delete set null;

do $$
begin
  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'profiles'
      and column_name = 'shamcash_pin'
  ) then
    alter table public.profiles alter column shamcash_pin drop default;
    comment on column public.profiles.shamcash_pin is
      'Deprecated insecure plaintext PIN column. Do not read or write from Flutter; migrate to server-side shamcash_pin_hash before re-enabling PIN verification.';
  end if;
end $$;

alter table public.profiles
  add column if not exists shamcash_pin_hash text,
  add column if not exists shamcash_pin_failed_attempts integer not null default 0,
  add column if not exists shamcash_pin_locked_until timestamptz;

create table if not exists public.wallet_transactions (
  id uuid primary key default gen_random_uuid(),
  wallet_user_id uuid not null references public.profiles(id) on delete cascade,
  direction text not null,
  transaction_type text not null,
  amount numeric not null,
  balance_before numeric not null,
  balance_after numeric not null,
  status text not null default 'completed',
  order_id uuid null references public.orders(id) on delete set null,
  payment_id uuid null references public.payments(id) on delete set null,
  withdrawal_id uuid null references public.withdrawals(id) on delete set null,
  counterparty_user_id uuid null references public.profiles(id) on delete set null,
  related_transaction_id uuid null references public.wallet_transactions(id) on delete set null,
  transfer_group_id uuid null,
  idempotency_key text not null,
  title text null,
  description text null,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  created_by uuid null references public.profiles(id) on delete set null,
  constraint wallet_transactions_direction_check
    check (direction in ('credit', 'debit')),
  constraint wallet_transactions_amount_positive_check
    check (amount > 0),
  constraint wallet_transactions_balance_non_negative_check
    check (balance_before >= 0 and balance_after >= 0),
  constraint wallet_transactions_completed_math_check
    check (
      status <> 'completed'
      or (
        direction = 'credit'
        and balance_after = balance_before + amount
      )
      or (
        direction = 'debit'
        and balance_after = balance_before - amount
      )
    ),
  constraint wallet_transactions_idempotency_key_key unique (idempotency_key)
);

create index if not exists wallet_transactions_wallet_user_created_at_idx
  on public.wallet_transactions (wallet_user_id, created_at desc);
create index if not exists wallet_transactions_order_id_idx
  on public.wallet_transactions (order_id);
create index if not exists wallet_transactions_payment_id_idx
  on public.wallet_transactions (payment_id);
create index if not exists wallet_transactions_withdrawal_id_idx
  on public.wallet_transactions (withdrawal_id);
create index if not exists wallet_transactions_transfer_group_id_idx
  on public.wallet_transactions (transfer_group_id);
create index if not exists wallet_transactions_transaction_type_idx
  on public.wallet_transactions (transaction_type);
create index if not exists wallet_transactions_status_idx
  on public.wallet_transactions (status);

create or replace function public.prevent_wallet_transaction_changes()
returns trigger
language plpgsql
set search_path = public, pg_temp
as $$
begin
  raise exception 'wallet_transactions_are_immutable'
    using errcode = 'P0001';
end;
$$;

drop trigger if exists wallet_transactions_immutable_trigger
  on public.wallet_transactions;

create trigger wallet_transactions_immutable_trigger
before update or delete on public.wallet_transactions
for each row execute function public.prevent_wallet_transaction_changes();

alter table public.wallet_transactions enable row level security;

drop policy if exists wallet_transactions_select_own_or_admin
  on public.wallet_transactions;

create policy wallet_transactions_select_own_or_admin
on public.wallet_transactions
for select
to authenticated
using (wallet_user_id = auth.uid() or public.is_admin());

alter table public.wallets enable row level security;
alter table public.payments enable row level security;
alter table public.payment_events enable row level security;

drop policy if exists wallets_select_own_or_admin on public.wallets;
create policy wallets_select_own_or_admin
on public.wallets
for select
to authenticated
using (user_id = auth.uid() or public.is_admin());

drop policy if exists payments_select_participant_or_admin on public.payments;
create policy payments_select_participant_or_admin
on public.payments
for select
to authenticated
using (
  user_id = auth.uid()
  or public.is_admin()
  or exists (
    select 1
    from public.orders o
    left join public.workers w on w.id = o.worker_id
    where o.id = payments.order_id
      and (o.client_id = auth.uid() or w.user_id = auth.uid())
  )
);

drop policy if exists payment_events_select_participant_or_admin
  on public.payment_events;
create policy payment_events_select_participant_or_admin
on public.payment_events
for select
to authenticated
using (
  public.is_admin()
  or exists (
    select 1
    from public.payments p
    left join public.orders o on o.id = p.order_id
    left join public.workers w on w.id = o.worker_id
    where p.id = payment_events.payment_id
      and (
        p.user_id = auth.uid()
        or o.client_id = auth.uid()
        or w.user_id = auth.uid()
      )
  )
);

grant select on public.wallets to authenticated;
grant select on public.wallet_transactions to authenticated;
grant select on public.payments to authenticated;
grant select on public.payment_events to authenticated;

revoke insert, update, delete on public.wallets from anon, authenticated;
revoke insert, update, delete on public.wallet_transactions from anon, authenticated;
revoke insert, update, delete on public.payments from anon, authenticated;
revoke insert, update, delete on public.payment_events from anon, authenticated;

do $$
begin
  if exists (
    select 1
    from public.payments
    where status = 'completed'
      and order_id is not null
    group by order_id
    having count(*) > 1
  ) then
    raise exception 'duplicate_completed_payments_must_be_resolved_before_unique_index';
  end if;

  if exists (
    select 1
    from public.conversations
    group by least(user1_id, user2_id), greatest(user1_id, user2_id)
    having count(*) > 1
  ) then
    raise exception 'duplicate_reversed_conversations_must_be_resolved_before_unique_index';
  end if;

  if exists (
    select 1
    from public.workers
    where user_id is not null
    group by user_id
    having count(*) > 1
  ) then
    raise exception 'duplicate_workers_user_id_must_be_resolved_before_unique_index';
  end if;

  if exists (
    select 1
    from public.wallets
    where user_id is not null
    group by user_id
    having count(*) > 1
  ) then
    raise exception 'duplicate_wallets_user_id_must_be_resolved_before_unique_index';
  end if;

  if exists (
    select 1
    from public.notification_settings
    where user_id is not null
    group by user_id
    having count(*) > 1
  ) then
    raise exception 'duplicate_notification_settings_must_be_resolved_before_unique_index';
  end if;

  if exists (
    select 1
    from public.verification_requests
    where status = 'pending'
    group by user_id
    having count(*) > 1
  ) then
    raise exception 'duplicate_pending_verification_requests_must_be_resolved_before_unique_index';
  end if;
end $$;

create unique index if not exists payments_one_completed_per_order_idx
  on public.payments (order_id)
  where order_id is not null and status = 'completed';

create unique index if not exists payments_idempotency_key_idx
  on public.payments (idempotency_key)
  where idempotency_key is not null;

create unique index if not exists conversations_canonical_pair_idx
  on public.conversations (
    least(user1_id, user2_id),
    greatest(user1_id, user2_id)
  );

create unique index if not exists workers_user_id_unique_idx
  on public.workers (user_id)
  where user_id is not null;

create unique index if not exists wallets_user_id_unique_idx
  on public.wallets (user_id);

create unique index if not exists notification_settings_user_id_unique_idx
  on public.notification_settings (user_id)
  where user_id is not null;

create unique index if not exists verification_requests_one_pending_per_user_idx
  on public.verification_requests (user_id)
  where status = 'pending';

create index if not exists orders_client_status_payment_created_idx
  on public.orders (client_id, status, payment_status, created_at desc);
create index if not exists orders_worker_status_payment_created_idx
  on public.orders (worker_id, status, payment_status, created_at desc);
create index if not exists payments_user_created_idx
  on public.payments (user_id, created_at desc);
create index if not exists payments_order_status_created_idx
  on public.payments (order_id, status, created_at desc);
create index if not exists withdrawals_worker_status_created_idx
  on public.withdrawals (worker_id, status, created_at desc);

do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname = 'payments_status_check'
      and conrelid = 'public.payments'::regclass
  ) then
    alter table public.payments
      add constraint payments_status_check
      check (status in ('pending', 'processing', 'completed', 'failed', 'refunded'));
  end if;

  if not exists (
    select 1 from pg_constraint
    where conname = 'orders_payment_status_check'
      and conrelid = 'public.orders'::regclass
  ) then
    alter table public.orders
      add constraint orders_payment_status_check
      check (payment_status in ('pending', 'paid', 'failed', 'refunded'));
  end if;
end $$;

create table if not exists public.admin_audit_logs (
  id uuid primary key default gen_random_uuid(),
  admin_id uuid not null references public.profiles(id) on delete restrict,
  action text not null,
  entity_type text not null,
  entity_id uuid null,
  reason text null,
  old_values jsonb not null default '{}'::jsonb,
  new_values jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

alter table public.admin_audit_logs enable row level security;

drop policy if exists admin_audit_logs_select_admin on public.admin_audit_logs;
create policy admin_audit_logs_select_admin
on public.admin_audit_logs
for select
to authenticated
using (public.is_admin());

create or replace function public.prevent_admin_audit_log_changes()
returns trigger
language plpgsql
set search_path = public, pg_temp
as $$
begin
  raise exception 'admin_audit_logs_are_immutable'
    using errcode = 'P0001';
end;
$$;

drop trigger if exists admin_audit_logs_immutable_trigger
  on public.admin_audit_logs;

create trigger admin_audit_logs_immutable_trigger
before update or delete on public.admin_audit_logs
for each row execute function public.prevent_admin_audit_log_changes();

create or replace function public.ensure_wallet_for_current_user()
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_user_id uuid := auth.uid();
begin
  if v_user_id is null then
    raise exception 'unauthenticated' using errcode = '28000';
  end if;

  insert into public.wallets (user_id, balance, created_at, updated_at)
  values (v_user_id, 0, now(), now())
  on conflict (user_id) do nothing;
end;
$$;

revoke all on function public.ensure_wallet_for_current_user() from public;
grant execute on function public.ensure_wallet_for_current_user() to authenticated;

create or replace function public.settle_order_payment(
  p_order_id uuid,
  p_payment_method text,
  p_idempotency_key text,
  p_provider_transaction_id text default null,
  p_provider text default 'hirfati'
)
returns jsonb
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_user_id uuid := auth.uid();
  v_method text := lower(trim(coalesce(p_payment_method, '')));
  v_idempotency_key text := trim(coalesce(p_idempotency_key, ''));
  v_now timestamptz := now();
  v_order record;
  v_worker_user_id uuid;
  v_amount numeric;
  v_existing_payment record;
  v_payment_id uuid;
  v_reference_number text;
  v_transaction_id text;
  v_provider text;
  v_transfer_group_id uuid := gen_random_uuid();
  v_client_balance_before numeric;
  v_client_balance_after numeric;
  v_worker_balance_before numeric;
  v_worker_balance_after numeric;
  v_client_transaction_id uuid;
begin
  if v_user_id is null then
    raise exception 'unauthenticated' using errcode = '28000';
  end if;

  if v_idempotency_key = '' then
    raise exception 'missing_idempotency_key' using errcode = '22023';
  end if;

  if v_method not in ('wallet', 'card', 'cash') then
    raise exception 'invalid_payment_method' using errcode = '22023';
  end if;

  select p.*
  into v_existing_payment
  from public.payments p
  where p.idempotency_key = v_idempotency_key
  for update;

  if found and (
    v_existing_payment.order_id is distinct from p_order_id
    or v_existing_payment.user_id is distinct from v_user_id
    or v_existing_payment.payment_method is distinct from v_method
  ) then
    raise exception 'idempotency_conflict' using errcode = '23505';
  end if;

  if found and v_existing_payment.status = 'completed' then
    return jsonb_build_object(
      'success', true,
      'idempotent', true,
      'payment_id', v_existing_payment.id,
      'order_id', v_existing_payment.order_id,
      'payment_status', v_existing_payment.status,
      'order_payment_status', 'paid',
      'transaction_id', v_existing_payment.transaction_id,
      'reference_number', v_existing_payment.reference_number,
      'paid_at', v_existing_payment.paid_at
    );
  end if;

  select o.*
  into v_order
  from public.orders o
  where o.id = p_order_id
  for update;

  if not found then
    raise exception 'order_not_found' using errcode = 'P0002';
  end if;

  if v_order.client_id <> v_user_id then
    raise exception 'forbidden' using errcode = '42501';
  end if;

  if coalesce(v_order.payment_status, 'pending') = 'paid' then
    raise exception 'already_paid' using errcode = '23505';
  end if;

  if coalesce(v_order.status, 'pending') <> 'completed' then
    raise exception 'invalid_order_state' using errcode = 'P0001';
  end if;

  v_amount := coalesce(v_order.price, 0);
  if v_amount <= 0 then
    raise exception 'invalid_payment_amount' using errcode = '22023';
  end if;

  select w.user_id
  into v_worker_user_id
  from public.workers w
  where w.id = v_order.worker_id;

  if v_worker_user_id is null then
    raise exception 'worker_not_found' using errcode = 'P0002';
  end if;

  v_payment_id := coalesce(v_existing_payment.id, gen_random_uuid());
  v_reference_number :=
    'HF-' || upper(substr(replace(v_payment_id::text, '-', ''), 1, 12));
  v_transaction_id := coalesce(
    nullif(trim(coalesce(p_provider_transaction_id, '')), ''),
    v_method || '_' || replace(gen_random_uuid()::text, '-', '')
  );
  v_provider := coalesce(nullif(trim(coalesce(p_provider, '')), ''), 'hirfati');

  if v_method = 'cash' then
    insert into public.payments (
      id,
      order_id,
      amount,
      user_id,
      payment_method,
      status,
      reference_number,
      fee,
      metadata,
      provider,
      idempotency_key,
      created_at,
      updated_at
    )
    values (
      v_payment_id,
      p_order_id,
      v_amount,
      v_user_id,
      v_method,
      'pending',
      v_reference_number,
      0,
      jsonb_build_object('requires_worker_confirmation', true),
      'cash',
      v_idempotency_key,
      v_now,
      v_now
    )
    on conflict (id) do update set
      updated_at = excluded.updated_at,
      metadata = excluded.metadata;

    update public.orders
    set payment_method = 'cash',
        payment_reference = v_reference_number
    where id = p_order_id;

    insert into public.payment_events (
      payment_id,
      event_type,
      event_data,
      created_at,
      created_by
    )
    values (
      v_payment_id,
      'cash_payment_pending_confirmation',
      jsonb_build_object('order_id', p_order_id),
      v_now,
      v_user_id
    );

    return jsonb_build_object(
      'success', false,
      'requires_confirmation', true,
      'idempotent', false,
      'payment_id', v_payment_id,
      'order_id', p_order_id,
      'payment_status', 'pending',
      'order_payment_status', coalesce(v_order.payment_status, 'pending'),
      'reference_number', v_reference_number
    );
  end if;

  if v_method = 'card' and nullif(trim(coalesce(p_provider_transaction_id, '')), '') is null then
    raise exception 'external_payment_not_verified' using errcode = 'P0001';
  end if;

  if v_method = 'wallet' then
    select balance
    into v_client_balance_before
    from public.wallets
    where user_id = v_user_id
    for update;

    if not found or v_client_balance_before < v_amount then
      raise exception 'insufficient_wallet_balance' using errcode = 'P0001';
    end if;
  end if;

  insert into public.wallets (user_id, balance, created_at, updated_at)
  values (v_worker_user_id, 0, v_now, v_now)
  on conflict (user_id) do nothing;

  select balance
  into v_worker_balance_before
  from public.wallets
  where user_id = v_worker_user_id
  for update;

  insert into public.payments (
    id,
    order_id,
    amount,
    user_id,
    payment_method,
    status,
    transaction_id,
    paid_at,
    reference_number,
    fee,
    metadata,
    provider,
    idempotency_key,
    created_at,
    updated_at
  )
  values (
    v_payment_id,
    p_order_id,
    v_amount,
    v_user_id,
    v_method,
    'completed',
    v_transaction_id,
    v_now,
    v_reference_number,
    0,
    jsonb_build_object('settled_by', 'settle_order_payment'),
    v_provider,
    v_idempotency_key,
    v_now,
    v_now
  )
  on conflict (id) do update set
    status = 'completed',
    transaction_id = excluded.transaction_id,
    paid_at = excluded.paid_at,
    reference_number = excluded.reference_number,
    updated_at = excluded.updated_at,
    metadata = excluded.metadata
  returning id into v_payment_id;

  if v_method = 'wallet' then
    v_client_balance_after := v_client_balance_before - v_amount;

    update public.wallets
    set balance = v_client_balance_after,
        updated_at = v_now
    where user_id = v_user_id;

    insert into public.wallet_transactions (
      wallet_user_id,
      direction,
      transaction_type,
      amount,
      balance_before,
      balance_after,
      status,
      order_id,
      payment_id,
      counterparty_user_id,
      transfer_group_id,
      idempotency_key,
      title,
      metadata,
      created_at,
      created_by
    )
    values (
      v_user_id,
      'debit',
      'order_payment',
      v_amount,
      v_client_balance_before,
      v_client_balance_after,
      'completed',
      p_order_id,
      v_payment_id,
      v_worker_user_id,
      v_transfer_group_id,
      v_idempotency_key || ':client_debit',
      'Order payment',
      jsonb_build_object('payment_method', v_method),
      v_now,
      v_user_id
    )
    returning id into v_client_transaction_id;
  end if;

  v_worker_balance_after := v_worker_balance_before + v_amount;

  update public.wallets
  set balance = v_worker_balance_after,
      updated_at = v_now
  where user_id = v_worker_user_id;

  insert into public.wallet_transactions (
    wallet_user_id,
    direction,
    transaction_type,
    amount,
    balance_before,
    balance_after,
    status,
    order_id,
    payment_id,
    counterparty_user_id,
    related_transaction_id,
    transfer_group_id,
    idempotency_key,
    title,
    metadata,
    created_at,
    created_by
  )
  values (
    v_worker_user_id,
    'credit',
    case when v_method = 'card' then 'external_payment_settlement' else 'order_payment' end,
    v_amount,
    v_worker_balance_before,
    v_worker_balance_after,
    'completed',
    p_order_id,
    v_payment_id,
    v_user_id,
    v_client_transaction_id,
    v_transfer_group_id,
    v_idempotency_key || ':worker_credit',
    'Order settlement',
    jsonb_build_object('payment_method', v_method, 'provider', v_provider),
    v_now,
    v_user_id
  );

  update public.orders
  set payment_status = 'paid',
      payment_method = v_method,
      payment_transaction_id = v_transaction_id,
      payment_reference = v_reference_number,
      paid_at = v_now
  where id = p_order_id;

  insert into public.payment_events (
    payment_id,
    event_type,
    event_data,
    created_at,
    created_by
  )
  values (
    v_payment_id,
    'settlement_completed',
    jsonb_build_object(
      'order_id', p_order_id,
      'payment_method', v_method,
      'provider', v_provider
    ),
    v_now,
    v_user_id
  );

  insert into public.notifications (
    user_id,
    title,
    body,
    type,
    is_read,
    created_at
  )
  values (
    v_worker_user_id,
    'Payment received',
    'A completed order payment has been added to your wallet.',
    'payment',
    false,
    v_now
  );

  return jsonb_build_object(
    'success', true,
    'idempotent', false,
    'payment_id', v_payment_id,
    'order_id', p_order_id,
    'payment_status', 'completed',
    'order_payment_status', 'paid',
    'transaction_id', v_transaction_id,
    'reference_number', v_reference_number,
    'paid_at', v_now
  );
end;
$$;

revoke all on function public.settle_order_payment(uuid, text, text, text, text)
  from public;
grant execute on function public.settle_order_payment(uuid, text, text, text, text)
  to authenticated;
