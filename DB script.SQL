create table if not exists public.journal_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.journal_state enable row level security;

drop policy if exists "Users can read their own journal" on public.journal_state;
create policy "Users can read their own journal"
on public.journal_state
for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can insert their own journal" on public.journal_state;
create policy "Users can insert their own journal"
on public.journal_state
for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update their own journal" on public.journal_state;
create policy "Users can update their own journal"
on public.journal_state
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
grant select on public.journal_state to authenticated;
grant insert on public.journal_state to authenticated;
grant update on public.journal_state to authenticated;
