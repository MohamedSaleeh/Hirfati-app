-- Consolidated Wallet Ledger migration for existing Hirfati databases.
-- This migration upgrades the current application schema directly without
-- requiring prior wallet/payment migrations to have been executed.

create extension if not exists pgcrypto;

-- ---------------------------------------------------------------------------
-- 1. Remove legacy wallet/PIN columns.
-- ---------------------------------------------------------------------------

alter table public.profiles
  drop column if exists shamcash_pin,
  drop column if exists shamcash_pin_hash,
  drop column if exists shamcash_pin_failed_attempts,
  drop column if exists shamcash_pin_locked_until,
  drop column if exists pin_attempts,
  drop column if exists last_pin_attempt;

-- ---------------------------------------------------------------------------
-- 2. Admin helper used by RLS policies.
-- ---------------------------------------------------------------------------

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
revoke execute on function public.is_admin() from anon;
grant execute on function public.is_admin() to authenticated;

create or replace function public.is_wallet_ledger_trusted_context()
returns boolean
language sql
stable
set search_path = public, pg_temp
as $$
  select coalesce(
    current_setting('hirfati.wallet_ledger_trusted', true) = 'true'
    and current_setting('hirfati.wallet_ledger_context', true)
      = 'settle_order_payment'
    and current_user not in ('anon', 'authenticated'),
    false
  );
$$;

revoke all on function public.is_wallet_ledger_trusted_context()
  from public;
grant execute on function public.is_wallet_ledger_trusted_context()
  to authenticated, service_role;

-- ---------------------------------------------------------------------------
-- 3. Ensure order/payment event columns required by settlement exist.
-- ---------------------------------------------------------------------------

alter table public.orders
  add column if not exists paid_at timestamptz,
  add column if not exists payment_method text,
  add column if not exists payment_transaction_id text,
  add column if not exists payment_reference text;

create table if not exists public.payment_events (
  id uuid primary key default gen_random_uuid(),
  payment_id uuid,
  event_type text,
  event_data jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  created_by uuid
);

alter table public.payment_events
  add column if not exists id uuid default gen_random_uuid(),
  add column if not exists payment_id uuid,
  add column if not exists event_type text,
  add column if not exists event_data jsonb not null default '{}'::jsonb,
  add column if not exists created_at timestamptz not null default now(),
  add column if not exists created_by uuid;

update public.payment_events
set id = gen_random_uuid()
where id is null;

alter table public.payment_events
  alter column id set default gen_random_uuid(),
  alter column id set not null,
  alter column event_data set default '{}'::jsonb,
  alter column event_data set not null,
  alter column created_at set default now(),
  alter column created_at set not null;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.payment_events'::regclass
      and contype = 'p'
  ) then
    if exists (
      select 1
      from public.payment_events
      group by id
      having count(*) > 1
    ) then
      raise exception 'duplicate_payment_event_ids_must_be_resolved_before_primary_key';
    end if;

    alter table public.payment_events
      add constraint payment_events_pkey primary key (id);
  end if;

  if exists (
    select 1
    from public.payment_events pe
    left join public.payments p on p.id = pe.payment_id
    where pe.payment_id is not null
      and p.id is null
  ) then
    raise exception 'payment_events_invalid_payment_id_must_be_resolved_before_foreign_key';
  end if;

  if exists (
    select 1
    from public.payment_events pe
    left join public.profiles pr on pr.id = pe.created_by
    where pe.created_by is not null
      and pr.id is null
  ) then
    raise exception 'payment_events_invalid_created_by_must_be_resolved_before_foreign_key';
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.payment_events'::regclass
      and conname = 'payment_events_payment_id_fkey'
  ) then
    alter table public.payment_events
      add constraint payment_events_payment_id_fkey
      foreign key (payment_id)
      references public.payments(id)
      on delete cascade
      not valid;
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.payment_events'::regclass
      and conname = 'payment_events_created_by_fkey'
  ) then
    alter table public.payment_events
      add constraint payment_events_created_by_fkey
      foreign key (created_by)
      references public.profiles(id)
      on delete set null
      not valid;
  end if;
end $$;

-- ---------------------------------------------------------------------------
-- 4. Upgrade wallets without changing existing balances.
-- ---------------------------------------------------------------------------

alter table public.wallets
  add column if not exists created_at timestamptz default now(),
  add column if not exists updated_at timestamptz default now(),
  add column if not exists is_locked boolean not null default false,
  add column if not exists last_transaction_at timestamptz;

alter table public.wallets
  alter column created_at set default now(),
  alter column updated_at set default now(),
  alter column is_locked set default false,
  alter column is_locked set not null;

do $$
begin
  if exists (
    select 1
    from public.wallets
    where balance < 0
  ) then
    raise exception 'negative_wallet_balances_must_be_resolved_before_wallet_constraint';
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.wallets'::regclass
      and conname = 'wallets_balance_non_negative_check'
  ) then
    alter table public.wallets
      add constraint wallets_balance_non_negative_check
      check (balance >= 0);
  end if;
end $$;

-- ---------------------------------------------------------------------------
-- 5. Upgrade/create the immutable wallet ledger table.
-- ---------------------------------------------------------------------------

create table if not exists public.wallet_transactions (
  id uuid primary key default gen_random_uuid(),
  wallet_user_id uuid not null,
  counterparty_user_id uuid,
  payment_id uuid,
  order_id uuid,
  withdrawal_id uuid,
  related_transaction_id uuid,
  transaction_type text not null,
  direction text not null,
  amount numeric not null,
  balance_before numeric not null,
  balance_after numeric not null,
  status text not null default 'completed',
  transfer_group uuid,
  currency text not null default 'SYP',
  created_by text not null default 'system',
  created_by_user_id uuid,
  idempotency_key text,
  title text,
  description text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

alter table public.wallet_transactions
  add column if not exists id uuid default gen_random_uuid(),
  add column if not exists wallet_user_id uuid,
  add column if not exists counterparty_user_id uuid,
  add column if not exists payment_id uuid,
  add column if not exists order_id uuid,
  add column if not exists withdrawal_id uuid,
  add column if not exists related_transaction_id uuid,
  add column if not exists transaction_type text,
  add column if not exists direction text,
  add column if not exists amount numeric,
  add column if not exists balance_before numeric,
  add column if not exists balance_after numeric,
  add column if not exists status text default 'completed',
  add column if not exists transfer_group uuid,
  add column if not exists currency text not null default 'SYP',
  add column if not exists created_by_user_id uuid,
  add column if not exists idempotency_key text,
  add column if not exists title text,
  add column if not exists description text,
  add column if not exists metadata jsonb not null default '{}'::jsonb,
  add column if not exists created_at timestamptz not null default now();

do $$
begin
  if exists (
    select 1
    from pg_trigger
    where tgrelid = 'public.wallet_transactions'::regclass
      and tgname = 'wallet_transactions_immutable_trigger'
      and not tgisinternal
  ) then
    alter table public.wallet_transactions
      disable trigger wallet_transactions_immutable_trigger;
  end if;
end $$;

do $$
declare
  v_created_by_type text;
begin
  select udt_name
  into v_created_by_type
  from information_schema.columns
  where table_schema = 'public'
    and table_name = 'wallet_transactions'
    and column_name = 'created_by';

  if v_created_by_type = 'uuid' then
    update public.wallet_transactions
    set created_by_user_id = coalesce(created_by_user_id, created_by)
    where created_by is not null;

    alter table public.wallet_transactions
      drop column created_by;

    alter table public.wallet_transactions
      add column created_by text not null default 'system';
  elsif v_created_by_type is null then
    alter table public.wallet_transactions
      add column created_by text not null default 'system';
  end if;
end $$;

do $$
begin
  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'wallet_transactions'
      and column_name = 'transfer_group_id'
  ) then
    update public.wallet_transactions
    set transfer_group = coalesce(transfer_group, transfer_group_id)
    where transfer_group is null
      and transfer_group_id is not null;

    if exists (
      select 1
      from public.wallet_transactions
      where transfer_group_id is not null
        and transfer_group is distinct from transfer_group_id
    ) then
      raise exception 'wallet_transactions_transfer_group_conflict_must_be_resolved';
    end if;
  end if;
