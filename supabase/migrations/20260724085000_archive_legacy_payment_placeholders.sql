-- Archive and remove three audited legacy cash-payment placeholder rows.
-- This migration must run immediately before the consolidated Wallet Ledger
-- migration. It does not infer amounts or modify related orders.

create table if not exists public.legacy_payment_archive (
  id uuid primary key default gen_random_uuid(),
  original_payment_id uuid not null,
  original_order_id uuid,
  payment_snapshot jsonb not null,
  order_snapshot jsonb,
  archive_reason text not null,
  migration_name text not null,
  archived_at timestamptz not null default now()
);

create unique index if not exists legacy_payment_archive_original_payment_id_key
  on public.legacy_payment_archive (original_payment_id);

alter table public.legacy_payment_archive enable row level security;

revoke all on table public.legacy_payment_archive from public;
revoke all on table public.legacy_payment_archive from anon;
revoke all on table public.legacy_payment_archive from authenticated;

do $$
declare
  r record;
  v_payment_snapshot jsonb;
  v_order_snapshot jsonb;
  v_archive_exists boolean;
  v_existing_archive_order_id uuid;
  v_has_references boolean;
  v_deleted_count integer;
begin
  for r in
    select *
    from (
      values
        (
          '3a039aae-5146-458e-95d8-650192534fd5'::uuid,
          '8c9c1091-50b6-49df-9667-9d9f648a4d56'::uuid
        ),
        (
          '2e1c1fd1-e6a4-4e12-ae48-4a5c3c95a9e5'::uuid,
          'ae365ac6-45e6-48bc-bb2d-c1f91271319a'::uuid
        ),
        (
          '6360c9f5-1e2c-4787-b37d-2871aad1f449'::uuid,
          '940e6e8a-bd76-419e-8b3f-cbca4f8a601b'::uuid
        )
    ) as target(payment_id, order_id)
  loop
    select exists (
      select 1
      from public.legacy_payment_archive lpa
      where lpa.original_payment_id = r.payment_id
    )
    into v_archive_exists;

    select lpa.original_order_id
    into v_existing_archive_order_id
    from public.legacy_payment_archive lpa
    where lpa.original_payment_id = r.payment_id;

    if v_archive_exists
      and v_existing_archive_order_id is distinct from r.order_id then
      raise exception
        'legacy_payment_archive_order_id_mismatch_for_payment: %',
        r.payment_id;
    end if;

    select to_jsonb(p)
    into v_payment_snapshot
    from public.payments p
    where p.id = r.payment_id;

    if v_payment_snapshot is null then
      if v_archive_exists then
        continue;
      end if;

      raise exception
        'legacy_payment_placeholder_missing_without_archive: %',
        r.payment_id;
    end if;

    if not (v_payment_snapshot ? 'provider') then
      raise exception
        'legacy_payment_placeholder_provider_column_missing_for_payment: %',
        r.payment_id;
    end if;

    if not (v_payment_snapshot ? 'amount') then
      raise exception
        'legacy_payment_placeholder_amount_column_missing_for_payment: %',
        r.payment_id;
    end if;

    if v_payment_snapshot->>'order_id' is distinct from r.order_id::text then
      raise exception
        'legacy_payment_placeholder_order_id_changed_for_payment: %',
        r.payment_id;
    end if;

    if (v_payment_snapshot->>'amount') is not null
      and (v_payment_snapshot->>'amount')::numeric > 0 then
      raise exception
        'legacy_payment_placeholder_amount_changed_for_payment: %',
        r.payment_id;
    end if;

    if lower(btrim(coalesce(v_payment_snapshot->>'status', '')))
      <> 'pending' then
      raise exception
        'legacy_payment_placeholder_status_changed_for_payment: %',
        r.payment_id;
    end if;

    if lower(btrim(coalesce(v_payment_snapshot->>'payment_method', '')))
      <> 'cash' then
      raise exception
        'legacy_payment_placeholder_method_changed_for_payment: %',
        r.payment_id;
    end if;

    if lower(btrim(coalesce(v_payment_snapshot->>'provider', ''))) not in (
      'sham_cash_mock',
      'sham_cash',
      'shamcash'
    ) then
      raise exception
        'legacy_payment_placeholder_provider_changed_for_payment: %',
        r.payment_id;
    end if;

    if nullif(btrim(coalesce(v_payment_snapshot->>'transaction_id', '')), '')
      is not null then
      raise exception
        'legacy_payment_placeholder_transaction_id_present_for_payment: %',
        r.payment_id;
    end if;

    if nullif(btrim(coalesce(v_payment_snapshot->>'reference_number', '')), '')
      is not null then
      raise exception
        'legacy_payment_placeholder_reference_number_present_for_payment: %',
        r.payment_id;
    end if;

    if nullif(btrim(coalesce(v_payment_snapshot->>'idempotency_key', '')), '')
      is not null then
      raise exception
        'legacy_payment_placeholder_idempotency_key_present_for_payment: %',
        r.payment_id;
    end if;

    select jsonb_build_object(
      'id',
      o.id,
      'client_id',
      o.client_id,
      'worker_id',
      o.worker_id,
      'service_id',
      o.service_id,
      'price',
      o.price,
      'status',
      o.status,
      'payment_status',
      o.payment_status,
      'payment_method',
      o.payment_method,
      'paid_at',
      o.paid_at,
      'created_at',
      o.created_at
    )
    into v_order_snapshot
    from public.orders o
    where o.id = r.order_id;

    if v_order_snapshot is null then
      raise exception
        'legacy_payment_placeholder_related_order_missing_for_payment: %',
        r.payment_id;
    end if;

    if lower(btrim(coalesce(v_order_snapshot->>'status', '')))
      <> 'completed' then
      raise exception
        'legacy_payment_placeholder_order_status_changed_for_payment: %',
        r.payment_id;
    end if;

    if lower(btrim(coalesce(v_order_snapshot->>'payment_status', '')))
      <> 'paid' then
      raise exception
        'legacy_payment_placeholder_order_payment_status_changed_for_payment: %',
        r.payment_id;
    end if;

    if to_regclass('public.wallet_transactions') is not null
      and exists (
        select 1
        from information_schema.columns
        where table_schema = 'public'
          and table_name = 'wallet_transactions'
          and column_name = 'payment_id'
      ) then
      execute
        'select exists (
          select 1
          from public.wallet_transactions
          where payment_id = $1
        )'
      into v_has_references
      using r.payment_id;

      if v_has_references then
        raise exception
          'legacy_payment_placeholder_has_wallet_transactions: %',
          r.payment_id;
      end if;
    end if;

    if to_regclass('public.payment_events') is not null
      and exists (
        select 1
        from information_schema.columns
        where table_schema = 'public'
          and table_name = 'payment_events'
          and column_name = 'payment_id'
      ) then
      execute
        'select exists (
          select 1
          from public.payment_events
          where payment_id = $1
        )'
      into v_has_references
      using r.payment_id;

      if v_has_references then
        raise exception
          'legacy_payment_placeholder_has_payment_events: %',
          r.payment_id;
      end if;
    end if;

    insert into public.legacy_payment_archive (
      original_payment_id,
      original_order_id,
      payment_snapshot,
      order_snapshot,
      archive_reason,
      migration_name
    )
    values (
      r.payment_id,
      r.order_id,
      v_payment_snapshot,
      v_order_snapshot,
      'abandoned_legacy_shamcash_cash_payment_placeholder',
      '20260724085000_archive_legacy_payment_placeholders'
    )
    on conflict (original_payment_id) do nothing;

    if not exists (
      select 1
      from public.legacy_payment_archive lpa
      where lpa.original_payment_id = r.payment_id
    ) then
      raise exception
        'legacy_payment_placeholder_archive_missing_before_delete: %',
        r.payment_id;
    end if;

    delete from public.payments p
    where p.id = r.payment_id;

    get diagnostics v_deleted_count = row_count;

    if v_deleted_count <> 1 then
      raise exception
        'legacy_payment_placeholder_delete_failed_for_payment: %',
        r.payment_id;
    end if;
  end loop;
