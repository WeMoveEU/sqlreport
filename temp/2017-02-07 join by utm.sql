/* 
when signatures come from mailing
select subject,count(*) signatures, campaign_26 as campaign, source_27 as source, sum(case when a.status_id=9 and activity_type_id=32 then 1 end) as completed_new_member from civicrm_activity a join civicrm_value_action_source_4 utm on a.id=utm.entity_id where a.activity_type_id=32 and media_28="email" and source_27 like "civimail-%" group by source_27 order by source desc ;


set @share:= 54,
@signature:=32,
@created_pet:=55,
@leave:=56,
@join:=57,
@scheduled=1,
@completed=2,
@optout=4,
@completed_new=9,
@member_group=42,
@UK=1226;

*/
-- select * from civicrm_value_action_source_4 ;


select
  a.subject, utm.campaign_26, utm.source_27, utm.media_28,
  sum(case when activity_type_id=32 then 1 end) as total,
  sum(case when a.status_id=9 and activity_type_id=32 then 1 end) as completed_new_member,
  
  sum(case when activity_type_id=57 then 1 end) as member_join
from civicrm_activity a
left join civicrm_value_action_source_4 utm on utm.entity_id=a.id
where activity_type_id in (32,54,56,57) and is_test=0
-- and utm.source_27 in ("campact","KB")
group by a.subject, utm.campaign_26, utm.source_27, utm.media_28
order by completed_new_member desc;


ödlkfsdfk;

select * from civicrm_activity ;



select
  campaign_id, c.name, custom.language_4 as language, date(activity_date_time) as date, 
  sum(case when activity_type_id=32 then 1 end) as total,
  sum(case when a.status_id=9 and activity_type_id=32 then 1 end) as completed_new_member,
  sum(case when activity_type_id=57 then 1 end) as member_join
from civicrm_activity a join civicrm_campaign c on campaign_id=c.id
join civicrm_value_speakout_integration_2 custom on entity_id=c.id
where activity_type_id in (32,54,56,57) and is_test=0
group by campaign_id
order by total desc
-- Having count(*) >1
;

