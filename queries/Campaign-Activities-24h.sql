select 
  campaign_id, c.name, custom.language_4 as language, date(activity_date_time) as date, count(*) as total_signatures, 
  sum(case when a.status_id=2 and activity_type_id=32 then 1 end) as completed_existing_member,  
  sum(case when a.status_id=1 and activity_type_id=32 then 1 end) as pending,
  sum(case when a.status_id=9 and activity_type_id=32 then 1 end) as completed_new_member,  
  sum(case when a.status_id=4 and activity_type_id=32 then 1 end) as optout,
  sum(case when activity_type_id=54 then 1 end) as share,
  sum(case when activity_type_id=57 then 1 end) as member_join,
  sum(case when activity_type_id=56 then 1 end) as member_leave 
from civicrm_activity a join civicrm_campaign c on campaign_id=c.id 
join civicrm_value_speakout_integration_2 custom on entity_id=c.id 
where activity_type_id in (32,54,56,57) and is_test=0
  and activity_date_time > DATE_ADD(now(), INTERVAL - 24 hour)
group by campaign_id
order by language, total_signatures desc

-- Having count(*) >1
-- DATE_ADD(now(), INTERVAL - 24 hour);