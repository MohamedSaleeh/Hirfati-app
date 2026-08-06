-- Hirfati wallet-payment Phase 1 preflight diagnostics.
-- Run against local or staging before adding/enforcing financial constraints.
-- This script is read-only except for a temporary helper function in pg_temp.
--
-- Example:
--   psql "$SUPABASE_DB_URL" -f supabase/diagnostics/wallet_payment_preflight_diagnostics.sql

create or replace function pg_temp.hirfati_wallet_ledger_issue_count()
returns bigint
language plpgsql
as $$
declare
  v_count bigint;
begin
  if to_regclass('public.wallet_transactions') is null then
    return 0;
  end if;

  execute $sql$
    select count(*)
    from public.wallet_transactions wt
    where wt.direction not in ('credit', 'debit')
      or wt.amount <= 0
      or wt.balance_before < 0
      or wt.balance_after < 0
      or (
        wt.status = 'completed'
        and wt.direction = 'credit'
        and wt.balance_after <> wt.balance_before + wt.amount
      )
      or (
        wt.status = 'completed'
        and wt.direction = 'debit'
        and wt.balance_after <> wt.balance_before - wt.amount
      )
  $sql$
  into v_count;

  return coalesce(v_count, 0);
end;
$$;

create or replace function pg_temp.hirfati_wallet_ledger_issues()
returns table (
  id uuid,
  wallet_user_id uuid,
  direction text,
  transaction_type text,
  amount numeric,
  balance_before numeric,
  balance_after numeric,
  status text
)
language plpgsql
as $$
begin
  if to_regclass('public.wallet_transactions') is null then
    return;
  end if;

  return query execute $sql$
    select
      wt.id,
      wt.wallet_user_id,
      wt.direction,
      wt.transaction_type,
      wt.amount,
      wt.balance_before,
      wt.balance_after,
      wt.status
    from public.wallet_transactions wt
    where wt.direction not in ('credit', 'debit')
      or wt.amount <= 0
      or wt.balance_before < 0
      or wt.balance_after < 0
      or (
        wt.status = 'completed'
        and wt.direction = 'credit'
        and wt.balance_after <> wt.balance_before + wt.amount
      )
      or (
        wt.status = 'completed'
        and wt.direction = 'debit'
        and wt.balance_after <> wt.balance_before - wt.amount
      )
  $sql$;
end;
$$;

