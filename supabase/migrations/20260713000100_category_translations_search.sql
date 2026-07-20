create table if not exists public.category_translations (
  category_id uuid not null,
  locale text not null,
  name text not null,
  search_terms text[] not null default '{}'::text[],
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint category_translations_pkey
    primary key (category_id, locale),

  constraint category_translations_category_id_fkey
    foreign key (category_id)
    references public.categories (id)
    on delete cascade,

  constraint category_translations_locale_check
    check (locale in ('ar', 'en')),

  constraint category_translations_name_check
    check (btrim(name) <> '')
);

create index if not exists idx_category_translations_category_id
  on public.category_translations(category_id);

create index if not exists idx_category_translations_locale
  on public.category_translations(locale);

alter table public.category_translations enable row level security;

grant select on public.category_translations to authenticated;

drop policy if exists "Authenticated users can read category translations"
  on public.category_translations;

create policy "Authenticated users can read category translations"
  on public.category_translations
  for select
  to authenticated
  using (true);

create or replace function public.normalize_hirfati_search(value text)
returns text
language sql
immutable
parallel safe
as $$
  select trim(
    regexp_replace(
      regexp_replace(
        translate(
          lower(coalesce(value, '')),
          'أإآىـ',
          'اااي'
        ),
        '[ًٌٍَُِّْٰ]',
        '',
        'g'
      ),
      '[[:space:]]+',
      ' ',
      'g'
    )
  );
$$;

create or replace function public.search_approved_worker_ids(
  search_query text
)
returns table(worker_id uuid)
language sql
stable
security invoker
set search_path = public
as $$
  with normalized_query as (
    select public.normalize_hirfati_search(search_query) as value
  )
  select distinct w.id as worker_id
  from public.workers w
  join public.profiles p
    on p.id = w.user_id
  left join public.categories c
    on c.id = w.category_id
  left join public.category_translations ct
    on ct.category_id = c.id
  cross join normalized_query nq
  where w.approved = true
    and nq.value <> ''
    and (
      public.normalize_hirfati_search(p.full_name)
        like '%' || nq.value || '%'

      or public.normalize_hirfati_search(c.name)
        like '%' || nq.value || '%'

      or public.normalize_hirfati_search(ct.name)
        like '%' || nq.value || '%'

      or exists (
        select 1
        from unnest(
          coalesce(ct.search_terms, '{}'::text[])
        ) as search_term
        where public.normalize_hirfati_search(search_term)
          like '%' || nq.value || '%'
      )
    );
$$;

grant execute on function public.search_approved_worker_ids(text)
  to authenticated;

do $$
declare
  duplicate_names text;
begin
  select string_agg(name, ', ' order by name)
  into duplicate_names
  from (
    select name
    from public.categories
    where name in (
      'Air Conditioning',
      'Painting',
      'Blacksmith',
      'Plumbing',
      'Electrical',
      'Carpentry'
    )
    group by name
    having count(*) > 1
  ) duplicates;

  if duplicate_names is not null then
    raise exception
      'Cannot seed category_translations by name because duplicate categories.name values exist: %',
      duplicate_names;
  end if;
end $$;

insert into public.category_translations (
  category_id,
  locale,
  name,
  search_terms
)
select
  c.id,
  seed.locale,
  seed.translated_name,
  seed.search_terms
from public.categories c
join (
  values
    (
      'Air Conditioning',
      'en',
      'Air Conditioning',
      array['air conditioning', 'ac', 'air conditioner']::text[]
    ),
    (
      'Air Conditioning',
      'ar',
      'تكييف الهواء',
      array['تكييف', 'مكيف', 'مكيفات', 'إصلاح مكيفات']::text[]
    ),
    (
      'Painting',
      'en',
      'Painting',
      array['painting', 'paint', 'painter']::text[]
    ),
    (
      'Painting',
      'ar',
      'الدهان',
      array['دهان', 'طلاء', 'دهان منازل']::text[]
    ),
    (
      'Blacksmith',
      'en',
      'Blacksmith',
      array['blacksmith', 'metal work']::text[]
    ),
    (
      'Blacksmith',
      'ar',
      'الحدادة',
      array['حداد', 'حدادة', 'أعمال معدنية']::text[]
    ),
    (
      'Plumbing',
      'en',
      'Plumbing',
      array['plumbing', 'plumber', 'pipes']::text[]
    ),
    (
      'Plumbing',
      'ar',
      'السباكة',
      array['سباكة', 'سباك', 'تمديدات صحية', 'مواسير']::text[]
    ),
    (
      'Electrical',
      'en',
      'Electrical',
      array['electrical', 'electrician', 'electric']::text[]
    ),
    (
      'Electrical',
      'ar',
      'الكهرباء',
      array['كهرباء', 'كهربائي', 'تمديدات كهربائية']::text[]
    ),
    (
      'Carpentry',
      'en',
      'Carpentry',
      array['carpentry', 'carpenter', 'woodwork']::text[]
    ),
    (
      'Carpentry',
      'ar',
      'النجارة',
      array['نجارة', 'نجار', 'خشب', 'أعمال خشبية']::text[]
    )
) as seed(
  canonical_name,
  locale,
  translated_name,
  search_terms
)
  on c.name = seed.canonical_name
on conflict (category_id, locale)
do update set
  name = excluded.name,
  search_terms = excluded.search_terms,
  updated_at = now();
