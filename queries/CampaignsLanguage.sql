select 
  c.id, c.parent_id,
  c.title as name, language_4 as lang,
  c.external_identifier,
  created_date as date,
  url_campaign_8 as url,
  campaign_type_id as type_id,
  utm_campaign_11 as utm_campaign,
  (select sum(npeople) from speakeasy_petition_metrics m where m.activity="unique_recipient" and m.campaign_id=c.id group by c.id) unique_recipient,
  (select sum(npeople) from speakeasy_petition_metrics m where m.activity="recipient" and m.campaign_id=c.id group by c.id) recipient,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="donation" and m.campaign_id=c.id group by c.id) donation,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="donation_amount" and m.campaign_id=c.id group by c.id) donation_amount,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="share" and m.campaign_id=c.id group by c.id) share,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="effective_share" and m.campaign_id=c.id group by c.id) effective_share,
  (select sum(npeople) from speakeasy_petition_metrics m where m.activity="Petition" and m.campaign_id=c.id group by c.id) signature,
  (select sum(npeople) from speakeasy_petition_metrics m where m.activity="Petition" and status='9' and m.campaign_id=c.id group by c.id) new,
  (select sum(npeople) from speakeasy_petition_metrics m where m.activity="Petition" and status='10' and m.campaign_id=c.id group by c.id) activated

/*left join speakeasy_petition_metrics new on new.activity="Petition" and new.status='9' and new.c.id=c.id
 left join speakeasy_petition_metrics activated on activated.activity="Petition" and activated.status='10' and activated.c.id=c.id*/
from civicrm_campaign c
join civicrm_value_speakout_integration_2 custom on entity_id=c.id

where (status_id!=5 or status_id is null)
order by campaign_type_id, parent_id desc, language_4
;
