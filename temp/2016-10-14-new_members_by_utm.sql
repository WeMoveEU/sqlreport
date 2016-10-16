select utm_media, sum(completed_new_member) as new_member
from 
(select
  c.name as campaign_name, c.id as campaign_id, custom.language_4 as language,
  campaign_26 as utm_campaign, source_27 as utm_source, media_28 as utm_media,
  sum(case when activity_type_id=32 then 1 end) as total,
  sum(case when a.status_id=2 and activity_type_id=32 then 1 end) as completed_existing_member,
  sum(case when a.status_id=1 and activity_type_id=32 then 1 end) as pending,
  sum(case when a.status_id=9 and activity_type_id=32 then 1 end) as completed_new_member,
  sum(case when a.status_id=4 and activity_type_id=32 then 1 end) as optout
from civicrm_activity a join civicrm_campaign c on campaign_id=c.id
join civicrm_value_speakout_integration_2 custom on entity_id=c.id
left join civicrm_value_action_source_4 utm on a.id=utm.entity_id
where activity_type_id in (32) and is_test=0
-- and campaign_id=%1
group by c.id,campaign_26,source_27,media_28
order by c.id desc, completed_new_member desc
) as signatures_activities
group by utm_media
order by new_member desc;

select utm_source, sum(completed_new_member) as new_member
from 
(select
  c.name as campaign_name, c.id as campaign_id, custom.language_4 as language,
  campaign_26 as utm_campaign, source_27 as utm_source, media_28 as utm_media,
  sum(case when activity_type_id=32 then 1 end) as total,
  sum(case when a.status_id=2 and activity_type_id=32 then 1 end) as completed_existing_member,
  sum(case when a.status_id=1 and activity_type_id=32 then 1 end) as pending,
  sum(case when a.status_id=9 and activity_type_id=32 then 1 end) as completed_new_member,
  sum(case when a.status_id=4 and activity_type_id=32 then 1 end) as optout
from civicrm_activity a join civicrm_campaign c on campaign_id=c.id
join civicrm_value_speakout_integration_2 custom on entity_id=c.id
left join civicrm_value_action_source_4 utm on a.id=utm.entity_id
where activity_type_id in (32) and is_test=0
-- and campaign_id=%1
group by c.id,campaign_26,source_27,media_28
order by c.id desc, completed_new_member desc
) as signatures_activities
group by utm_source
order by new_member desc;

select utm_campaign, sum(completed_new_member) as new_member
from 
(select
  c.name as campaign_name, c.id as campaign_id, custom.language_4 as language,
  campaign_26 as utm_campaign, source_27 as utm_source, media_28 as utm_media,
  sum(case when activity_type_id=32 then 1 end) as total,
  sum(case when a.status_id=2 and activity_type_id=32 then 1 end) as completed_existing_member,
  sum(case when a.status_id=1 and activity_type_id=32 then 1 end) as pending,
  sum(case when a.status_id=9 and activity_type_id=32 then 1 end) as completed_new_member,
  sum(case when a.status_id=4 and activity_type_id=32 then 1 end) as optout
from civicrm_activity a join civicrm_campaign c on campaign_id=c.id
join civicrm_value_speakout_integration_2 custom on entity_id=c.id
left join civicrm_value_action_source_4 utm on a.id=utm.entity_id
where activity_type_id in (32) and is_test=0
-- and campaign_id=%1
group by c.id,campaign_26,source_27,media_28
order by c.id desc, completed_new_member desc
) as signatures_activities
group by utm_campaign
order by new_member desc;




select 
campaign_name, campaign_id, sum(completed_new_member) as total_new,
campaign_id, sum(if(utm_media="facebook",completed_new_member,0)) as facebook_new,
sum(if(utm_media="email",completed_new_member,0)) as email_new,
sum(if(utm_media="mail",completed_new_member,0)) as mail_new,
sum(if(utm_media="post",completed_new_member,0)) as post_new,
sum(if(utm_media="whatsapp",completed_new_member,0)) as whatsapp_new
from

(select
  c.name as campaign_name, c.id as campaign_id, custom.language_4 as language,
  campaign_26 as utm_campaign, source_27 as utm_source, media_28 as utm_media,
  sum(case when activity_type_id=32 then 1 end) as total,
  sum(case when a.status_id=2 and activity_type_id=32 then 1 end) as completed_existing_member,
  sum(case when a.status_id=1 and activity_type_id=32 then 1 end) as pending,
  sum(case when a.status_id=9 and activity_type_id=32 then 1 end) as completed_new_member,
  sum(case when a.status_id=4 and activity_type_id=32 then 1 end) as optout
from civicrm_activity a join civicrm_campaign c on campaign_id=c.id
join civicrm_value_speakout_integration_2 custom on entity_id=c.id
left join civicrm_value_action_source_4 utm on a.id=utm.entity_id
where activity_type_id in (32) and is_test=0
-- and campaign_id=%1
group by c.id,campaign_26,source_27,media_28
order by c.id desc, completed_new_member desc
) as signatures_activities
group by campaign_id 
order by campaign_id desc

;
