-- Phase 1 wallet-payment validation corrections.
-- Keep this as an incremental migration because the previous wallet migration
-- may already be applied in a staging database.

revoke all on table public.wallets
  from public, anon, authenticated;
revoke all on table public.wallet_transactions
  from public, anon, authenticated;
revoke all on table public.payments
  from public, anon, authenticated;
revoke all on table public.payment_events
  from public, anon, authenticated;

grant select on table public.wallets to authenticated;
grant select on table public.wallet_transactions to authenticated;
grant select on table public.payments to authenticated;
grant select on table public.payment_events to authenticated;

create or replace function public.prevent_direct_wallet_balance_changes()
returns trigger
language plpgsql
set search_path = public, pg_temp
as $$
begin
  if current_setting('hirfati.settle_order_payment', true) = 'true' then
    if tg_op = 'DELETE' then
      return old;
    end if;
    return new;
  end if;

  if tg_op = 'INSERT' and coalesce(new.balance, 0) <> 0 then
    raise exception 'wallet_balance_is_server_managed'
      using errcode = '42501';
  end if;

  if tg_op = 'UPDATE' and old.balance is distinct from new.balance then
    raise exception 'wallet_balance_is_server_managed'
      using errcode = '42501';
  end if;

  if tg_op = 'DELETE' then
    raise exception 'wallet_rows_are_server_managed'
      using errcode = '42501';
  end if;

  if tg_op = 'DELETE' then
    return old;
  end if;

  return new;
end;
$$;

revoke all on function public.prevent_direct_wallet_balance_changes()
  from public;

drop trigger if exists wallets_server_managed_balance_trigger
  on public.wallets;

create trigger wallets_server_managed_balance_trigger
before insert or update or delete on public.wallets
for each row execute function public.prevent_direct_wallet_balance_changes();

create or replace function public.prevent_direct_payment_changes()
returns trigger
language plpgsql
set search_path = public, pg_temp
as $$
begin
  if current_setting('hirfati.settle_order_payment', true) = 'true' then
    if tg_op = 'DELETE' then
      return old;
    end if;
    return new;
  end if;

  raise exception 'payments_are_server_managed'
    using errcode = '42501';
end;
$$;

revoke all on function public.prevent_direct_payment_changes()
  from public;

drop trigger if exists payments_server_managed_trigger
  on public.payments;

create trigger payments_server_managed_trigger
before insert or update or delete on public.payments
for each row execute function public.prevent_direct_payment_changes();

create or replace function public.prevent_direct_order_payment_field_changes()
returns trigger
language plpgsql
set search_path = public, pg_temp
as $$
begin
  if current_setting('hirfati.settle_order_payment', true) = 'true' then
    return new;
  end if;

  if coalesce(old.payment_status, 'pending') = 'paid' and (
    old.payment_status is distinct from new.payment_status
    or old.payment_method is distinct from new.payment_method
    or old.payment_transaction_id is distinct from new.payment_transaction_id
    or old.payment_reference is distinct from new.payment_reference
    or old.paid_at is distinct from new.paid_at
  ) then
    raise exception 'paid_order_payment_fields_are_immutable'
      using errcode = '42501';
  end if;

  if coalesce(old.payment_status, 'pending') <> 'paid'
    and coalesce(new.payment_status, 'pending') = 'paid' then
    raise exception 'order_payment_settlement_is_server_managed'
      using errcode = '42501';
  end if;

  if old.paid_at is distinct from new.paid_at and new.paid_at is not null then
    raise exception 'order_payment_settlement_is_server_managed'
      using errcode = '42501';
  end if;

  if old.payment_transaction_id is distinct from new.payment_transaction_id
    and new.payment_transaction_id is not null then
    raise exception 'order_payment_settlement_is_server_managed'
      using errcode = '42501';
  end if;

  if old.payment_reference is distinct from new.payment_reference
    and new.payment_reference is not null then
    raise exception 'order_payment_settlement_is_server_managed'
      using errcode = '42501';
  end if;

  return new;
end;
$$;

revoke all on function public.prevent_direct_order_payment_field_changes()
  from public;

drop trigger if exists orders_server_managed_payment_fields_trigger
  on public.orders;

create trigger orders_server_managed_payment_fields_trigger
before update of payment_status,
  payment_method,
  payment_transaction_id,
  payment_reference,
  paid_at on public.orders
for each row execute function public.prevent_direct_order_payment_field_changes();

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

  if v_method in ('card', 'cash') then
    raise exception 'payment_method_unavailable' using errcode = '0A000';
  end if;

  perform pg_advisory_xact_lock(
    hashtextextended('settle_order_payment:' || v_idempotency_key, 0)
  );

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

  if v_order.client_id is distinct from v_user_id then
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
  where w.id = v_order.worker_id
  for update;

  if v_worker_user_id is null then
    raise exception 'worker_not_found' using errcode = 'P0002';
  end if;

  select balance
  into v_client_balance_before
  from public.wallets
  where user_id = v_user_id
  for update;

  if not found or v_client_balance_before < v_amount then
    raise exception 'insufficient_wallet_balance' using errcode = 'P0001';
  end if;

  perform set_config('hirfati.settle_order_payment', 'true', true);

  insert into public.wallets (user_id, balance, created_at, updated_at)
  values (v_worker_user_id, 0, v_now, v_now)
  on conflict (user_id) do nothing;

  select balance
  into v_worker_balance_before
  from public.wallets
  where user_id = v_worker_user_id
  for update;

  if not found then
    raise exception 'worker_wallet_not_found' using errcode = 'P0002';
  end if;

  v_payment_id := coalesce(v_existing_payment.id, gen_random_uuid());
  v_reference_number :=
    'HF-' || upper(substr(replace(v_payment_id::text, '-', ''), 1, 12));
  v_transaction_id :=
    'wallet_' || replace(gen_random_uuid()::text, '-', '');

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
    jsonb_build_object(
      'settled_by',
      'settle_order_payment',
      'transfer_group_id',
      v_transfer_group_id
    ),
    'hirfati_wallet',
    v_idempotency_key,
    v_now,
    v_now
  )
  on conflict (id) do update set
    amount = excluded.amount,
    user_id = excluded.user_id,
    payment_method = excluded.payment_method,
    status = 'completed',
    transaction_id = excluded.transaction_id,
    paid_at = excluded.paid_at,
    reference_number = excluded.reference_number,
    fee = excluded.fee,
    updated_at = excluded.updated_at,
    metadata = excluded.metadata,
    provider = excluded.provider
  returning id into v_payment_id;

  v_client_balance_after := v_client_balance_before - v_amount;
  v_worker_balance_after := v_worker_balance_before + v_amount;

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
    jsonb_build_object(
      'payment_method',
      v_method,
      'counterparty_user_id',
      v_worker_user_id
    ),
    v_now,
    v_user_id
  )
  returning id into v_client_transaction_id;

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
    'order_payment',
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
    jsonb_build_object(
      'payment_method',
      v_method,
      'provider',
      'hirfati_wallet',
      'counterparty_user_id',
      v_user_id
    ),
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
      'order_id',
      p_order_id,
      'payment_method',
      v_method,
      'provider',
      'hirfati_wallet',
      'transfer_group_id',
      v_transfer_group_id
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

  perform set_config('hirfati.settle_order_payment', 'false', true);

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
