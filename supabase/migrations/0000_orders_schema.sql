create table if not exists orders (
  id uuid primary key default gen_random_uuid(),
  client_id uuid references profiles(id) on delete cascade not null,
  worker_id uuid references workers(id) on delete restrict not null,
  category_id uuid references categories(id) on delete restrict,
  status text not null,
  scheduled_at timestamptz,
  started_at timestamptz,
  price numeric(10, 2),
  created_at timestamptz default now()
);

-- Indexes for performance
create index if not exists idx_orders_client_id on orders(client_id);
create index if not exists idx_orders_worker_id on orders(worker_id);
create index if not exists idx_orders_status on orders(status);
create index if not exists idx_orders_created_at on orders(created_at desc);

-- Enable RLS
alter table orders enable row level security;

-- Policies
create policy "Clients can view their own orders."
  on orders for select
  using ( auth.uid() = client_id );

-- Depending on the use case, insert and update policies might be needed, 
-- but this covers the select policy required for the client app tab views.
create policy "Clients can create their own orders."
  on orders for insert
  with check ( auth.uid() = client_id );
