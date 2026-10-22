-- Zeroed allocations remain in history but do not occupy a floor.
create or replace view space_exceptions as
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
 from plans p join allocations a on a.plan_id=p.id join floors f on f.id=a.floor_id join buildings b on b.id=f.building_id where (a.people>0 or a.seats>0) and (b.emergency_ref='' or b.review_due is null or b.review_due<current_date)
 union all
 select distinct p.id,p.name,'CAPACITY-EVIDENCE',b.name||' / '||f.name,'Capacity evidence reference missing'
 from plans p join allocations a on a.plan_id=p.id join floors f on f.id=a.floor_id join buildings b on b.id=f.building_id where (a.people>0 or a.seats>0) and f.capacity_ref=''
 union all
 select p.id,p.name,'MOVE-TASK',t.name,'Blocking move task remains open' from plans p join move_tasks t on t.plan_id=p.id where t.blocking and t.status='open';
revoke all on floor_load,occupancy_review,space_exceptions from public;
