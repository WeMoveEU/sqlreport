select 
  c.id, c.parent_id,
  c.title as name, language_4 as lang,
  c.external_identifier,
  created_date as date,
  url_campaign_8 as url,
  campaign_type_id as type_id,
  utm_campaign_11 as utm_campaign
from civicrm_campaign c
join civicrm_value_speakout_integration_2 custom on entity_id=c.id
where parent_id=c.id or parent_id is null and status_id!=5;
