create extension if not exists pgcrypto;

create type public.app_role as enum ('user','moderator','admin','owner');

create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 email text unique not null,
 username text unique not null check (char_length(username) between 3 and 32),
 display_name text,
 bio text default '',
 interests text[] default '{}',
 city text,
 avatar_url text,
 verified boolean not null default false,
 banned boolean not null default false,
 role public.app_role not null default 'user',
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);

create table if not exists public.friend_requests (
 id uuid primary key default gen_random_uuid(),
 sender_id uuid not null references public.profiles(id) on delete cascade,
 receiver_id uuid not null references public.profiles(id) on delete cascade,
 status text not null default 'pending' check(status in ('pending','accepted','rejected')),
 created_at timestamptz not null default now(),
 unique(sender_id, receiver_id), check(sender_id <> receiver_id)
);

create table if not exists public.admin_logs (
 id bigint generated always as identity primary key,
 actor_id uuid references public.profiles(id) on delete set null,
 action text not null,
 target_id uuid,
 details jsonb default '{}'::jsonb,
 created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.friend_requests enable row level security;
alter table public.admin_logs enable row level security;

create policy "public profiles readable" on public.profiles for select using (not banned or auth.uid() = id);
create policy "users update own profile" on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id and role = (select role from public.profiles p where p.id=auth.uid()));
create policy "users insert own profile" on public.profiles for insert with check(auth.uid()=id);
create policy "requests participants" on public.friend_requests for select using(auth.uid()=sender_id or auth.uid()=receiver_id);
create policy "send request" on public.friend_requests for insert with check(auth.uid()=sender_id);
create policy "receiver update request" on public.friend_requests for update using(auth.uid()=receiver_id);
create policy "logs owner only" on public.admin_logs for select using((select role from public.profiles where id=auth.uid()) in ('admin','owner'));

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path=public as $$
begin
 insert into public.profiles(id,email,username,display_name,role)
 values(new.id,new.email,coalesce(new.raw_user_meta_data->>'username','user_'||substr(new.id::text,1,8)),new.raw_user_meta_data->>'display_name',case when lower(new.email)='sunqwix@gmail.com' then 'owner'::public.app_role else 'user'::public.app_role end)
 on conflict (id) do nothing;
 return new;
end; $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();