end $$;

update public.wallet_transactions
set id = gen_random_uuid()
where id is null;

update public.wallet_transactions
set metadata = '{}'::jsonb
where metadata is null;

update public.wallet_transactions
set currency = 'SYP'
where currency is null
  or btrim(currency) = '';

update public.wallet_transactions
set status = case
  when lower(btrim(coalesce(status, ''))) in ('success', 'succeeded', 'paid')
    then 'completed'
  when lower(btrim(coalesce(status, ''))) = 'canceled'
    then 'cancelled'
  when lower(btrim(coalesce(status, ''))) in (
    'pending',
    'completed',
    'failed',
    'cancelled'
  )
    then lower(btrim(status))
  else 'failed'
end;

update public.wallet_transactions
set direction = case
  when lower(btrim(coalesce(direction, ''))) in (
    'credit',
    'credited',
    'in',
    'inbound'
  )
    then 'credit'
  when lower(btrim(coalesce(direction, ''))) in (
    'debit',
    'debited',
    'out',
    'outbound'
  )
    then 'debit'
  when (direction is null or btrim(direction) = '')
    and amount is not null
    and balance_before is not null
    and balance_after is not null
    and balance_after = balance_before + amount
    then 'credit'
  when (direction is null or btrim(direction) = '')
    and amount is not null
    and balance_before is not null
    and balance_after is not null
    and balance_after = balance_before - amount
    then 'debit'
  else lower(btrim(direction))
end
where direction is null
  or btrim(direction) = ''
  or direction <> lower(btrim(direction))
  or lower(btrim(direction)) in (
    'credited',
    'debited',
    'in',
    'inbound',
    'out',
    'outbound'
  );

update public.wallet_transactions wt
set metadata = wt.metadata || jsonb_build_object(
    'legacy_transaction_type',
    wt.transaction_type
  )
where wt.transaction_type is not null
  and not (wt.metadata ? 'legacy_transaction_type')
  and lower(btrim(wt.transaction_type)) not in (
    'payment',
    'refund',
    'withdrawal',
    'deposit',
    'adjustment',
    'commission',
    'bonus',
    'order_payment',
    'external_payment_settlement',
    'wallet_payment',
    'wallet_refund',
    'payment_refund',
    'refund_payment',
    'withdraw',
    'withdraw_request',
    'withdrawal_request',
    'top_up',
    'topup',
    'wallet_top_up',
    'deposit_top_up',
    'admin_adjustment',
    'manual_adjustment'
  );

update public.wallet_transactions
set transaction_type = case
  when lower(btrim(coalesce(transaction_type, ''))) in (
    'order_payment',
    'external_payment_settlement',
    'wallet_payment'
  )
    then 'payment'
  when lower(btrim(coalesce(transaction_type, ''))) in (
    'wallet_refund',
    'payment_refund',
    'refund_payment',
    'refund'
  )
    then 'refund'
  when lower(btrim(coalesce(transaction_type, ''))) in (
    'withdraw',
    'withdraw_request',
    'withdrawal_request',
    'withdrawal'
  )
    then 'withdrawal'
  when lower(btrim(coalesce(transaction_type, ''))) in (
    'top_up',
    'topup',
    'wallet_top_up',
    'deposit_top_up',
    'deposit'
  )
    then 'deposit'
  when lower(btrim(coalesce(transaction_type, ''))) in (
    'admin_adjustment',
    'manual_adjustment',
    'adjustment'
  )
    then 'adjustment'
  when lower(btrim(coalesce(transaction_type, ''))) in ('commission', 'bonus')
    then lower(btrim(transaction_type))
  else 'adjustment'
end;

update public.wallet_transactions wt
set created_by = case
  when p.role in ('client', 'worker', 'admin') then p.role
  else wt.created_by
end
from public.profiles p
where wt.created_by_user_id = p.id;

update public.wallet_transactions
set created_by = case
  when lower(btrim(coalesce(created_by, ''))) in (
    'system',
    'client',
    'worker',
    'admin'
  )
    then lower(btrim(created_by))
  else 'system'
end;

