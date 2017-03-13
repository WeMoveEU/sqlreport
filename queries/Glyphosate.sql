select 
IF (LOCATE("-01-eci-stop-glyphosate",c.name) > 0,
LOWER(REPLACE (c.name,"2017-01-eci-stop-glyphosate-","gly_wemove_"))
,LOWER(REPLACE (c.name,"-","_"))) as name
,   sum(case when activity_type_id=32 then 1 end) as total
,  sum(case when a.status_id=9 and activity_type_id=32 then 1 end) as completed_new
,  sum(case when a.status_id=1 and activity_type_id=32 then 1 end) as pending
,  sum(case when a.status_id=4 and activity_type_id=32 then 1 end) as optout
,  sum(case when a.status_id=2 and activity_type_id=32 then 1 end) as completed_existing_member
,  sum(case when activity_type_id=54 then 1 end) as share
,  sum(case when activity_type_id=56 then 1 end) as member_leave 
, c.id campaign_id, external_identifier as speakout_id,language_4 as lang ,url_campaign_8 as url, c.parent_id, campaign_type_id as type
from civicrm_activity a join civicrm_campaign c on campaign_id=c.id 
join civicrm_value_speakout_integration_2 custom on entity_id=c.id left 
join civicrm_value_action_source_4 utm on a.id=utm.entity_id 
where activity_type_id in (32,54,56) and is_test=0
and (c.campaign_type_id in (9,10)
or c.parent_id in (348) )  
group by c.id order by completed_new desc
