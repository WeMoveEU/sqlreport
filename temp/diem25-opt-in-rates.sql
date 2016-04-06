select diem_data.subject, 
sum(if(diem_data.status = 1,diem_data.count,0)) as scheduled,
sum(if(diem_data.status = 2,diem_data.count,0)) as completed,
sum(if(diem_data.status = 4,diem_data.count,0)) as optout,
sum(if(diem_data.status = 9,diem_data.count,0)) as completed_new

from
(
select activity.status_id as status, activity.subject as subject, count(*) as count
from 
civicrm_activity activity where activity.activity_type_id=32 and activity.subject like "%diem%"
group by status, subject) as diem_data
group by diem_data.subject
;


select activity.status_id as status, activity.subject as subject, count(*) as count
from 
civicrm_activity activity where activity.activity_type_id=32 and activity.subject like "%diem%"
group by status, subject;