end $$;

do $$
declare
  v_payment_ids uuid[] := array[
    '3a039aae-5146-458e-95d8-650192534fd5'::uuid,
    '2e1c1fd1-e6a4-4e12-ae48-4a5c3c95a9e5'::uuid,
    '6360c9f5-1e2c-4787-b37d-2871aad1f449'::uuid
  ];
  v_has_references boolean;
begin
  if exists (
    select 1
    from public.payments p
    where p.id = any(v_payment_ids)
  ) then
    raise exception 'legacy_payment_placeholders_still_present_after_archive';
  end if;

  if (
    select count(*)
    from public.legacy_payment_archive lpa
    where lpa.original_payment_id = any(v_payment_ids)
  ) <> 3 then
    raise exception 'legacy_payment_archive_missing_expected_payment_ids';
  end if;

  if to_regclass('public.wallet_transactions') is not null
    and exists (
      select 1
      from information_schema.columns
      where table_schema = 'public'
        and table_name = 'wallet_transactions'
        and column_name = 'payment_id'
    ) then
    execute
      'select exists (
        select 1
        from public.wallet_transactions
        where payment_id = any($1)
      )'
    into v_has_references
    using v_payment_ids;

    if v_has_references then
      raise exception 'legacy_payment_placeholders_have_wallet_transactions_after_archive';
    end if;
  end if;

  if to_regclass('public.payment_events') is not null
    and exists (
      select 1
      from information_schema.columns
      where table_schema = 'public'
        and table_name = 'payment_events'
        and column_name = 'payment_id'
    ) then
    execute
      'select exists (
        select 1
        from public.payment_events
        where payment_id = any($1)
      )'
    into v_has_references
    using v_payment_ids;

    if v_has_references then
      raise exception 'legacy_payment_placeholders_have_payment_events_after_archive';
    end if;
  end if;

  if exists (
    select 1
    from (
      values
        (
          '8c9c1091-50b6-49df-9667-9d9f648a4d56'::uuid,
          'paid'::text
        ),
        (
          'ae365ac6-45e6-48bc-bb2d-c1f91271319a'::uuid,
          'paid'::text
        ),
        (
          '940e6e8a-bd76-419e-8b3f-cbca4f8a601b'::uuid,
          'paid'::text
        )
    ) as expected(order_id, payment_status)
    left join public.orders o on o.id = expected.order_id
    where o.id is null
      or o.payment_status is distinct from expected.payment_status
  ) then
    raise exception 'legacy_payment_placeholder_related_orders_changed';
  end if;

  raise notice
    'Historical audit issue remains: related orders are marked paid without these archived active payment placeholder rows.';
end $$;
