create or replace function public.set_user_active_status(
  p_user_id uuid,
  p_is_active boolean
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_caller_id uuid := auth.uid();
  v_is_admin boolean;
  v_target_exists boolean;
  v_changed boolean := false;
begin
  if v_caller_id is null then
    raise exception 'Authentication required';
  end if;

  select exists (
    select 1
    from public.profiles
    where id = v_caller_id
      and lower(coalesce(role::text, '')) = 'admin'
      and is_active is not false
  ) into v_is_admin;

  if not v_is_admin then
    raise exception 'Admin access required';
  end if;

  if p_user_id = v_caller_id and not p_is_active then
    raise exception 'An admin cannot disable their own account';
  end if;

  select exists (
    select 1 from public.profiles where id = p_user_id
  ) into v_target_exists;

  if not v_target_exists then
    raise exception 'User profile not found';
  end if;

  update public.profiles
  set is_active = p_is_active,
      updated_at = now()
  where id = p_user_id
    and is_active is distinct from p_is_active;

  v_changed := found;

  if not p_is_active then
    update public.workers
    set is_available = false,
        updated_at = now()
    where user_id = p_user_id
      and is_available is distinct from false;
  end if;

  return jsonb_build_object(
    'success', true,
    'user_id', p_user_id,
    'is_active', p_is_active,
    'changed', v_changed
  );
end;
$$;

revoke all on function public.set_user_active_status(uuid, boolean) from public;
grant execute on function public.set_user_active_status(uuid, boolean) to authenticated;
