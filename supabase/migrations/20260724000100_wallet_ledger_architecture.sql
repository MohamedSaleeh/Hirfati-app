-- Wallet Ledger architecture migration for 2026-07-24.
-- Keeps the existing settle_order_payment RPC signature stable while moving
-- payments and ledger rows to the new production schema.

create extension if not exists pgcrypto;

alter table public.profiles
  drop column if exists shamcash_pin,
  drop column if exists shamcash_pin_hash,
  drop column if exists shamcash_pin_failed_attempts,
  drop column if exists shamcash_pin_locked_until,
  drop column if exists pin_attempts,
  drop column if exists last_pin_attempt;

alter table public.payments
  add column if not exists payer_id uuid
    references public.profiles(id) on delete set null,
  add column if not exists payee_id uuid
    references public.profiles(id) on delete set null,
  add column if not exists transfer_group uuid,
  add column if not exists parent_payment_id uuid
    references public.payments(id) on delete set null,
  add column if not exists currency text not null default 'SYP',
  add column if not exists created_by text not null default 'system';

alter table public.payments
  disable trigger payments_server_managed_trigger;

with payment_ledger_groups as (
  select
    payment_id,
    min(transfer_group_id) as transfer_group_id
  from public.wallet_transactions
  where payment_id is not null
    and transfer_group_id is not null
  group by payment_id
),
payment_parties as (
  select
    p.id as payment_id,
    o.client_id,
    w.user_id as worker_user_id,
    plg.transfer_group_id
  from public.payments p
  left join public.orders o on o.id = p.order_id
  left join public.workers w on w.id = o.worker_id
  left join payment_ledger_groups plg on plg.payment_id = p.id
)
update public.payments p
set
  payer_id = coalesce(p.payer_id, p.user_id, pp.client_id),
  payee_id = coalesce(p.payee_id, pp.worker_user_id),
  transfer_group = coalesce(p.transfer_group, pp.transfer_group_id),
  currency = coalesce(nullif(trim(p.currency), ''), 'SYP'),
  created_by = case
    when coalesce(p.user_id, pp.client_id) is not null then 'client'
    when p.created_by in ('system', 'client', 'worker', 'admin') then p.created_by
    else 'system'
  end
from payment_parties pp
where pp.payment_id = p.id;

update public.payments
set transfer_group = gen_random_uuid()
where transfer_group is null;

update public.payments
set provider = case
  when lower(trim(coalesce(provider, ''))) in (
    'wallet',
    'hirfati_wallet',
    'hirfati',
    'sham_cash',
    'sham_cash_mock',
    'shamcash'
  )
    or lower(trim(coalesce(payment_method, ''))) = 'wallet'
    then 'wallet'
  when lower(trim(coalesce(provider, ''))) = 'cash'
    or lower(trim(coalesce(payment_method, ''))) = 'cash'
    then 'cash'
  when lower(trim(coalesce(provider, ''))) = 'refund'
    or lower(trim(coalesce(status, ''))) = 'refunded'
    then 'refund'
  when lower(trim(coalesce(provider, ''))) = 'admin'
    then 'admin'
  else 'manual'
end;

alter table public.payments
  alter column provider set default 'manual',
  alter column currency set default 'SYP',
  alter column currency set not null,
  alter column transfer_group set not null,
  alter column created_by set default 'system',
  alter column created_by set not null;

alter table public.payments
  drop constraint if exists payments_provider_check,
  drop constraint if exists payments_created_by_check;

alter table public.payments
  add constraint payments_provider_check
  check (provider in ('wallet', 'cash', 'manual', 'refund', 'admin')),
  add constraint payments_created_by_check
  check (created_by in ('system', 'client', 'worker', 'admin'));

drop policy if exists payments_select_participant_or_admin on public.payments;
drop policy if exists payment_events_select_participant_or_admin
  on public.payment_events;

drop index if exists public.payments_user_created_idx;
drop index if exists public.payments_user_id_idx;

alter table public.payments
  drop column if exists user_id;

alter table public.payments
  enable trigger payments_server_managed_trigger;

create index if not exists payments_payer_created_idx
  on public.payments (payer_id, created_at desc);
