create extension if not exists pgcrypto;
create extension if not exists postgis;

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  role text not null default 'client',
  phone text,
  avatar_url text,
  city text,
  address text,
  latitude double precision,
  longitude double precision,
  is_active boolean not null default true,
  shamcash_pin text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint profiles_role_check check (role in ('client', 'worker', 'admin'))
);

create table public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  icon text,
  description text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.workers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null,
  category_id uuid,
  experience_years integer not null default 0,
  bio text,
  price_min numeric not null default 0,
  price_max numeric not null default 0,
  is_available boolean not null default true,
  approved boolean not null default false,
  profile_completed boolean not null default false,
  rating_average numeric not null default 0,
  rating_count integer not null default 0,
  total_reviews integer not null default 0,
  completed_orders integer not null default 0,
  location geography(point, 4326),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint workers_user_id_fkey
    foreign key (user_id) references public.profiles(id) on delete cascade,
  constraint workers_category_id_fkey
    foreign key (category_id) references public.categories(id) on delete set null
);

create index workers_location_idx on public.workers using gist (location);

create table public.services (
  id uuid primary key default gen_random_uuid(),
  worker_id uuid,
  category_id uuid,
  title text not null,
  description text,
  price numeric not null default 0,
  duration_minutes integer,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint services_worker_id_fkey
    foreign key (worker_id) references public.workers(id) on delete cascade,
  constraint services_category_id_fkey
    foreign key (category_id) references public.categories(id) on delete set null
);

create table public.addresses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  title text,
  address text not null,
  latitude double precision,
  longitude double precision,
  is_default boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.orders (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null,
  worker_id uuid,
  service_id uuid,
  category_id uuid,
  description text,
  price numeric not null default 0,
  title text,
  photos text[] not null default '{}'::text[],
  address text,
  latitude double precision,
  longitude double precision,
  scheduled_at timestamptz,
  preferred_time_slot text,
  access_instructions text,
  status text not null default 'pending',
  payment_status text not null default 'pending',
  payment_method text,
  payment_transaction_id text,
  cancelled_at timestamptz,
  paid_at timestamptz,
  is_active boolean not null default true,
  created_by text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint orders_status_check
    check (status in ('pending', 'accepted', 'rejected', 'in_progress', 'completed', 'cancelled')),
  constraint orders_payment_status_check
    check (payment_status in ('pending', 'paid', 'failed', 'refunded')),
  constraint orders_client_id_fkey
    foreign key (client_id) references public.profiles(id) on delete cascade,
  constraint orders_worker_id_fkey
    foreign key (worker_id) references public.workers(id) on delete set null,
  constraint orders_service_id_fkey
    foreign key (service_id) references public.services(id) on delete set null,
  constraint orders_category_id_fkey
    foreign key (category_id) references public.categories(id) on delete set null
);

create table public.payments (
  id uuid primary key default gen_random_uuid(),
  order_id uuid references public.orders(id) on delete cascade,
  amount numeric not null default 0,
  user_id uuid references public.profiles(id) on delete set null,
  payment_method text,
  status text not null default 'pending',
  transaction_id text,
  reference_number text,
  paid_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.payment_events (
  id uuid primary key default gen_random_uuid(),
  payment_id uuid references public.payments(id) on delete cascade,
  event_type text,
  event_data jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  created_by uuid references public.profiles(id) on delete set null
);

create table public.wallets (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  balance numeric not null default 0,
  constraint wallets_balance_non_negative_check check (balance >= 0)
);

create table public.withdrawals (
  id uuid primary key default gen_random_uuid(),
  worker_id uuid not null references public.workers(id) on delete cascade,
  amount numeric not null,
  status text not null default 'pending',
  bank_name text,
  account_number text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint withdrawals_status_check check (status in ('pending', 'completed', 'failed')),
  constraint withdrawals_amount_positive_check check (amount > 0)
);

create table public.verification_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  worker_id uuid references public.workers(id) on delete cascade,
  status text not null default 'pending',
  document_type text,
  document_url text,
  rejection_reason text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint verification_requests_status_check check (status in ('pending', 'approved', 'rejected'))
);

create table public.conversations (
  id uuid primary key default gen_random_uuid(),
  user1_id uuid not null references public.profiles(id) on delete cascade,
  user2_id uuid not null references public.profiles(id) on delete cascade,
  last_message text,
  last_message_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint conversations_distinct_users_check check (user1_id <> user2_id)
);

create table public.messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations(id) on delete cascade,
  sender_id uuid not null references public.profiles(id) on delete cascade,
  receiver_id uuid not null references public.profiles(id) on delete cascade,
  content text,
  message_type text not null default 'text',
  attachment_url text,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.device_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  token text not null,
  platform text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint device_tokens_token_key unique (token)
);

create table public.notification_settings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  push_enabled boolean not null default true,
  email_enabled boolean not null default false,
  sms_enabled boolean not null default false,
  order_updates boolean not null default true,
  messages boolean not null default true,
  promotions boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  body text not null,
  type text not null default 'general',
  data jsonb not null default '{}'::jsonb,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.favorites (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  worker_id uuid not null references public.workers(id) on delete cascade,
  created_at timestamptz not null default now(),
  constraint favorites_user_worker_key unique (user_id, worker_id)
);

create table public.reviews (
  id uuid primary key default gen_random_uuid(),
  order_id uuid references public.orders(id) on delete cascade,
  client_id uuid not null references public.profiles(id) on delete cascade,
  worker_id uuid not null references public.workers(id) on delete cascade,
  rating integer not null,
  comment text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint reviews_rating_check check (rating between 1 and 5)
);

