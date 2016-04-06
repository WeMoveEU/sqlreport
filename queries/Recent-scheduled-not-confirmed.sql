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

-- aka "optin"


/* 
civicrm_activity

activity_date_time
status_id
activity_tpye_id
subject

*/
SELECT 
    COUNT(*) AS count, contact.preferred_language AS language
FROM
    civicrm_contact contact
        JOIN
    civicrm_activity_contact ac ON contact.id = ac.contact_id
        JOIN
    civicrm_activity activity ON activity.id = ac.activity_id
        AND activity.activity_type_id = @signature
        AND activity.status_id = @scheduled
        and activity.activity_date_time > date_add(now(), interval -14 day)
        JOIN
    civicrm_group_contact cgroup ON cgroup.contact_id = contact.id
--        AND cgroup.group_id = @member_group
--       AND cgroup.status = 'Pending'
-- 'Added'
GROUP BY language
ORDER BY count DESC
;