with diagnostics as (
  select
    'multiple_completed_payments_for_one_order' as check_name,
    count(*)::bigint as affected_rows,
    'Manual cleanup required: keep the real settlement, reverse or fail duplicates with an audited migration.' as remediation
  from (
    select order_id
    from public.payments
    where status = 'completed'
      and order_id is not null
    group by order_id
    having count(*) > 1
  ) problems

  union all
  select
    'duplicate_payment_idempotency_keys',
    count(*)::bigint,
    'Manual cleanup required: each key must represent exactly one operation. Do not auto-delete.'
  from (
    select idempotency_key
    from public.payments
    where nullif(btrim(idempotency_key), '') is not null
    group by idempotency_key
    having count(*) > 1
  ) problems

  union all
  select
    'duplicate_payment_reference_numbers',
    count(*)::bigint,
    'Manual cleanup required unless rows are exact abandoned duplicates; document the chosen canonical reference.'
  from (
    select reference_number
    from public.payments
    where nullif(btrim(reference_number), '') is not null
    group by reference_number
    having count(*) > 1
  ) problems

  union all
  select
    'duplicate_wallets_for_one_user',
    count(*)::bigint,
    'Manual cleanup required: merge balances only from audited ledger evidence.'
  from (
    select user_id
    from public.wallets
    where user_id is not null
    group by user_id
    having count(*) > 1
  ) problems

  union all
  select
    'duplicate_workers_for_one_user',
    count(*)::bigint,
    'Manual cleanup required: pick the active worker profile and migrate dependent rows first.'
  from (
    select user_id
    from public.workers
    where user_id is not null
    group by user_id
    having count(*) > 1
  ) problems

  union all
  select
    'canonical_duplicate_conversations',
    count(*)::bigint,
    'Manual cleanup required: merge messages into one canonical conversation, then remove duplicates with audit.'
  from (
    select least(user1_id, user2_id), greatest(user1_id, user2_id)
    from public.conversations
    group by least(user1_id, user2_id), greatest(user1_id, user2_id)
    having count(*) > 1
  ) problems

  union all
  select
    'duplicate_pending_verification_requests',
    count(*)::bigint,
    'Manual cleanup required: keep the newest active request or resolve older ones with an explicit reason.'
  from (
    select user_id
    from public.verification_requests
    where status = 'pending'
    group by user_id
    having count(*) > 1
  ) problems

  union all
  select
    'invalid_payment_status_values',
    count(*)::bigint,
    'Manual cleanup required: map old values to pending, processing, completed, failed, or refunded.'
  from public.payments
  where status not in ('pending', 'processing', 'completed', 'failed', 'refunded')

  union all
  select
    'invalid_order_payment_status_values',
    count(*)::bigint,
    'Manual cleanup required: map old values to pending, paid, failed, or refunded.'
  from public.orders
  where payment_status not in ('pending', 'paid', 'failed', 'refunded')

  union all
  select
    'negative_wallet_balances',
    count(*)::bigint,
    'Manual cleanup required: reconcile against payment and ledger history before changing balances.'
  from public.wallets
  where balance < 0

  union all
  select
    'payments_referencing_missing_orders',
    count(*)::bigint,
    'Manual cleanup required: attach to the correct order or mark the payment failed/refunded with audit.'
  from public.payments p
  left join public.orders o on o.id = p.order_id
  where p.order_id is not null
    and o.id is null

  union all
  select
    'orders_referencing_missing_workers',
    count(*)::bigint,
    'Manual cleanup required: restore the worker row or cancel/migrate affected orders with audit.'
  from public.orders o
  left join public.workers w on w.id = o.worker_id
  where o.worker_id is not null
    and w.id is null

  union all
  select
    'workers_referencing_missing_profiles',
    count(*)::bigint,
    'Manual cleanup required: restore the profile or deactivate the orphan worker with audit.'
  from public.workers w
  left join public.profiles p on p.id = w.user_id
  where w.user_id is not null
    and p.id is null

  union all
  select
    'completed_payments_without_paid_orders',
    count(*)::bigint,
    'Correction may be unambiguous only when exactly one completed payment exists for the order.'
  from public.payments p
  join public.orders o on o.id = p.order_id
  where p.status = 'completed'
    and coalesce(o.payment_status, 'pending') <> 'paid'

  union all
  select
    'paid_orders_without_completed_payments',
    count(*)::bigint,
    'Manual cleanup required: find the real payment event or revert paid status with audit.'
  from public.orders o
  where coalesce(o.payment_status, 'pending') = 'paid'
    and not exists (
      select 1
      from public.payments p
      where p.order_id = o.id
        and p.status = 'completed'
    )

  union all
  select
    'wallet_ledger_invalid_balance_math',
    pg_temp.hirfati_wallet_ledger_issue_count(),
    'Manual cleanup required: ledger rows are immutable; repair through audited reversal/adjustment rows.'
)
select *
from diagnostics
order by check_name;

-- Detail queries for non-zero diagnostics:
--
-- 1. Multiple completed payments for one order.
select order_id, count(*) as completed_payment_count, array_agg(id order by created_at) as payment_ids
from public.payments
where status = 'completed'
  and order_id is not null
group by order_id
having count(*) > 1;
--
-- Automatic correction: none by default. This is ambiguous financial history.
-- Manual cleanup: identify the real captured settlement, then create an audited
-- data-fix migration that marks duplicates failed/refunded and inserts reversal
-- ledger rows if any wallet mutation occurred.

-- 2. Duplicate payment idempotency keys.
select idempotency_key, count(*) as row_count, array_agg(id order by created_at) as payment_ids
from public.payments
where nullif(btrim(idempotency_key), '') is not null
group by idempotency_key
having count(*) > 1;
--
-- Automatic correction: none. Reusing a key can hide duplicate charges.
-- Manual cleanup: group by operation intent, keep one canonical payment, and
-- give non-canonical rows new audited keys only if they are legitimate retries.

-- 3. Duplicate payment reference numbers.
select reference_number, count(*) as row_count, array_agg(id order by created_at) as payment_ids
from public.payments
where nullif(btrim(reference_number), '') is not null
group by reference_number
having count(*) > 1;
--
-- Automatic correction: only safe for abandoned non-completed rows after review.
-- Manual cleanup: assign new references through an audited migration.