create index if not exists payments_payee_created_idx
  on public.payments (payee_id, created_at desc);
create index if not exists payments_transfer_group_idx
  on public.payments (transfer_group);
create index if not exists payments_parent_payment_id_idx
  on public.payments (parent_payment_id);
create index if not exists payments_provider_status_created_idx
  on public.payments (provider, status, created_at desc);

create policy payments_select_participant_or_admin
on public.payments
for select
to authenticated
using (
  payer_id = auth.uid()
  or payee_id = auth.uid()
  or public.is_admin()
  or exists (
    select 1
    from public.orders o
    left join public.workers w on w.id = o.worker_id
    where o.id = payments.order_id
      and (o.client_id = auth.uid() or w.user_id = auth.uid())
  )
);

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
        p.payer_id = auth.uid()
        or p.payee_id = auth.uid()
        or o.client_id = auth.uid()
        or w.user_id = auth.uid()
      )
  )
);

alter table public.wallet_transactions
  add column if not exists currency text not null default 'SYP';

alter table public.wallet_transactions
  disable trigger wallet_transactions_immutable_trigger;

alter table public.wallet_transactions
  add column if not exists created_by_user_id uuid
    references public.profiles(id) on delete set null;

update public.wallet_transactions
set created_by_user_id = created_by
where created_by_user_id is null
  and created_by is not null;

alter table public.wallet_transactions
  drop column if exists created_by;

alter table public.wallet_transactions
  add column created_by text not null default 'system';

update public.wallet_transactions wt
set created_by = case
  when p.role in ('client', 'worker', 'admin') then p.role
  else 'system'
end
from public.profiles p
where p.id = wt.created_by_user_id;

update public.wallet_transactions
set transaction_type = case
  when lower(trim(transaction_type)) in (
    'order_payment',
    'external_payment_settlement',
    'wallet_payment'
  )
    then 'payment'
  when lower(trim(transaction_type)) in ('wallet_refund', 'payment_refund')
    then 'refund'
  when lower(trim(transaction_type)) in (
    'withdraw',
    'withdraw_request',
    'withdrawal_request'
  )
    then 'withdrawal'
  when lower(trim(transaction_type)) in ('top_up', 'topup', 'wallet_top_up')
    then 'deposit'
  when lower(trim(transaction_type)) in ('admin_adjustment', 'manual_adjustment')
    then 'adjustment'
  else lower(trim(transaction_type))
end;

update public.wallet_transactions
set metadata = metadata || jsonb_build_object(
    'legacy_transaction_type',
    transaction_type
  ),
  transaction_type = 'adjustment'
where transaction_type not in (
  'payment',
  'refund',
  'withdrawal',
  'deposit',
  'adjustment',
  'commission',
  'bonus'
);

update public.wallet_transactions
set status = case
  when lower(trim(status)) in ('success', 'succeeded', 'paid')
    then 'completed'
  when lower(trim(status)) in ('canceled')
    then 'cancelled'
  when lower(trim(status)) in ('pending', 'completed', 'failed', 'cancelled')
    then lower(trim(status))
  else 'failed'
end;

update public.wallet_transactions
set currency = coalesce(nullif(trim(currency), ''), 'SYP'),
    created_by = coalesce(nullif(trim(created_by), ''), 'system');

alter table public.wallet_transactions
  alter column currency set default 'SYP',
  alter column currency set not null,
  alter column created_by set default 'system',
  alter column created_by set not null;

alter table public.wallet_transactions
  drop constraint if exists wallet_transactions_transaction_type_check,
  drop constraint if exists wallet_transactions_direction_check,
  drop constraint if exists wallet_transactions_status_check,
  drop constraint if exists wallet_transactions_amount_positive_check,
  drop constraint if exists wallet_transactions_balance_non_negative_check,
  drop constraint if exists wallet_transactions_created_by_check;

