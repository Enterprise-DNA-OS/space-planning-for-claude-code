insert into buildings(id,name,region,tenure,owner,emergency_ref,review_due) values
 ('10000000-0000-4000-8000-000000000001','Harbour Office','Auckland','leased','Mara Lee','demo/emergency-harbour',current_date+90),
 ('10000000-0000-4000-8000-000000000002','Hill Office','Wellington','owned','Tane West','',current_date-10) on conflict do nothing;
insert into floors(id,building_id,name,capacity,area_sqm,capacity_ref) values
 ('20000000-0000-4000-8000-000000000001','10000000-0000-4000-8000-000000000001','Harbour Level 1',24,240,'demo/layout-review-1'),
 ('20000000-0000-4000-8000-000000000002','10000000-0000-4000-8000-000000000001','Harbour Level 2',20,200,'demo/layout-review-2'),
 ('20000000-0000-4000-8000-000000000003','10000000-0000-4000-8000-000000000002','Hill Ground',12,130,'') on conflict do nothing;
insert into departments(id,name,headcount,peak_pct,owner) values
 ('30000000-0000-4000-8000-000000000001','Advisory',20,80,'Riley Shaw'),
 ('30000000-0000-4000-8000-000000000002','Operations',10,100,'Ari Bell'),
 ('30000000-0000-4000-8000-000000000003','Research',8,75,'Jo Park') on conflict do nothing;
insert into plans(id,name,status,owner,due,rationale) values
 ('40000000-0000-4000-8000-000000000001','Current footprint','active','Mara Lee',current_date+30,'Fictional baseline for scenario comparison'),
 ('40000000-0000-4000-8000-000000000002','Harbour consolidation','draft','Mara Lee',current_date-3,'Test a move from Hill to Harbour') on conflict do nothing;
insert into allocations(id,plan_id,floor_id,department_id,people,seats) values
 ('50000000-0000-4000-8000-000000000001','40000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000001','30000000-0000-4000-8000-000000000001',20,20),
 ('50000000-0000-4000-8000-000000000002','40000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000002','30000000-0000-4000-8000-000000000002',10,12),
 ('50000000-0000-4000-8000-000000000003','40000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000003','30000000-0000-4000-8000-000000000003',8,8),
 ('50000000-0000-4000-8000-000000000004','40000000-0000-4000-8000-000000000002','20000000-0000-4000-8000-000000000001','30000000-0000-4000-8000-000000000001',20,20),
 ('50000000-0000-4000-8000-000000000005','40000000-0000-4000-8000-000000000002','20000000-0000-4000-8000-000000000001','30000000-0000-4000-8000-000000000002',10,10),
 ('50000000-0000-4000-8000-000000000006','40000000-0000-4000-8000-000000000002','20000000-0000-4000-8000-000000000002','30000000-0000-4000-8000-000000000003',8,4) on conflict do nothing;
insert into observations(id,floor_id,observed_on,present,method,evidence) values
 ('60000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000001',current_date-2,14,'manual count','demo/count-1'),
 ('60000000-0000-4000-8000-000000000002','20000000-0000-4000-8000-000000000001',current_date-7,18,'manual count','demo/count-2'),
 ('60000000-0000-4000-8000-000000000003','20000000-0000-4000-8000-000000000002',current_date-2,5,'manual count','demo/count-3'),
 ('60000000-0000-4000-8000-000000000004','20000000-0000-4000-8000-000000000003',current_date-45,4,'manual count','demo/count-old') on conflict do nothing;
insert into move_tasks(id,plan_id,name,owner,due) values
 ('70000000-0000-4000-8000-000000000001','40000000-0000-4000-8000-000000000002','Check accessible circulation','Tane West',current_date-2),
 ('70000000-0000-4000-8000-000000000002','40000000-0000-4000-8000-000000000002','Confirm workstation layout','Mara Lee',current_date+3) on conflict do nothing;
insert into notes(id,plan_id,actor,body,created_at) values
 ('80000000-0000-4000-8000-000000000001','40000000-0000-4000-8000-000000000002','Mara Lee','Awaiting floor review and team attendance assumptions',now()-interval '21 days') on conflict do nothing;