-- 4. Duplicate wallets for a user.
select user_id, count(*) as wallet_count
from public.wallets
where user_id is not null
group by user_id
having count(*) > 1;
--
-- Automatic correction: none. Balances must be reconciled from ledger evidence.
-- Manual cleanup: merge dependent ledger rows, preserve a canonical wallet, and
-- document the balance proof.

-- 5. Duplicate workers for a user.
select user_id, count(*) as worker_count, array_agg(id) as worker_ids
from public.workers
where user_id is not null
group by user_id
having count(*) > 1;
--
-- Automatic correction: none. Orders, reviews, withdrawals, and portfolios may
-- point to different worker rows.

-- 6. Canonical duplicate conversations.
select
  least(user1_id, user2_id) as user_a,
  greatest(user1_id, user2_id) as user_b,
  count(*) as conversation_count,
  array_agg(id) as conversation_ids
from public.conversations
group by least(user1_id, user2_id), greatest(user1_id, user2_id)
having count(*) > 1;
--
-- Automatic correction: none. Merge messages and last-message state manually.

-- 7. Duplicate pending verification requests.
select user_id, count(*) as pending_count, array_agg(id order by created_at desc) as request_ids
from public.verification_requests
where status = 'pending'
group by user_id
having count(*) > 1;
--
-- Automatic correction candidate: reject/cancel older pending rows only after
-- selecting the canonical pending request and saving an audit reason.

-- 8. Invalid payment statuses.
select id, order_id, status, created_at
from public.payments
where status not in ('pending', 'processing', 'completed', 'failed', 'refunded');
--
-- Automatic correction: map known legacy values in a reviewed data-fix migration.

-- 9. Invalid order payment statuses.
select id, client_id, worker_id, payment_status, created_at
from public.orders
where payment_status not in ('pending', 'paid', 'failed', 'refunded');
--
-- Automatic correction: map known legacy values in a reviewed data-fix migration.

-- 10. Negative wallet balances.
select user_id, balance
from public.wallets
where balance < 0;
--
-- Automatic correction: none without ledger reconciliation.

-- 11. Payments referencing missing orders.
select p.id, p.order_id, p.status, p.amount, p.created_at
from public.payments p
left join public.orders o on o.id = p.order_id
where p.order_id is not null
  and o.id is null;
--
-- Automatic correction: none unless the correct order ID is known from audit logs.

-- 12. Orders referencing missing workers.
select o.id, o.worker_id, o.status, o.payment_status, o.created_at
from public.orders o
left join public.workers w on w.id = o.worker_id
where o.worker_id is not null
  and w.id is null;
--
-- Automatic correction: none; restore or migrate the worker relationship first.

-- 13. Workers referencing missing profiles.
select w.id, w.user_id, w.approved, w.profile_completed
from public.workers w
left join public.profiles p on p.id = w.user_id
where w.user_id is not null
  and p.id is null;
--
-- Automatic correction: none; restore the auth/profile row or deactivate safely.

-- 14. Completed payments without paid orders.
select p.id as payment_id, p.order_id, p.paid_at, o.payment_status, o.paid_at as order_paid_at
from public.payments p
join public.orders o on o.id = p.order_id
where p.status = 'completed'
  and coalesce(o.payment_status, 'pending') <> 'paid';
--
-- Safe correction candidate when the order has exactly one completed payment:
-- update public.orders o
-- set payment_status = 'paid',
--     payment_method = p.payment_method,
--     payment_transaction_id = p.transaction_id,
--     payment_reference = p.reference_number,
--     paid_at = coalesce(o.paid_at, p.paid_at)
-- from public.payments p
-- where p.order_id = o.id
--   and p.status = 'completed'
--   and coalesce(o.payment_status, 'pending') <> 'paid'
--   and 1 = (
--     select count(*)
--     from public.payments p2
--     where p2.order_id = o.id
--       and p2.status = 'completed'
--   );

-- 15. Paid orders without completed payments.
select o.id, o.client_id, o.worker_id, o.payment_status, o.paid_at
from public.orders o
where coalesce(o.payment_status, 'pending') = 'paid'
  and not exists (
    select 1
    from public.payments p
    where p.order_id = o.id
      and p.status = 'completed'
  );
--
-- Automatic correction: none. A paid order without payment evidence requires
-- manual audit before reverting or creating a historical payment row.

-- 16. Wallet ledger transactions with invalid before/after balances.
select *
from pg_temp.hirfati_wallet_ledger_issues();
--
-- Automatic correction: none. Insert auditable reversal/adjustment entries
-- instead of editing immutable ledger rows.
