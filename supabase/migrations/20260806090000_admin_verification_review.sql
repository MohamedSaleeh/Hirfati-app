alter table public.verification_requests enable row level security;

drop policy if exists "verification_requests_admin_select" on public.verification_requests;
create policy "verification_requests_admin_select"
on public.verification_requests
for select
to authenticated
using (
  exists (
    select 1
    from public.profiles
    where profiles.id = auth.uid()
      and profiles.role = 'admin'
  )
);

drop policy if exists "verification_requests_admin_update" on public.verification_requests;
create policy "verification_requests_admin_update"
on public.verification_requests
for update
to authenticated
using (
  status = 'pending'
  and exists (
    select 1
    from public.profiles
    where profiles.id = auth.uid()
      and profiles.role = 'admin'
  )
)
with check (
  status in ('approved', 'rejected')
  and exists (
    select 1
    from public.profiles
    where profiles.id = auth.uid()
      and profiles.role = 'admin'
  )
);

drop policy if exists "verification_requests_worker_select_own" on public.verification_requests;
create policy "verification_requests_worker_select_own"
on public.verification_requests
for select
to authenticated
using (user_id = auth.uid());

drop policy if exists "verification_requests_worker_insert_own" on public.verification_requests;
create policy "verification_requests_worker_insert_own"
on public.verification_requests
for insert
to authenticated
with check (user_id = auth.uid() and status = 'pending');

create or replace function public.process_verification_request(
  p_request_id uuid,
  p_status text,
  p_rejection_reason text default null
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid;
  v_worker_count integer;
begin
  if auth.uid() is null then
    raise exception 'unauthenticated';
  end if;

  if not exists (
    select 1
    from public.profiles
    where profiles.id = auth.uid()
      and profiles.role = 'admin'
  ) then
    raise exception 'forbidden';
  end if;

  if p_status not in ('approved', 'rejected') then
    raise exception 'invalid_verification_status';
  end if;

  if p_status = 'rejected'
     and nullif(btrim(coalesce(p_rejection_reason, '')), '') is null then
    raise exception 'missing_rejection_reason';
  end if;

  update public.verification_requests
  set status = p_status,
      rejection_reason = case
        when p_status = 'approved' then null
        else btrim(p_rejection_reason)
      end,
      updated_at = now()
  where id = p_request_id
    and status = 'pending'
  returning user_id into v_user_id;

  if v_user_id is null then
    raise exception 'verification_request_already_processed';
  end if;

  update public.workers
  set approved = (p_status = 'approved'),
      updated_at = now()
  where workers.user_id = v_user_id;

  get diagnostics v_worker_count = row_count;
  if v_worker_count = 0 then
    raise exception 'worker_not_found';
  end if;
end;
$$;

revoke all on function public.process_verification_request(uuid, text, text)
from public;
grant execute on function public.process_verification_request(uuid, text, text)
to authenticated;
