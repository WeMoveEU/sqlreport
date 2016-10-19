-- new people by campaign and source_media_etc.

-- new_member, new_uk_member, new_it_member, new_fr_member: share e-mail
-- mail_share = 

select
  c.name as campaign_name, convert(c.external_identifier, signed ) as speakout_id, custom.language_4 as language,
  campaign_26 as utm_campaign
-- , source_27 as utm_source, media_28 as utm_media,
  ,
  sum(case when activity_type_id=32 then 1 end) as total_signatures,
--  sum(case when a.status_id=2 and activity_type_id=32 then 1 end) as signatures_existing_member,
--  sum(case when a.status_id=1 and activity_type_id=32 then 1 end) as pending_confirmation,
  sum(case when a.status_id=9 and activity_type_id=32 then 1 end) as new_member
--  sum(case when a.status_id=4 and activity_type_id=32 then 1 end) as confirmation_optout
from civicrm_activity a join civicrm_campaign c on campaign_id=c.id
join civicrm_value_speakout_integration_2 custom on entity_id=c.id
left join civicrm_value_action_source_4 utm on a.id=utm.entity_id
where activity_type_id in (32) and is_test=0
and activity_date_time > "2016-06-01"
and (media_28="post" or media_28="ad") and source_27="facebook"
-- and campaign_id=%1
group by campaign_id,campaign_26,source_27,media_28
order by speakout_id desc, new_member desc;

