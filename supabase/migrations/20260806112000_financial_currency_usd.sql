do $$
begin
  if exists (
    select 1 from public.payments
    where nullif(btrim(currency), '') is not null
      and upper(btrim(currency)) not in ('SYP', 'USD')
  ) then
    raise exception 'unexpected_payment_currency';
  end if;

  if exists (
    select 1 from public.wallet_transactions
    where nullif(btrim(currency), '') is not null
      and upper(btrim(currency)) not in ('SYP', 'USD')
  ) then
    raise exception 'unexpected_wallet_transaction_currency';
  end if;
end;
$$;

alter table public.payments
  alter column currency set default 'USD';

alter table public.wallet_transactions
  alter column currency set default 'USD';

update public.payments
set currency = 'USD'
where upper(btrim(currency)) = 'SYP';

update public.wallet_transactions
set currency = 'USD'
where upper(btrim(currency)) = 'SYP';

do $$
declare
  v_signature regprocedure;
  v_definition text;
begin
  v_signature := to_regprocedure(
    'public.admin_credit_wallet(uuid,numeric,text,text,text)'
  );
  if v_signature is null then
    raise exception 'admin_credit_wallet_not_found';
  end if;
  select pg_get_functiondef(v_signature) into v_definition;
  execute replace(v_definition, '''SYP''', '''USD''');

  v_signature := to_regprocedure(
    'public.settle_order_payment(uuid,text,text,text,text)'
  );
  if v_signature is null then
    raise exception 'settle_order_payment_not_found';
  end if;
  select pg_get_functiondef(v_signature) into v_definition;
  execute replace(v_definition, '''SYP''', '''USD''');
end;
$$;
