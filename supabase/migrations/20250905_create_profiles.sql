-- profiles table for role and studio linkage
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role text not null check (role in ('admin','client')),
  studio_id uuid null references public.studios(id) on delete set null,
  created_at timestamptz default now()
);

-- simple RLS policies (adjust as needed for your environment)
alter table public.profiles enable row level security;

do $$ begin
  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'profiles' and policyname = 'Users can view own profile'
  ) then
    create policy "Users can view own profile" on public.profiles
      for select using (auth.uid() = id);
  end if;
end $$;

do $$ begin
  if not exists (
    select 1 from pg_policies where schemaname = 'public' and tablename = 'profiles' and policyname = 'Users can upsert own profile'
  ) then
    create policy "Users can upsert own profile" on public.profiles
      for all using (auth.uid() = id) with check (auth.uid() = id);
  end if;
end $$;


