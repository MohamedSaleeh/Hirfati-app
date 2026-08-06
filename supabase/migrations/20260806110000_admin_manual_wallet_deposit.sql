create or replace function public.admin_credit_wallet(
  p_user_id uuid,
  p_amount numeric,
  p_reference text,
  p_note text,
  p_idempotency_key text
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_admin_id uuid := auth.uid();
  v_profile record;
  v_wallet record;
  v_existing record;
  v_transaction_id uuid := gen_random_uuid();
  v_transfer_group uuid := gen_random_uuid();
  v_balance_before numeric(14, 2);
  v_balance_after numeric(14, 2);
  v_created_at timestamptz := now();
  v_description text;
begin
  if v_admin_id is null then
    raise exception 'unauthenticated';
  end if;

  if not exists (
    select 1 from public.profiles
    where id = v_admin_id
      and lower(coalesce(role::text, '')) = 'admin'
      and is_active is not false
  ) then
    raise exception 'forbidden';
  end if;

  if p_amount is null or p_amount <= 0 then
    raise exception 'invalid_deposit_amount';
  end if;
  if nullif(btrim(coalesce(p_reference, '')), '') is null then
    raise exception 'missing_external_reference';
  end if;
  if nullif(btrim(coalesce(p_idempotency_key, '')), '') is null then
    raise exception 'missing_idempotency_key';
  end if;

  perform pg_advisory_xact_lock(hashtextextended(p_idempotency_key, 0));

  select id, wallet_user_id, amount, balance_before, balance_after,
         transfer_group, currency, created_at, metadata
  into v_existing
  from public.wallet_transactions
  where idempotency_key = p_idempotency_key
  limit 1;

  if v_existing.id is not null then
    if v_existing.wallet_user_id <> p_user_id
       or v_existing.amount <> p_amount
       or coalesce(v_existing.metadata ->> 'external_reference', '') <>
          btrim(p_reference) then
      raise exception 'idempotency_conflict';
    end if;

    return jsonb_build_object(
      'success', true,
      'idempotent', true,
      'transaction_id', v_existing.id,
      'transfer_group', v_existing.transfer_group,
      'user_id', v_existing.wallet_user_id,
      'amount', v_existing.amount,
      'currency', v_existing.currency,
      'balance_before', v_existing.balance_before,
      'balance_after', v_existing.balance_after,
      'external_reference', v_existing.metadata ->> 'external_reference',
      'created_at', v_existing.created_at
    );
  end if;

  select id, role, is_active
  into v_profile
  from public.profiles
  where id = p_user_id;

  if v_profile.id is null then
    raise exception 'target_user_not_found';
  end if;
  if lower(coalesce(v_profile.role::text, '')) <> 'client' then
    raise exception 'target_must_be_client';
  end if;
  if v_profile.is_active is false then
    raise exception 'inactive_target_account';
  end if;

  insert into public.wallets (user_id, balance)
  values (p_user_id, 0)
  on conflict (user_id) do nothing;

  select balance, is_locked
  into v_wallet
  from public.wallets
  where user_id = p_user_id
  for update;

  if v_wallet.is_locked is true then
    raise exception 'wallet_locked';
  end if;

  v_balance_before := coalesce(v_wallet.balance, 0);
  v_balance_after := v_balance_before + p_amount;
  v_description := coalesce(
    nullif(btrim(coalesce(p_note, '')), ''),
    'Manual wallet top-up via WhatsApp support'
  );

  update public.wallets
  set balance = v_balance_after,
      updated_at = v_created_at,
      last_transaction_at = v_created_at
  where user_id = p_user_id;

  insert into public.wallet_transactions (
    id, wallet_user_id, counterparty_user_id, transaction_type, direction,
    amount, balance_before, balance_after, status, currency, created_by,
    created_by_user_id, idempotency_key, title, description, metadata,
    transfer_group, created_at
  ) values (
    v_transaction_id, p_user_id, v_admin_id, 'deposit', 'credit', p_amount,
    v_balance_before, v_balance_after, 'completed', 'SYP', 'admin',
    v_admin_id, p_idempotency_key, 'Manual wallet top-up', v_description,
    jsonb_build_object(
      'source', 'whatsapp_manual_topup',
      'external_reference', btrim(p_reference)
    ),
    v_transfer_group, v_created_at
  );

  insert into public.admin_audit_logs (
    admin_id, action, entity_type, entity_id, reason, old_values, new_values
  ) values (
    v_admin_id,
    'wallet_manual_deposit',
    'wallet',
    p_user_id,
    coalesce(nullif(btrim(coalesce(p_note, '')), ''), btrim(p_reference)),
    jsonb_build_object('balance', v_balance_before),
    jsonb_build_object(
      'balance', v_balance_after,
      'amount', p_amount,
      'transaction_id', v_transaction_id
    )
  );

  return jsonb_build_object(
    'success', true,
    'idempotent', false,
    'transaction_id', v_transaction_id,
    'transfer_group', v_transfer_group,
    'user_id', p_user_id,
    'amount', p_amount,
    'currency', 'SYP',
    'balance_before', v_balance_before,
    'balance_after', v_balance_after,
    'external_reference', btrim(p_reference),
    'created_at', v_created_at
  );
end;
$$;

revoke all on function public.admin_credit_wallet(uuid, numeric, text, text, text)
from public;
grant execute on function public.admin_credit_wallet(uuid, numeric, text, text, text)
to authenticated;