do $$
begin
  if exists (
    select 1
    from public.wallet_transactions
    where wallet_user_id is null
  ) then
    raise exception 'wallet_transactions_missing_wallet_user_id_must_be_resolved';
  end if;

  if exists (
    select 1
    from public.wallet_transactions
    where direction is null
      or direction not in ('credit', 'debit')
  ) then
    raise exception 'wallet_transactions_invalid_direction_must_be_resolved';
  end if;

  if exists (
    select 1
    from public.wallet_transactions
    where amount is null
      or amount <= 0
  ) then
    raise exception 'wallet_transactions_non_positive_amounts_must_be_resolved';
  end if;

  if exists (
    select 1
    from public.wallet_transactions
    where balance_before is null
      or balance_before < 0
      or balance_after is null
      or balance_after < 0
  ) then
    raise exception 'wallet_transactions_invalid_balances_must_be_resolved';
  end if;

  if exists (
    select 1
    from public.wallet_transactions
    where status = 'completed'
      and (
        (
          direction = 'credit'
          and balance_after <> balance_before + amount
        )
        or (
          direction = 'debit'
          and balance_after <> balance_before - amount
        )
      )
  ) then
    raise exception 'wallet_transactions_completed_balance_math_must_be_resolved';
  end if;

  if exists (
    select 1
    from public.wallet_transactions
    group by id
    having count(*) > 1
  ) then
    raise exception 'duplicate_wallet_transaction_ids_must_be_resolved_before_primary_key';
  end if;

  if exists (
    select 1
    from public.wallet_transactions
    where idempotency_key is not null
    group by idempotency_key
    having count(*) > 1
  ) then
    raise exception 'duplicate_wallet_transaction_idempotency_keys_must_be_resolved_before_unique_index';
  end if;

  if exists (
    select 1
    from public.wallet_transactions wt
    left join public.profiles p on p.id = wt.wallet_user_id
    where p.id is null
  ) then
    raise exception 'wallet_transactions_invalid_wallet_user_id_must_be_resolved_before_foreign_key';
  end if;

  if exists (
    select 1
    from public.wallet_transactions wt
    left join public.profiles p on p.id = wt.counterparty_user_id
    where wt.counterparty_user_id is not null
      and p.id is null
  ) then
    raise exception 'wallet_transactions_invalid_counterparty_user_id_must_be_resolved_before_foreign_key';
  end if;

  if exists (
    select 1
    from public.wallet_transactions wt
    left join public.payments p on p.id = wt.payment_id
    where wt.payment_id is not null
      and p.id is null
  ) then
    raise exception 'wallet_transactions_invalid_payment_id_must_be_resolved_before_foreign_key';
  end if;

  if exists (
    select 1
    from public.wallet_transactions wt
    left join public.orders o on o.id = wt.order_id
    where wt.order_id is not null
      and o.id is null
  ) then
    raise exception 'wallet_transactions_invalid_order_id_must_be_resolved_before_foreign_key';
  end if;

  if exists (
    select 1
    from public.wallet_transactions wt
    left join public.withdrawals w on w.id = wt.withdrawal_id
    where wt.withdrawal_id is not null
      and w.id is null
  ) then
    raise exception 'wallet_transactions_invalid_withdrawal_id_must_be_resolved_before_foreign_key';
  end if;

  if exists (
    select 1
    from public.wallet_transactions wt
    left join public.wallet_transactions related
      on related.id = wt.related_transaction_id
    where wt.related_transaction_id is not null
      and related.id is null
  ) then
    raise exception 'wallet_transactions_invalid_related_transaction_id_must_be_resolved_before_foreign_key';
  end if;

  if exists (
    select 1
    from public.wallet_transactions wt
    left join public.profiles p on p.id = wt.created_by_user_id
    where wt.created_by_user_id is not null
      and p.id is null
  ) then
    raise exception 'wallet_transactions_invalid_created_by_user_id_must_be_resolved_before_foreign_key';
  end if;
end $$;

alter table public.wallet_transactions
  alter column id set default gen_random_uuid(),
  alter column id set not null,
  alter column wallet_user_id set not null,
  alter column transaction_type set not null,
  alter column direction set not null,
  alter column amount set not null,
  alter column balance_before set not null,
  alter column balance_after set not null,
  alter column status set default 'completed',
  alter column status set not null,
  alter column currency set default 'SYP',
  alter column currency set not null,
  alter column created_by set default 'system',
  alter column created_by set not null,
  alter column idempotency_key drop not null,
  alter column metadata set default '{}'::jsonb,
  alter column metadata set not null,
  alter column created_at set default now(),
  alter column created_at set not null;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.wallet_transactions'::regclass
      and contype = 'p'
  ) then
    alter table public.wallet_transactions
      add constraint wallet_transactions_pkey primary key (id);
  end if;
end $$;

alter table public.wallet_transactions
  drop constraint if exists wallet_transactions_idempotency_key_key,
  drop constraint if exists wallet_transactions_transaction_type_check,
  drop constraint if exists wallet_transactions_direction_check,
  drop constraint if exists wallet_transactions_status_check,
  drop constraint if exists wallet_transactions_amount_positive_check,
  drop constraint if exists wallet_transactions_balance_non_negative_check,
  drop constraint if exists wallet_transactions_created_by_check,
  drop constraint if exists wallet_transactions_completed_math_check;

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
    check (created_by in ('system', 'client', 'worker', 'admin')),
  add constraint wallet_transactions_completed_math_check
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
    );

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.wallet_transactions'::regclass
      and conname = 'wallet_transactions_wallet_user_id_fkey'
  ) then
    alter table public.wallet_transactions
      add constraint wallet_transactions_wallet_user_id_fkey
      foreign key (wallet_user_id)
      references public.profiles(id)
      on delete cascade
      not valid;
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.wallet_transactions'::regclass
      and conname = 'wallet_transactions_counterparty_user_id_fkey'
  ) then
    alter table public.wallet_transactions
      add constraint wallet_transactions_counterparty_user_id_fkey
      foreign key (counterparty_user_id)
      references public.profiles(id)
      on delete set null
      not valid;
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.wallet_transactions'::regclass
      and conname = 'wallet_transactions_payment_id_fkey'
  ) then
    alter table public.wallet_transactions
      add constraint wallet_transactions_payment_id_fkey
      foreign key (payment_id)
      references public.payments(id)
      on delete set null
      not valid;
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.wallet_transactions'::regclass
      and conname = 'wallet_transactions_order_id_fkey'
  ) then
    alter table public.wallet_transactions
      add constraint wallet_transactions_order_id_fkey
      foreign key (order_id)
      references public.orders(id)
      on delete set null
      not valid;
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.wallet_transactions'::regclass
      and conname = 'wallet_transactions_withdrawal_id_fkey'
  ) then
    alter table public.wallet_transactions
      add constraint wallet_transactions_withdrawal_id_fkey
      foreign key (withdrawal_id)
      references public.withdrawals(id)
      on delete set null
      not valid;
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.wallet_transactions'::regclass
      and conname = 'wallet_transactions_related_transaction_id_fkey'
  ) then
    alter table public.wallet_transactions
      add constraint wallet_transactions_related_transaction_id_fkey
      foreign key (related_transaction_id)
      references public.wallet_transactions(id)
      on delete set null
      not valid;
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.wallet_transactions'::regclass
      and conname = 'wallet_transactions_created_by_user_id_fkey'
  ) then
    alter table public.wallet_transactions
      add constraint wallet_transactions_created_by_user_id_fkey
      foreign key (created_by_user_id)
      references public.profiles(id)
      on delete set null
      not valid;
  end if;
end $$;

do $$
begin
  if exists (
    select 1
    from pg_trigger
    where tgrelid = 'public.wallet_transactions'::regclass
      and tgname = 'wallet_transactions_immutable_trigger'
      and not tgisinternal
  ) then
    alter table public.wallet_transactions
      enable trigger wallet_transactions_immutable_trigger;
  end if;
end $$;

-- ---------------------------------------------------------------------------
-- 6. Upgrade payments and backfill legacy rows.
-- ---------------------------------------------------------------------------

