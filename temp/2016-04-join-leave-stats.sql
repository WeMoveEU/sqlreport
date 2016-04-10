set @share:= 54;
set @signature:=32;
set @created_pet:=55;
set @leave:=56;
set @join:=57;

set @scheduled=1;
set @completed=2;
set @optout=4;
set @completed_new=9; 
set @member_group=42;

select count(*) as_number_of_leaves,  subject, date(activity_date_time)
from civicrm_activity activity
where activity.activity_type_id=@leave
group by date(activity_date_time), subject
;

select count(*) as number_of_joins,  subject, date(activity_date_time)
from civicrm_activity activity
where activity.activity_type_id=@join
group by date(activity_date_time),  subject
;

SELECT 
    SUM(IF(activity_type_id = @join, 1, 0)),
    SUM(IF(activity_type_id = @leave, 1, 0)),
    SUM(IF(activity_type_id = @join, 1, - 1))
FROM
    civicrm_activity activity
WHERE
    activity.activity_type_id IN (@join , @leave)
;


select count(*) as_number_of_leaves,  subject, campaign_id
from civicrm_activity activity
where activity.activity_type_id=@leave
group by campaign_id, subject
;

select count(*) as number_of_joins,  subject, campaign_id
from civicrm_activity activity
where activity.activity_type_id=@join
group by campaign_id,  subject
;

select count(*), activity_type_id, subject
from civicrm_activity activity
where activity.activity_type_id in (@signature, @share, @join, @leave)
group by subject
