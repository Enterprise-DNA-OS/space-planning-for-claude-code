create table buildings (
 id uuid primary key default gen_random_uuid(), name text not null check(length(trim(name))>0), region text not null default '', tenure text not null default 'unknown' check(tenure in ('leased','owned','unknown')), visible boolean not null default true,
 owner text not null default '', emergency_ref text not null default '', review_due date, source_key text unique,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create unique index building_name on buildings(lower(name));
create table floors (
 id uuid primary key default gen_random_uuid(), building_id uuid not null references buildings, name text not null, capacity integer not null check(capacity>=0), area_sqm numeric(12,2) check(area_sqm>=0), capacity_ref text not null default '',
 created_at timestamptz not null default now(), updated_at timestamptz not null default now(), unique(building_id,name)
);
create table departments (
 id uuid primary key default gen_random_uuid(), name text not null, headcount integer not null check(headcount>=0), peak_pct integer not null default 100 check(peak_pct between 1 and 100), owner text not null,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create unique index department_name on departments(lower(name));
create table plans (
 id uuid primary key default gen_random_uuid(), name text not null, status text not null default 'draft' check(status in ('draft','approved','active','archived')), owner text not null, due date not null, rationale text not null default '', approved_by text, approval_ref text, approval_hash text, approved_at timestamptz,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create unique index plan_name on plans(lower(name));
create unique index one_active_plan on plans(status) where status='active';
create table allocations (
 id uuid primary key default gen_random_uuid(), plan_id uuid not null references plans, floor_id uuid not null references floors, department_id uuid not null references departments,
 people integer not null check(people>=0), seats integer not null check(seats>=0),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now(), unique(plan_id,floor_id,department_id)
);
create table observations (
 id uuid primary key default gen_random_uuid(), floor_id uuid not null references floors, observed_on date not null, present integer not null check(present>=0), method text not null, evidence text not null,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now(), unique(floor_id,observed_on,method)
);
create table move_tasks (
 id uuid primary key default gen_random_uuid(), plan_id uuid not null references plans, name text not null, owner text not null, due date not null, blocking boolean not null default true, status text not null default 'open' check(status in ('open','done')), evidence text,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table notes (
 id uuid primary key default gen_random_uuid(), plan_id uuid not null references plans, actor text not null, body text not null,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table import_batches (
 id uuid primary key default gen_random_uuid(), file_name text not null, digest text not null unique, original_csv text not null, actor text not null,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table source_records (
 id uuid primary key default gen_random_uuid(), batch_id uuid not null references import_batches, building_id uuid not null references buildings, source_key text not null unique, original_row jsonb not null,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table audit_events (
 id uuid primary key default gen_random_uuid(), actor text not null, action text not null, details jsonb not null,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create function touch_updated_at() returns trigger language plpgsql as $$ begin new.updated_at=now(); return new; end $$;
do $$ declare t text; begin foreach t in array array['buildings','floors','departments','plans','allocations','observations','move_tasks','notes','import_batches','source_records','audit_events'] loop
 execute format('create trigger touch_updated_at before update on %I for each row execute function touch_updated_at()',t);
 execute format('alter table %I enable row level security',t);
 execute format('revoke all on %I from public',t);
end loop; end $$;
create index allocations_plan on allocations(plan_id);
create index observations_floor_date on observations(floor_id,observed_on);
create index move_tasks_plan on move_tasks(plan_id);
create view floor_load as
 select p.id plan_id,p.name plan,p.status,b.id building_id,b.name building,f.id floor_id,f.name floor,f.capacity,
 coalesce(sum(a.people),0)::int people,coalesce(sum(a.seats),0)::int seats,
 (f.capacity-coalesce(sum(a.seats),0))::int spare_seats,
 coalesce(sum(ceil(a.people*d.peak_pct/100.0)),0)::int required_seats
 from plans p cross join floors f join buildings b on b.id=f.building_id
 left join allocations a on a.plan_id=p.id and a.floor_id=f.id left join departments d on d.id=a.department_id
 group by p.id,p.name,p.status,b.id,b.name,f.id,f.name,f.capacity;
create view occupancy_review as
 select b.name building,f.id floor_id,f.name floor,f.capacity,count(o.id)::int samples,max(o.observed_on) latest_observation,
 round(avg(o.present),1) average_present,max(o.present) peak_present,
 case when f.capacity>0 then round(avg(o.present)*100/f.capacity,1) end average_capacity_pct
 from floors f join buildings b on b.id=f.building_id left join observations o on o.floor_id=f.id and o.observed_on>=current_date-30
 group by b.name,f.id,f.name,f.capacity;
create view space_exceptions as
 select p.id plan_id,p.name plan,'CAPACITY' rule,b.name||' / '||f.name subject,'Allocated seats exceed recorded capacity' issue
 from floor_load l join plans p on p.id=l.plan_id join floors f on f.id=l.floor_id join buildings b on b.id=f.building_id where l.spare_seats<0
 union all
 select p.id,p.name,'PEAK-COVERAGE',d.name,'Assigned seats below the recorded peak attendance assumption'
 from allocations a join departments d on d.id=a.department_id join plans p on p.id=a.plan_id where a.seats<ceil(a.people*d.peak_pct/100.0)
 union all
 select p.id,p.name,'HEADCOUNT',d.name,'Assigned people do not equal department headcount'
 from plans p cross join departments d left join allocations a on a.plan_id=p.id and a.department_id=d.id group by p.id,p.name,d.id,d.name,d.headcount having coalesce(sum(a.people),0)<>d.headcount
 union all
 select distinct p.id,p.name,'EMERGENCY-PLAN',b.name,'Emergency reference or current internal review date missing'
 from plans p join allocations a on a.plan_id=p.id join floors f on f.id=a.floor_id join buildings b on b.id=f.building_id where b.emergency_ref='' or b.review_due is null or b.review_due<current_date
 union all
 select distinct p.id,p.name,'CAPACITY-EVIDENCE',b.name||' / '||f.name,'Capacity evidence reference missing'
 from plans p join allocations a on a.plan_id=p.id join floors f on f.id=a.floor_id join buildings b on b.id=f.building_id where f.capacity_ref=''
 union all
 select p.id,p.name,'MOVE-TASK',t.name,'Blocking move task remains open' from plans p join move_tasks t on t.plan_id=p.id where t.blocking and t.status='open';
revoke all on floor_load,occupancy_review,space_exceptions from public;
