-- new people by campaign and source_media_etc.

-- new_member, new_uk_member, new_it_member, new_fr_member: share e-mail
-- mail_share = 

select 
campaign_name, campaign_id, sum(completed_new_member) as total_new,
sum(if(isnull(utm_source),completed_new_member,0)) as no_tracking_code,
sum(if(utm_source="member" and utm_media="facebook", completed_new_member,0)) as members_via_facebook,
sum(if(utm_source="member" and utm_media="twitter", completed_new_member,0)) as members_via_twitter,
sum(if(utm_source="member" and utm_media="whatsapp", completed_new_member,0)) as members_via_whatsapp,
sum(if(utm_source="member" and utm_media="sms", completed_new_member,0)) as members_via_sms,
sum(if((utm_media="email" or utm_media="mail") and utm_source != "mail_share",completed_new_member,0)) as forwarding_link_from_mailing,
sum(if(utm_media="post" and utm_source="facebook",completed_new_member,0)) as our_facebook_posts,
sum(if(utm_source="mail_share",completed_new_member,0)) as post_action_email_mailshare,
sum(if(utm_source like "new%member" and utm_media="facebook", completed_new_member,0)) as post_action_email_members_via_facebook,
sum(if(utm_source like "new%member" and utm_media="twitter", completed_new_member,0)) as post_action_email_members_via_twitter,
sum(if(utm_source like "new%member" and utm_media="whatsapp", completed_new_member,0)) as post_action_email_members_via_whatsapp,
sum(if(utm_source like "new%member" and utm_media="sms", completed_new_member,0)) as post_action_email_members_via_sms,
sum(completed_new_member)-
sum(if(isnull(utm_source),completed_new_member,0)) -
sum(if(utm_source="member" and utm_media="facebook", completed_new_member,0))-
sum(if(utm_source="member" and utm_media="twitter", completed_new_member,0)) -
sum(if(utm_source="member" and utm_media="whatsapp", completed_new_member,0)) -
sum(if(utm_source="member" and utm_media="sms", completed_new_member,0)) -
sum(if((utm_media="email" or utm_media="mail") and utm_source != "mail_share",completed_new_member,0)) -
sum(if(utm_media="post" and utm_source="facebook",completed_new_member,0)) - 
sum(if(utm_source="mail_share",completed_new_member,0)) -
sum(if(utm_source like "new%member" and utm_media="facebook", completed_new_member,0)) -
sum(if(utm_source like "new%member" and utm_media="twitter", completed_new_member,0)) -
sum(if(utm_source like "new%member" and utm_media="whatsapp", completed_new_member,0)) -
sum(if(utm_source like "new%member" and utm_media="sms", completed_new_member,0)) as rest
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
and activity_date_time > "2016-09-01"
-- and campaign_id=%1
group by c.id,campaign_26,source_27,media_28
order by c.id desc, completed_new_member desc
) as signatures_activities
group by campaign_id 
order by campaign_id desc

;

dlfkjdf;



-- huge table with everything -- 

select
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
and activity_date_time > "2016-09-01"
-- and campaign_id=%1
group by c.id,campaign_26,source_27,media_28
order by c.id desc, completed_new_member desc
;

select utm_source, utm_media, sum(completed_new_member) as new_member
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
and activity_date_time > "2016-09-01"
-- and campaign_id=%1
group by c.id,campaign_26,source_27,media_28
order by c.id desc, completed_new_member desc
) as signatures_activities
where utm_source="member"
group by utm_media
order by new_member desc;




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
and activity_date_time > "2016-09-01"
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
and activity_date_time > "2016-09-01"
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
and activity_date_time > "2016-09-01"
-- and campaign_id=%1
group by c.id,campaign_26,source_27,media_28
order by c.id desc, completed_new_member desc
) as signatures_activities
group by utm_campaign
order by new_member desc;




select 
campaign_name, campaign_id, sum(completed_new_member) as total_new,
sum(if(utm_media="facebook",completed_new_member,0)) as facebook_new,
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
and activity_date_time > "2016-09-01"
-- and campaign_id=%1
group by c.id,campaign_26,source_27,media_28
order by c.id desc, completed_new_member desc
) as signatures_activities
group by campaign_id 
order by campaign_id desc

;