create table public.support_messages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete set null,
  subject text,
  message text not null,
  status text not null default 'open',
  is_resolved boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.faqs (
  id uuid primary key default gen_random_uuid(),
  question text not null,
  answer text not null,
  category text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.work_portfolio (
  id uuid primary key default gen_random_uuid(),
  worker_id uuid not null references public.workers(id) on delete cascade,
  title text,
  description text,
  image_url text,
  category_id uuid references public.categories(id) on delete set null,
  created_at timestamptz not null default now()
);

create table public.worker_portfolio (
  id uuid primary key default gen_random_uuid(),
  worker_id uuid not null references public.workers(id) on delete cascade,
  title text,
  description text,
  image_url text,
  category_id uuid references public.categories(id) on delete set null,
  created_at timestamptz not null default now()
);

create index addresses_user_id_idx on public.addresses(user_id);
create index workers_user_id_idx on public.workers(user_id);
create index workers_category_id_idx on public.workers(category_id);
create index services_worker_id_idx on public.services(worker_id);
create index services_category_id_idx on public.services(category_id);
create index orders_client_id_idx on public.orders(client_id);
create index orders_worker_id_idx on public.orders(worker_id);
create index orders_status_idx on public.orders(status);
create index payments_order_id_idx on public.payments(order_id);
create index payments_user_id_idx on public.payments(user_id);
create index payment_events_payment_id_idx on public.payment_events(payment_id);
create index withdrawals_worker_id_idx on public.withdrawals(worker_id);
create index verification_requests_user_id_idx on public.verification_requests(user_id);
create index messages_conversation_created_at_idx on public.messages(conversation_id, created_at);
create index notifications_user_created_at_idx on public.notifications(user_id, created_at desc);

alter table public.profiles enable row level security;
alter table public.categories enable row level security;
alter table public.workers enable row level security;
alter table public.services enable row level security;
alter table public.addresses enable row level security;
alter table public.orders enable row level security;
alter table public.payments enable row level security;
alter table public.payment_events enable row level security;
alter table public.wallets enable row level security;
alter table public.withdrawals enable row level security;
alter table public.verification_requests enable row level security;
alter table public.conversations enable row level security;
alter table public.messages enable row level security;
alter table public.device_tokens enable row level security;
alter table public.notification_settings enable row level security;
alter table public.notifications enable row level security;
alter table public.favorites enable row level security;
alter table public.reviews enable row level security;
alter table public.support_messages enable row level security;
alter table public.faqs enable row level security;
alter table public.work_portfolio enable row level security;
alter table public.worker_portfolio enable row level security;

grant usage on schema public to anon, authenticated;

grant select, insert, update on public.profiles to authenticated;
grant select on public.categories, public.faqs to authenticated;
grant select, insert, update on public.workers to authenticated;
grant select on public.services, public.reviews, public.work_portfolio, public.worker_portfolio to authenticated;
grant select, insert, update, delete on public.addresses to authenticated;
grant select, insert, update on public.orders to authenticated;
grant select, insert, update, delete on public.notifications to authenticated;
grant select, insert, update, delete on public.device_tokens to authenticated;
grant select, insert, update, delete on public.notification_settings to authenticated;
grant select on public.conversations, public.messages to authenticated;

create policy profiles_select_own
on public.profiles
for select
to authenticated
using (id = auth.uid());

create policy profiles_insert_own
on public.profiles
for insert
to authenticated
with check (id = auth.uid());

create policy profiles_update_own_non_admin
on public.profiles
for update
to authenticated
using (id = auth.uid())
with check (id = auth.uid() and role <> 'admin');

create policy categories_select_authenticated
on public.categories
for select
to authenticated
using (true);

create policy workers_select_authenticated
on public.workers
for select
to authenticated
using (true);

create policy workers_insert_own
on public.workers
for insert
to authenticated
with check (user_id = auth.uid());

create policy workers_update_own
on public.workers
for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid() and approved = false);

create policy services_select_authenticated
on public.services
for select
to authenticated
using (true);

create policy addresses_select_own
on public.addresses
for select
to authenticated
using (user_id = auth.uid());

create policy addresses_insert_own
on public.addresses
for insert
to authenticated
with check (user_id = auth.uid());

create policy addresses_update_own
on public.addresses
for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

create policy addresses_delete_own
on public.addresses
for delete
to authenticated
using (user_id = auth.uid());

create policy orders_select_participant
on public.orders
for select
to authenticated
using (
  client_id = auth.uid()
  or exists (
    select 1 from public.workers w
    where w.id = orders.worker_id
      and w.user_id = auth.uid()
  )
);

create policy orders_insert_client
on public.orders
for insert
to authenticated
with check (client_id = auth.uid());

create policy orders_update_participant
on public.orders
for update
to authenticated
using (
  client_id = auth.uid()
  or exists (
    select 1 from public.workers w
    where w.id = orders.worker_id
      and w.user_id = auth.uid()
  )
)
with check (
  client_id = auth.uid()
  or exists (
    select 1 from public.workers w
    where w.id = orders.worker_id
      and w.user_id = auth.uid()
  )
);

create policy notifications_select_own
on public.notifications
for select
to authenticated
using (user_id = auth.uid());

create policy notifications_insert_own
on public.notifications
for insert
to authenticated
with check (user_id = auth.uid());

create policy notifications_update_own
on public.notifications
for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

create policy notifications_delete_own
on public.notifications
for delete
to authenticated
using (user_id = auth.uid());

create policy device_tokens_own
on public.device_tokens
for all
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

create policy notification_settings_own
on public.notification_settings
for all
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

create policy conversations_select_participant
on public.conversations
for select
to authenticated
using (user1_id = auth.uid() or user2_id = auth.uid());

create policy messages_select_participant
on public.messages
for select
to authenticated
using (sender_id = auth.uid() or receiver_id = auth.uid());
