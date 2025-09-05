-- create studios table for onboarding join codes
create table if not exists public.studios (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  join_code text not null,
  created_at timestamptz default now()
);

create unique index if not exists studios_join_code_idx on public.studios (lower(join_code));

-- create studios table for onboarding join codes
create table if not exists public.studios (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  join_code text not null,
  created_at timestamptz default now()
);

create unique index if not exists studios_join_code_idx on public.studios (lower(join_code));