alter table public.payments
  add column if not exists payer_id uuid,
  add column if not exists payee_id uuid,
  add column if not exists transfer_group uuid,
  add column if not exists parent_payment_id uuid,
  add column if not exists currency text not null default 'SYP',
  add column if not exists created_by text not null default 'system',
  add column if not exists provider text,
  add column if not exists fee numeric not null default 0,
  add column if not exists metadata jsonb not null default '{}'::jsonb,
  add column if not exists idempotency_key text,
  add column if not exists updated_at timestamptz default now(),
  add column if not exists paid_at timestamptz,
  add column if not exists reference_number text,
  add column if not exists transaction_id text,
  add column if not exists payment_method text;

do $$
begin
  if exists (
    select 1
    from pg_trigger
    where tgrelid = 'public.payments'::regclass
      and tgname = 'payments_server_managed_trigger'
      and not tgisinternal
  ) then
    alter table public.payments
      disable trigger payments_server_managed_trigger;
  end if;

  if exists (
    select 1
    from public.wallet_transactions
    where payment_id is not null
      and transfer_group is not null
    group by payment_id
    having count(distinct transfer_group) > 1
  ) then
    raise exception 'multiple_transfer_groups_found_for_single_payment';
  end if;

  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'payments'
      and column_name = 'user_id'
  ) then
    execute $sql$
      with payment_ledger_groups as (
        select
          payment_id,
          min(transfer_group::text)::uuid as transfer_group
        from public.wallet_transactions
        where payment_id is not null
          and transfer_group is not null
        group by payment_id
      ),
      payment_parties as (
        select
          p.id as payment_id,
          o.client_id,
          w.user_id as worker_user_id,
          plg.transfer_group
        from public.payments p
        left join public.orders o on o.id = p.order_id
        left join public.workers w on w.id = o.worker_id
        left join payment_ledger_groups plg on plg.payment_id = p.id
      )
      update public.payments p
      set
        payer_id = coalesce(p.payer_id, p.user_id, pp.client_id),
        payee_id = coalesce(p.payee_id, pp.worker_user_id),
        transfer_group = coalesce(p.transfer_group, pp.transfer_group),
        currency = coalesce(nullif(btrim(p.currency), ''), 'SYP'),
        created_by = case
          when pp.client_id is not null
            and coalesce(p.payer_id, p.user_id, pp.client_id) = pp.client_id
            then 'client'
          else 'system'
        end
      from payment_parties pp
      where pp.payment_id = p.id
    $sql$;
  else
    execute $sql$
      with payment_ledger_groups as (
        select
          payment_id,
          min(transfer_group::text)::uuid as transfer_group
        from public.wallet_transactions
        where payment_id is not null
          and transfer_group is not null
        group by payment_id
      ),
      payment_parties as (
        select
          p.id as payment_id,
          o.client_id,
          w.user_id as worker_user_id,
          plg.transfer_group
        from public.payments p
        left join public.orders o on o.id = p.order_id
        left join public.workers w on w.id = o.worker_id
        left join payment_ledger_groups plg on plg.payment_id = p.id
      )
      update public.payments p
      set
        payer_id = coalesce(p.payer_id, pp.client_id),
        payee_id = coalesce(p.payee_id, pp.worker_user_id),
        transfer_group = coalesce(p.transfer_group, pp.transfer_group),
        currency = coalesce(nullif(btrim(p.currency), ''), 'SYP'),
        created_by = case
          when pp.client_id is not null
            and coalesce(p.payer_id, pp.client_id) = pp.client_id
            then 'client'
          else 'system'
        end
      from payment_parties pp
      where pp.payment_id = p.id
    $sql$;
  end if;
end $$;

update public.payments
set transfer_group = gen_random_uuid()
where transfer_group is null;

update public.payments
set currency = 'SYP'
where currency is null
  or btrim(currency) = '';

update public.payments
set metadata = '{}'::jsonb
where metadata is null;

update public.payments
set fee = 0
where fee is null;

update public.payments
set provider = case
  when lower(btrim(coalesce(provider, ''))) in ('refund', 'refunded')
    or lower(btrim(coalesce(status, ''))) = 'refunded'
    then 'refund'
  when lower(btrim(coalesce(provider, ''))) = 'admin'
    then 'admin'
  when lower(btrim(coalesce(provider, ''))) = 'cash'
    or lower(btrim(coalesce(payment_method, ''))) = 'cash'
    then 'cash'
  when lower(btrim(coalesce(provider, ''))) in (
    'wallet',
    'hirfati',
    'hirfati_wallet',
    'sham_cash',
    'sham_cash_mock',
    'shamcash'
  )
    or lower(btrim(coalesce(payment_method, ''))) = 'wallet'
    then 'wallet'
  else 'manual'
end;

update public.payments
set created_by = case
  when lower(btrim(coalesce(created_by, ''))) in (
    'system',
    'client',
    'worker',
    'admin'
  )
    then lower(btrim(created_by))
  else 'system'
end;

update public.payments p
set
  amount = o.price,
  metadata = (
    case
      when p.metadata ? 'legacy_amount_before_wallet_ledger'
        then p.metadata
      else p.metadata || jsonb_build_object(
        'legacy_amount_before_wallet_ledger',
        p.amount
      )
    end
  ) || jsonb_build_object(
    'amount_backfilled_from_order',
    true,
    'amount_backfill_migration',
    '20260724090000_wallet_ledger_consolidated'
  )
from public.orders o
where p.order_id = o.id
  and (
    p.amount is null
    or p.amount <= 0
  )
  and lower(btrim(coalesce(p.status, ''))) in (
    'pending',
    'processing',
    'failed'
  )
  and o.price > 0
  and jsonb_typeof(p.metadata) = 'object'
  and lower(btrim(coalesce(o.status, ''))) <> 'cancelled'
  and lower(btrim(coalesce(o.payment_status, ''))) <> 'refunded'
  and nullif(btrim(coalesce(p.transaction_id, '')), '') is null
  and nullif(btrim(coalesce(p.reference_number, '')), '') is null
  and lower(btrim(coalesce(p.provider, ''))) <> 'refund'
  and not exists (
    select 1
    from public.wallet_transactions wt
    where wt.payment_id = p.id
  )
  and not exists (
    select 1
    from public.payment_events pe
    where pe.payment_id = p.id
      and (
        lower(btrim(coalesce(pe.event_type, ''))) in (
          'settlement_completed',
          'settlement_succeeded',
          'capture_completed',
          'capture_succeeded',
          'payment_completed',
          'payment_succeeded',
          'payment_success',
          'payment_captured',
          'refund_completed',
          'refund_succeeded',
          'refunded',
          'paid'
        )
        or lower(btrim(coalesce(pe.event_type, '')))
          ~ '(settlement|capture|refund)'
        or (
          lower(btrim(coalesce(pe.event_type, ''))) ~ 'payment'
          and lower(btrim(coalesce(pe.event_type, '')))
            ~ '(completed|succeeded|success|captured|settled|paid|refunded)'
          and lower(btrim(coalesce(pe.event_type, '')))
            !~ '(failed|cancelled|canceled|pending|requested)'
        )
      )
  );

