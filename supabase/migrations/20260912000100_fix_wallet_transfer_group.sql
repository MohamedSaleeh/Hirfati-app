begin;

-- توحيد اسم العمود في wallet_transactions إلى transfer_group
do $$
begin
  -- الحالة القديمة: يوجد transfer_group_id ولا يوجد transfer_group
  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'wallet_transactions'
      and column_name = 'transfer_group_id'
  )
  and not exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'wallet_transactions'
      and column_name = 'transfer_group'
  ) then

    alter table public.wallet_transactions
      rename column transfer_group_id to transfer_group;

  -- إذا كان العمودان موجودين لسبب ما، احتفظ بـ transfer_group
  elsif exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'wallet_transactions'
      and column_name = 'transfer_group_id'
  )
  and exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'wallet_transactions'
      and column_name = 'transfer_group'
  ) then

    alter table public.wallet_transactions
      disable trigger wallet_transactions_immutable_trigger;

    update public.wallet_transactions
    set transfer_group = coalesce(transfer_group, transfer_group_id);

    alter table public.wallet_transactions
      enable trigger wallet_transactions_immutable_trigger;

    alter table public.wallet_transactions
      drop column transfer_group_id;

  -- احتياطًا إذا لم يكن أي منهما موجودًا
  elsif not exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'wallet_transactions'
      and column_name = 'transfer_group'
  ) then

    alter table public.wallet_transactions
      add column transfer_group uuid;

  end if;
end
$$;

drop index if exists public.wallet_transactions_transfer_group_id_idx;

create index if not exists wallet_transactions_transfer_group_idx
  on public.wallet_transactions (transfer_group);

-- إصلاح RPC الحالية بدون إعادة كتابة الدالة كاملة
do $$
declare
  v_function_definition text;
begin
  select pg_get_functiondef(
    'public.settle_order_payment(uuid,text,text,text,text)'::regprocedure
  )
  into v_function_definition;

  if position('transfer_group_id' in v_function_definition) > 0 then
    v_function_definition :=
      replace(
        v_function_definition,
        'transfer_group_id',
        'transfer_group'
      );

    execute v_function_definition;
  end if;
end
$$;

commit;