alter table public.wallet_transactions
  add constraint wallet_transactions_transaction_type_check
    check (
      transaction_type in (
        'payment',
        'refund',
        'withdrawal',
        'deposit',
        'adjustment',
        'commission',
        'bonus'
      )
    ),
  add constraint wallet_transactions_direction_check
    check (direction in ('credit', 'debit')),
  add constraint wallet_transactions_status_check
    check (status in ('pending', 'completed', 'failed', 'cancelled')),
  add constraint wallet_transactions_amount_positive_check
    check (amount > 0),
  add constraint wallet_transactions_balance_non_negative_check
    check (balance_before >= 0 and balance_after >= 0),
  add constraint wallet_transactions_created_by_check
    check (created_by in ('system', 'client', 'worker', 'admin'));

create index if not exists wallet_transactions_currency_created_idx
  on public.wallet_transactions (currency, created_at desc);
create index if not exists wallet_transactions_created_by_created_idx
  on public.wallet_transactions (created_by, created_at desc);

alter table public.wallet_transactions
  enable trigger wallet_transactions_immutable_trigger;

create or replace function public.settle_order_payment(
  p_order_id uuid,
  p_payment_method text,
  p_idempotency_key text,
  p_provider_transaction_id text default null,
  p_provider text default 'wallet'
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
  v_transfer_group uuid := gen_random_uuid();
  v_client_balance_before numeric;
  v_client_balance_after numeric;
  v_worker_balance_before numeric;
  v_worker_balance_after numeric;
  v_client_transaction_id uuid;
  v_provider text;
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

  v_provider := case
    when v_method = 'wallet' then 'wallet'
    when lower(trim(coalesce(p_provider, ''))) in (
      'wallet',
      'cash',
      'manual',
      'refund',
      'admin'
    )
      then lower(trim(p_provider))
    else 'manual'
  end;

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
    or v_existing_payment.payer_id is distinct from v_user_id
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
  v_transfer_group := coalesce(
    v_existing_payment.transfer_group,
    v_transfer_group
  );

  insert into public.payments (
    id,
    order_id,
    amount,
    payer_id,
    payee_id,
    transfer_group,
    parent_payment_id,
    currency,
    created_by,
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
    v_worker_user_id,
    v_transfer_group,
    null,
    'SYP',
    'client',
    v_method,
    'completed',
    v_transaction_id,
    v_now,
    v_reference_number,
    0,
    jsonb_build_object(
      'settled_by',
      'settle_order_payment',
      'transfer_group',
      v_transfer_group
    ),
    v_provider,
    v_idempotency_key,
    v_now,
    v_now
  )
  on conflict (id) do update set
    amount = excluded.amount,
    payer_id = excluded.payer_id,
    payee_id = excluded.payee_id,
    transfer_group = excluded.transfer_group,
    parent_payment_id = excluded.parent_payment_id,
    currency = excluded.currency,
    created_by = excluded.created_by,
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
    currency,
    order_id,
    payment_id,
    counterparty_user_id,
    transfer_group_id,
    idempotency_key,
    title,
    metadata,
    created_at,
    created_by,
    created_by_user_id
  )
  values (
    v_user_id,
    'debit',
    'payment',
    v_amount,
    v_client_balance_before,
    v_client_balance_after,
    'completed',
    'SYP',
    p_order_id,
    v_payment_id,
    v_worker_user_id,
    v_transfer_group,
    v_idempotency_key || ':client_debit',
    'Order payment',
    jsonb_build_object(
      'payment_method',
      v_method,
      'provider',
      v_provider,
      'counterparty_user_id',
      v_worker_user_id
    ),
    v_now,
    'client',
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
    currency,
    order_id,
    payment_id,
    counterparty_user_id,
    related_transaction_id,
    transfer_group_id,
    idempotency_key,
    title,
    metadata,
    created_at,
    created_by,
    created_by_user_id
  )
  values (
    v_worker_user_id,
    'credit',
    'payment',
    v_amount,
    v_worker_balance_before,
    v_worker_balance_after,
    'completed',
    'SYP',
    p_order_id,
    v_payment_id,
    v_user_id,
    v_client_transaction_id,
    v_transfer_group,
    v_idempotency_key || ':worker_credit',
    'Order settlement',
    jsonb_build_object(
      'payment_method',
      v_method,
      'provider',
      v_provider,
      'counterparty_user_id',
      v_user_id
    ),
    v_now,
    'client',
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
      v_provider,
      'transfer_group',
      v_transfer_group
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