do $$
declare
  v_remaining_count bigint;
  v_completed_or_refunded_count bigint;
  v_with_ledger_count bigint;
  v_with_successful_event_count bigint;
  v_without_order_count bigint;
  v_missing_order_count bigint;
  v_invalid_order_price_count bigint;
  v_order_conflict_count bigint;
  v_financial_reference_count bigint;
  v_unsupported_status_count bigint;
  v_metadata_not_object_count bigint;
begin
  select count(*)
  into v_remaining_count
  from public.payments
  where amount is null
    or amount <= 0;

  if v_remaining_count > 0 then
    select count(*)
    into v_completed_or_refunded_count
    from public.payments
    where (amount is null or amount <= 0)
      and lower(btrim(coalesce(status, ''))) in ('completed', 'refunded');

    select count(*)
    into v_with_ledger_count
    from public.payments p
    where (p.amount is null or p.amount <= 0)
      and exists (
        select 1
        from public.wallet_transactions wt
        where wt.payment_id = p.id
      );

    select count(*)
    into v_with_successful_event_count
    from public.payments p
    where (p.amount is null or p.amount <= 0)
      and exists (
        select 1
        from public.payment_events pe
        where pe.payment_id = p.id
          and (
            lower(btrim(coalesce(pe.event_type, ''))) in (
              'settlement_completed',
              'settlement_succeeded',
              'capture_completed',
              'capture_succeeded',
              'payment_completed',
              'payment_succeeded',
              'payment_success',
              'payment_captured',
              'refund_completed',
              'refund_succeeded',
              'refunded',
              'paid'
            )
            or lower(btrim(coalesce(pe.event_type, '')))
              ~ '(settlement|capture|refund)'
            or (
              lower(btrim(coalesce(pe.event_type, ''))) ~ 'payment'
              and lower(btrim(coalesce(pe.event_type, '')))
                ~ '(completed|succeeded|success|captured|settled|paid|refunded)'
              and lower(btrim(coalesce(pe.event_type, '')))
                !~ '(failed|cancelled|canceled|pending|requested)'
            )
          )
      );

    select count(*)
    into v_without_order_count
    from public.payments
    where (amount is null or amount <= 0)
      and order_id is null;

    select count(*)
    into v_missing_order_count
    from public.payments p
    left join public.orders o on o.id = p.order_id
    where (p.amount is null or p.amount <= 0)
      and p.order_id is not null
      and o.id is null;

    select count(*)
    into v_invalid_order_price_count
    from public.payments p
    join public.orders o on o.id = p.order_id
    where (p.amount is null or p.amount <= 0)
      and (
        o.price is null
        or o.price <= 0
      );

    select count(*)
    into v_order_conflict_count
    from public.payments p
    join public.orders o on o.id = p.order_id
    where (p.amount is null or p.amount <= 0)
      and (
        lower(btrim(coalesce(o.status, ''))) = 'cancelled'
        or lower(btrim(coalesce(o.payment_status, ''))) = 'refunded'
        or (
          lower(btrim(coalesce(o.payment_status, ''))) = 'failed'
          and lower(btrim(coalesce(p.status, ''))) <> 'failed'
        )
      );

    select count(*)
    into v_financial_reference_count
    from public.payments
    where (amount is null or amount <= 0)
      and (
        nullif(btrim(coalesce(transaction_id, '')), '') is not null
        or nullif(btrim(coalesce(reference_number, '')), '') is not null
        or lower(btrim(coalesce(provider, ''))) = 'refund'
      );

    select count(*)
    into v_unsupported_status_count
    from public.payments
    where (amount is null or amount <= 0)
      and lower(btrim(coalesce(status, ''))) not in (
        'pending',
        'processing',
        'failed'
      );

    select count(*)
    into v_metadata_not_object_count
    from public.payments
    where (amount is null or amount <= 0)
      and jsonb_typeof(metadata) <> 'object';

    raise exception 'payments_non_positive_amounts_must_be_resolved_before_amount_check'
      using detail = format(
        'remaining_affected_payment_count=%s; completed_or_refunded=%s; with_ledger_entries=%s; with_settlement_capture_refund_or_successful_payment_events=%s; without_order=%s; missing_order=%s; invalid_order_price=%s; order_conflicts=%s; financial_reference_present=%s; unsupported_status=%s; metadata_not_object=%s',
        v_remaining_count,
        v_completed_or_refunded_count,
        v_with_ledger_count,
        v_with_successful_event_count,
        v_without_order_count,
        v_missing_order_count,
        v_invalid_order_price_count,
        v_order_conflict_count,
        v_financial_reference_count,
        v_unsupported_status_count,
        v_metadata_not_object_count
      );
  end if;

  if exists (
    select 1
    from public.payments
    where status = 'completed'
      and order_id is not null
      and parent_payment_id is null
      and provider <> 'refund'
    group by order_id
    having count(*) > 1
  ) then
    raise exception 'duplicate_completed_payments_must_be_resolved_before_unique_index';
  end if;

  if exists (
    select 1
    from public.payments
    where idempotency_key is not null
    group by idempotency_key
    having count(*) > 1
  ) then
    raise exception 'duplicate_payment_idempotency_keys_must_be_resolved_before_unique_index';
  end if;

  if exists (
    select 1
    from public.payments p
    left join public.profiles payer on payer.id = p.payer_id
    where p.payer_id is not null
      and payer.id is null
  ) then
    raise exception 'payments_invalid_payer_id_must_be_resolved_before_foreign_key';
  end if;

  if exists (
    select 1
    from public.payments p
    left join public.profiles payee on payee.id = p.payee_id
    where p.payee_id is not null
      and payee.id is null
  ) then
    raise exception 'payments_invalid_payee_id_must_be_resolved_before_foreign_key';
  end if;

  if exists (
    select 1
    from public.payments p
    left join public.payments parent on parent.id = p.parent_payment_id
    where p.parent_payment_id is not null
      and parent.id is null
  ) then
    raise exception 'payments_invalid_parent_payment_id_must_be_resolved_before_foreign_key';
  end if;
end $$;

alter table public.payments
  alter column amount set not null,
  alter column provider set default 'wallet',
  alter column provider set not null,
  alter column fee set default 0,
  alter column fee set not null,
  alter column metadata set default '{}'::jsonb,
  alter column metadata set not null,
  alter column transfer_group set not null,
  alter column currency set default 'SYP',
  alter column currency set not null,
  alter column created_by set default 'system',
  alter column created_by set not null;

