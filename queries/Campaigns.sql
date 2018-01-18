select 
  c.id, c.parent_id,
  c.title as name,
  c.external_identifier,
  created_date as date,
  url_campaign_8 as url,
  campaign_type_id as type_id,
  utm_campaign_11 as utm_campaign,
  (select sum(npeople) from speakeasy_petition_metrics m where m.activity="gunique_recipient" and m.parent_id=c.id group by parent_id) unique_recipient,
  (select sum(npeople) from speakeasy_petition_metrics m where m.activity="recipient" and m.parent_id=c.id group by parent_id) recipient,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="oneoff_count" and m.parent_id=c.id group by parent_id) oneoff_donation,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="oneoff_amount" and m.parent_id=c.id group by parent_id) oneoff_donation_amount,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="recurring_count" and m.parent_id=c.id group by parent_id) recurring_donation,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="recurring_amount" and m.parent_id=c.id group by parent_id) recurring_donation_amount,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="unique_opened" and m.parent_id=c.id group by parent_id) open,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="unique_clicks" and m.parent_id=c.id group by parent_id) click,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="click_1" and m.parent_id=c.id group by parent_id) click_1,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="click_42" and m.parent_id=c.id group by parent_id) click_42,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="share" and m.parent_id=c.id group by parent_id) share,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="effective_share" and m.parent_id=c.id group by parent_id) effective_share,
  (select sum(npeople) from speakeasy_petition_metrics m where m.activity="petition" and m.parent_id=c.id group by parent_id) signature,
  (select sum(abs(npeople)) from speakeasy_petition_metrics m where m.activity="petition" and status in ('1','4','5','9') and m.parent_id=c.id group by parent_id) new_signature,
  (select sum(abs(npeople)) from speakeasy_petition_metrics m where m.activity="petition" and status='9' and m.parent_id=c.id group by parent_id) new_member,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="new_member_mail" and m.parent_id=c.id group by parent_id) new_member_mail,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="new_member_share" and m.parent_id=c.id group by parent_id) new_member_share,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="new_now_recurdonors" and m.parent_id=c.id group by parent_id) new_member_now_recur_donors,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="new_active_3mlater" and m.parent_id=c.id group by parent_id) new_member_active_3months_later,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="new_active_now" and m.parent_id=c.id group by parent_id) new_member_active_now,
  (select sum(npeople) from speakeasy_petition_metrics m where m.activity="petition" and status='10' and m.parent_id=c.id group by parent_id) activated,
  (select sum(npeople) from speakeasy_petition_metrics m where activity="unsub" and m.parent_id=c.id group by parent_id) unsubscribed,
  (select min(last_updated) from speakeasy_petition_metrics m where m.parent_id=c.id group by parent_id) oldest_data

/*left join speakeasy_petition_metrics new on new.activity="petition" and new.status='9' and new.parent_id=c.id
 left join speakeasy_petition_metrics activated on activated.activity="petition" and activated.status='10' and activated.parent_id=c.id*/
from civicrm_campaign c
join civicrm_value_speakout_integration_2 custom on entity_id=c.id

where (c.parent_id=c.id or c.parent_id is null) and (status_id!=5 or status_id is null);