alter table public.payments
  drop constraint if exists payments_provider_check,
  drop constraint if exists payments_created_by_check,
  drop constraint if exists payments_amount_positive_check,
  drop constraint if exists payments_currency_non_empty_check;

alter table public.payments
  add constraint payments_provider_check
    check (provider in ('wallet', 'cash', 'manual', 'refund', 'admin')),
  add constraint payments_created_by_check
    check (created_by in ('system', 'client', 'worker', 'admin')),
  add constraint payments_amount_positive_check
    check (amount > 0),
  add constraint payments_currency_non_empty_check
    check (btrim(currency) <> '');

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.payments'::regclass
      and conname = 'payments_payer_id_fkey'
  ) then
    alter table public.payments
      add constraint payments_payer_id_fkey
      foreign key (payer_id)
      references public.profiles(id)
      on delete set null
      not valid;
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.payments'::regclass
      and conname = 'payments_payee_id_fkey'
  ) then
    alter table public.payments
      add constraint payments_payee_id_fkey
      foreign key (payee_id)
      references public.profiles(id)
      on delete set null
      not valid;
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.payments'::regclass
      and conname = 'payments_parent_payment_id_fkey'
  ) then
    alter table public.payments
      add constraint payments_parent_payment_id_fkey
      foreign key (parent_payment_id)
      references public.payments(id)
      on delete set null
      not valid;
  end if;
end $$;

do $$
begin
  if exists (
    select 1
    from pg_trigger
    where tgrelid = 'public.payments'::regclass
      and tgname = 'payments_server_managed_trigger'
      and not tgisinternal
  ) then
    alter table public.payments
      enable trigger payments_server_managed_trigger;
  end if;
end $$;

-- ---------------------------------------------------------------------------
-- 7. Replace settlement and protection functions before dropping old columns.
-- ---------------------------------------------------------------------------

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
grant execute on function public.ensure_wallet_for_current_user()
  to authenticated;

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
  v_method text := lower(btrim(coalesce(p_payment_method, '')));
  v_idempotency_key text := btrim(coalesce(p_idempotency_key, ''));
  v_now timestamptz := now();
  v_order record;
  v_worker_user_id uuid;
  v_amount numeric;
  v_existing_payment record;
  v_has_existing_payment boolean := false;
  v_payment_id uuid;
  v_reference_number text;
  v_transaction_id text;
  v_transfer_group uuid := gen_random_uuid();
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
  v_has_existing_payment := found;

  if v_has_existing_payment then
    if v_existing_payment.order_id is distinct from p_order_id
      or v_existing_payment.payer_id is distinct from v_user_id
      or v_existing_payment.payment_method is distinct from v_method then
      raise exception 'idempotency_conflict' using errcode = '23505';
    end if;

    if v_existing_payment.status = 'completed' then
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

  perform set_config('hirfati.wallet_ledger_trusted', 'true', true);
  perform set_config(
    'hirfati.wallet_ledger_context',
    'settle_order_payment',
    true
  );

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

  if v_has_existing_payment then
    v_payment_id := v_existing_payment.id;
    v_transfer_group := coalesce(
      v_existing_payment.transfer_group,
      v_transfer_group
    );
  else
    v_payment_id := gen_random_uuid();
  end if;
  v_reference_number :=
    'HF-' || upper(substr(replace(v_payment_id::text, '-', ''), 1, 12));
  v_transaction_id :=
    'wallet_' || replace(gen_random_uuid()::text, '-', '');

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
    'wallet',
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
    'wallet',
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
      updated_at = v_now,
      last_transaction_at = v_now
  where user_id = v_user_id;

  insert into public.wallet_transactions (
    wallet_user_id,
    counterparty_user_id,
    payment_id,
    order_id,
    related_transaction_id,
    transaction_type,
    direction,
    amount,
    balance_before,
    balance_after,
    status,
    transfer_group,
    currency,
    created_by,
    created_by_user_id,
    idempotency_key,
    title,
    description,
    metadata,
    created_at
  )
  values (
    v_user_id,
    v_worker_user_id,
    v_payment_id,
    p_order_id,
    null,
    'payment',
    'debit',
    v_amount,
    v_client_balance_before,
    v_client_balance_after,
    'completed',
    v_transfer_group,
    'SYP',
    'client',
    v_user_id,
    v_idempotency_key || ':client_debit',
    'Order payment',
    null,
    jsonb_build_object(
      'payment_method',
      'wallet',
      'provider',
      'wallet',
      'counterparty_user_id',
      v_worker_user_id
    ),
    v_now
  )
  returning id into v_client_transaction_id;

  update public.wallets
  set balance = v_worker_balance_after,
      updated_at = v_now,
      last_transaction_at = v_now
  where user_id = v_worker_user_id;

  insert into public.wallet_transactions (
    wallet_user_id,
    counterparty_user_id,
    payment_id,
    order_id,
    related_transaction_id,
    transaction_type,
    direction,
    amount,
    balance_before,
    balance_after,
    status,
    transfer_group,
    currency,
    created_by,
    created_by_user_id,
    idempotency_key,
    title,
    description,
    metadata,
    created_at
  )
  values (
    v_worker_user_id,
    v_user_id,
    v_payment_id,
    p_order_id,
    v_client_transaction_id,
    'payment',
    'credit',
    v_amount,
    v_worker_balance_before,
    v_worker_balance_after,
    'completed',
    v_transfer_group,
    'SYP',
    'client',
    v_user_id,
    v_idempotency_key || ':worker_credit',
    'Order settlement',
    null,
    jsonb_build_object(
      'payment_method',
      'wallet',
      'provider',
      'wallet',
      'counterparty_user_id',
      v_user_id
    ),
    v_now
  );

  update public.orders
  set payment_status = 'paid',
      payment_method = 'wallet',
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
      'wallet',
      'provider',
      'wallet',
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

  perform set_config('hirfati.wallet_ledger_trusted', 'false', true);
  perform set_config('hirfati.wallet_ledger_context', '', true);

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

create or replace function public.prevent_wallet_transaction_changes()
returns trigger
language plpgsql
set search_path = public, pg_temp
as $$
begin
  raise exception 'wallet_transactions_are_immutable'
    using errcode = '42501';
end;
$$;

revoke all on function public.prevent_wallet_transaction_changes()
  from public;

create or replace function public.prevent_direct_wallet_balance_changes()
returns trigger
language plpgsql
set search_path = public, pg_temp
as $$
begin
  if public.is_wallet_ledger_trusted_context() then
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

  return new;
end;
$$;

revoke all on function public.prevent_direct_wallet_balance_changes()
  from public;

create or replace function public.prevent_direct_payment_changes()
returns trigger
language plpgsql
set search_path = public, pg_temp
as $$
begin
  if public.is_wallet_ledger_trusted_context() then
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

create or replace function public.prevent_direct_order_payment_field_changes()
returns trigger
language plpgsql
set search_path = public, pg_temp
as $$
begin
  if public.is_wallet_ledger_trusted_context() then
    return new;
  end if;

  if coalesce(new.payment_status, 'pending') = 'paid'
    and coalesce(old.payment_status, 'pending') <> 'paid' then
    raise exception 'order_payment_settlement_is_server_managed'
      using errcode = '42501';
  end if;

  if old.paid_at is distinct from new.paid_at
    and new.paid_at is not null then
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

  if coalesce(old.payment_status, 'pending') = 'paid'
    and (
      old.payment_status is distinct from new.payment_status
      or old.paid_at is distinct from new.paid_at
      or old.payment_transaction_id is distinct from new.payment_transaction_id
      or old.payment_reference is distinct from new.payment_reference
    ) then
    raise exception 'paid_order_payment_fields_are_immutable'
      using errcode = '42501';
  end if;

  return new;
end;
$$;

revoke all on function public.prevent_direct_order_payment_field_changes()
  from public;

-- ---------------------------------------------------------------------------
-- 8. Replace indexes, policies, and old compatibility columns.
-- ---------------------------------------------------------------------------

drop policy if exists wallets_select_own_or_admin on public.wallets;
drop policy if exists wallet_transactions_select_own_or_admin
  on public.wallet_transactions;
drop policy if exists payments_select_participant_or_admin
  on public.payments;
drop policy if exists payment_events_select_participant_or_admin
  on public.payment_events;

do $$
declare
  r record;
begin
  for r in
    select
      c.oid::regclass as table_name,
      p.polname
    from pg_policy p
    join pg_class c on c.oid = p.polrelid
    join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname in ('payments', 'payment_events')
      and (
        coalesce(pg_get_expr(p.polqual, p.polrelid), '') ilike '%user_id%'
        or coalesce(pg_get_expr(p.polwithcheck, p.polrelid), '') ilike '%user_id%'
      )
  loop
    execute format('drop policy if exists %I on %s', r.polname, r.table_name);
  end loop;
end $$;

alter table public.wallets enable row level security;
alter table public.wallet_transactions enable row level security;
alter table public.payments enable row level security;
alter table public.payment_events enable row level security;

create policy wallets_select_own_or_admin
on public.wallets
for select
to authenticated
using (user_id = auth.uid() or public.is_admin());

create policy wallet_transactions_select_own_or_admin
on public.wallet_transactions
for select
to authenticated
using (wallet_user_id = auth.uid() or public.is_admin());

create policy payments_select_participant_or_admin
on public.payments
for select
to authenticated
using (
  payer_id = auth.uid()
  or payee_id = auth.uid()
  or public.is_admin()
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
    where p.id = payment_events.payment_id
      and (
        p.payer_id = auth.uid()
        or p.payee_id = auth.uid()
      )
  )
);

do $$
declare
  r record;
begin
  for r in
    select i.indexrelid::regclass as index_name
    from pg_index i
    join pg_attribute a
      on a.attrelid = i.indrelid
      and a.attnum = any(i.indkey)
    where i.indrelid = 'public.payments'::regclass
      and a.attname = 'user_id'
  loop
    execute format('drop index if exists %s', r.index_name);
  end loop;

  for r in
    select i.indexrelid::regclass as index_name
    from pg_index i
    join pg_attribute a
      on a.attrelid = i.indrelid
      and a.attnum = any(i.indkey)
    where i.indrelid = 'public.wallet_transactions'::regclass
      and a.attname = 'transfer_group_id'
  loop
    execute format('drop index if exists %s', r.index_name);
  end loop;
end $$;

drop index if exists public.payments_user_created_idx;
drop index if exists public.payments_user_id_idx;
drop index if exists public.wallet_transactions_transfer_group_id_idx;

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
create unique index if not exists payments_idempotency_key_idx
  on public.payments (idempotency_key)
  where idempotency_key is not null;
create unique index if not exists payments_one_completed_per_order_idx
  on public.payments (order_id)
  where order_id is not null
    and status = 'completed'
    and parent_payment_id is null
    and provider <> 'refund';

create index if not exists wallet_transactions_wallet_user_created_at_idx
  on public.wallet_transactions (wallet_user_id, created_at desc);
create index if not exists wallet_transactions_payment_id_idx
  on public.wallet_transactions (payment_id);
create index if not exists wallet_transactions_order_id_idx
  on public.wallet_transactions (order_id);
create index if not exists wallet_transactions_withdrawal_id_idx
  on public.wallet_transactions (withdrawal_id);
create index if not exists wallet_transactions_transfer_group_idx
  on public.wallet_transactions (transfer_group);
create index if not exists wallet_transactions_transaction_type_idx
  on public.wallet_transactions (transaction_type);
create index if not exists wallet_transactions_status_idx
  on public.wallet_transactions (status);
create index if not exists wallet_transactions_currency_created_idx
  on public.wallet_transactions (currency, created_at desc);
create unique index if not exists wallet_transactions_idempotency_key_idx
  on public.wallet_transactions (idempotency_key)
  where idempotency_key is not null;

alter table public.payments
  drop column if exists user_id;

alter table public.wallet_transactions
  drop column if exists transfer_group_id;

drop trigger if exists wallet_transactions_immutable_trigger
  on public.wallet_transactions;
create trigger wallet_transactions_immutable_trigger
before update or delete on public.wallet_transactions
for each row execute function public.prevent_wallet_transaction_changes();

drop trigger if exists wallets_server_managed_balance_trigger
  on public.wallets;
create trigger wallets_server_managed_balance_trigger
before insert or update or delete on public.wallets
for each row execute function public.prevent_direct_wallet_balance_changes();

drop trigger if exists payments_server_managed_trigger
  on public.payments;
create trigger payments_server_managed_trigger
before insert or update or delete on public.payments
for each row execute function public.prevent_direct_payment_changes();

drop trigger if exists orders_server_managed_payment_fields_trigger
  on public.orders;
create trigger orders_server_managed_payment_fields_trigger
before update of payment_status,
  paid_at,
  payment_transaction_id,
  payment_reference on public.orders
for each row execute function public.prevent_direct_order_payment_field_changes();

revoke insert, update, delete on table public.wallets
  from anon, authenticated;
revoke insert, update, delete on table public.wallet_transactions
  from anon, authenticated;
revoke insert, update, delete on table public.payments
  from anon, authenticated;
revoke insert, update, delete on table public.payment_events
  from anon, authenticated;

grant select on table public.wallets to authenticated;
grant select on table public.wallet_transactions to authenticated;
grant select on table public.payments to authenticated;
grant select on table public.payment_events to authenticated;

-- ---------------------------------------------------------------------------
-- 9. Admin audit log.
-- ---------------------------------------------------------------------------

create table if not exists public.admin_audit_logs (
  id uuid primary key default gen_random_uuid(),
  admin_id uuid,
  action text,
  entity_type text,
  entity_id uuid,
  reason text,
  old_values jsonb not null default '{}'::jsonb,
  new_values jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

alter table public.admin_audit_logs
  add column if not exists id uuid default gen_random_uuid(),
  add column if not exists admin_id uuid,
  add column if not exists action text,
  add column if not exists entity_type text,
  add column if not exists entity_id uuid,
  add column if not exists reason text,
  add column if not exists old_values jsonb not null default '{}'::jsonb,
  add column if not exists new_values jsonb not null default '{}'::jsonb,
  add column if not exists created_at timestamptz not null default now();

update public.admin_audit_logs
set id = gen_random_uuid()
where id is null;

update public.admin_audit_logs
set old_values = '{}'::jsonb
where old_values is null;

update public.admin_audit_logs
set new_values = '{}'::jsonb
where new_values is null;

alter table public.admin_audit_logs
  alter column id set default gen_random_uuid(),
  alter column id set not null,
  alter column old_values set default '{}'::jsonb,
  alter column old_values set not null,
  alter column new_values set default '{}'::jsonb,
  alter column new_values set not null,
  alter column created_at set default now(),
  alter column created_at set not null;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.admin_audit_logs'::regclass
      and contype = 'p'
  ) then
    if exists (
      select 1
      from public.admin_audit_logs
      group by id
      having count(*) > 1
    ) then
      raise exception 'duplicate_admin_audit_log_ids_must_be_resolved_before_primary_key';
    end if;

    alter table public.admin_audit_logs
      add constraint admin_audit_logs_pkey primary key (id);
  end if;

  if exists (
    select 1
    from public.admin_audit_logs aal
    left join public.profiles p on p.id = aal.admin_id
    where aal.admin_id is not null
      and p.id is null
  ) then
    raise exception 'admin_audit_logs_invalid_admin_id_must_be_resolved_before_foreign_key';
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public.admin_audit_logs'::regclass
      and conname = 'admin_audit_logs_admin_id_fkey'
  ) then
    alter table public.admin_audit_logs
      add constraint admin_audit_logs_admin_id_fkey
      foreign key (admin_id)
      references public.profiles(id)
      on delete restrict
      not valid;
  end if;
end $$;

alter table public.admin_audit_logs enable row level security;

drop policy if exists admin_audit_logs_select_admin
  on public.admin_audit_logs;
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
    using errcode = '42501';
end;
$$;

revoke all on function public.prevent_admin_audit_log_changes()
  from public;

drop trigger if exists admin_audit_logs_immutable_trigger
  on public.admin_audit_logs;
create trigger admin_audit_logs_immutable_trigger
before update or delete on public.admin_audit_logs
for each row execute function public.prevent_admin_audit_log_changes();

revoke insert, update, delete on table public.admin_audit_logs
  from anon, authenticated;
grant select on table public.admin_audit_logs to authenticated;

-- ---------------------------------------------------------------------------
-- 10. Final schema assertions.
-- ---------------------------------------------------------------------------

do $$
declare
  v_provider_default text;
  v_missing_check text;
  v_missing_trigger text;
begin
  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'payments'
      and column_name = 'user_id'
  ) then
    raise exception 'final_schema_payments_user_id_still_exists';
  end if;

  if not exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'payments'
      and column_name = 'payer_id'
  ) then
    raise exception 'final_schema_payments_payer_id_missing';
  end if;

  if not exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'payments'
      and column_name = 'payee_id'
  ) then
    raise exception 'final_schema_payments_payee_id_missing';
  end if;

  if not exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'payments'
      and column_name = 'transfer_group'
  ) then
    raise exception 'final_schema_payments_transfer_group_missing';
  end if;

  if not exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'payments'
      and column_name = 'parent_payment_id'
  ) then
    raise exception 'final_schema_payments_parent_payment_id_missing';
  end if;

  select column_default
  into v_provider_default
  from information_schema.columns
  where table_schema = 'public'
    and table_name = 'payments'
    and column_name = 'provider';

  if coalesce(v_provider_default, '') not in (
    '''wallet''::text',
    '''wallet'''
  ) then
    raise exception 'final_schema_payments_provider_default_not_wallet';
  end if;

  if not exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'wallet_transactions'
      and column_name = 'transfer_group'
  ) then
    raise exception 'final_schema_wallet_transactions_transfer_group_missing';
  end if;

  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'wallet_transactions'
      and column_name = 'transfer_group_id'
  ) then
    raise exception 'final_schema_wallet_transactions_transfer_group_id_still_exists';
  end if;

  select required.conname
  into v_missing_check
  from unnest(array[
    'wallets_balance_non_negative_check',
    'wallet_transactions_transaction_type_check',
    'wallet_transactions_direction_check',
    'wallet_transactions_status_check',
    'wallet_transactions_amount_positive_check',
    'wallet_transactions_balance_non_negative_check',
    'wallet_transactions_created_by_check',
    'wallet_transactions_completed_math_check',
    'payments_provider_check',
    'payments_created_by_check',
    'payments_amount_positive_check',
    'payments_currency_non_empty_check'
  ]) as required(conname)
  where not exists (
    select 1
    from pg_constraint c
    join pg_class rel on rel.oid = c.conrelid
    join pg_namespace n on n.oid = rel.relnamespace
    where n.nspname = 'public'
      and c.contype = 'c'
      and c.conname::text = required.conname
  )
  limit 1;

  if v_missing_check is not null then
    raise exception 'final_schema_required_check_constraint_missing: %',
      v_missing_check;
  end if;

  select required.trigger_name
  into v_missing_trigger
  from (
    values
      ('wallet_transactions', 'wallet_transactions_immutable_trigger'),
      ('wallets', 'wallets_server_managed_balance_trigger'),
      ('payments', 'payments_server_managed_trigger'),
      ('orders', 'orders_server_managed_payment_fields_trigger'),
      ('admin_audit_logs', 'admin_audit_logs_immutable_trigger')
  ) as required(table_name, trigger_name)
  where not exists (
    select 1
    from pg_trigger t
    join pg_class rel on rel.oid = t.tgrelid
    join pg_namespace n on n.oid = rel.relnamespace
    where n.nspname = 'public'
      and rel.relname::text = required.table_name
      and t.tgname::text = required.trigger_name
      and not t.tgisinternal
      and t.tgenabled <> 'D'
  )
  limit 1;

  if v_missing_trigger is not null then
    raise exception 'final_schema_required_trigger_missing_or_disabled: %',
      v_missing_trigger;
  end if;

  if to_regprocedure(
    'public.settle_order_payment(uuid,text,text,text,text)'
  ) is null then
    raise exception 'final_schema_settle_order_payment_signature_missing';
  end if;
end $$;
