select c.id as contact_id, civicrm_country.iso_code as country
,label as instrument, payment_instrument_id as instrument_id
/* ,financial_type_id, t.name as financial_type */
, total_amount as amount, currency
, receive_date as date
, 
  case when datediff(receive_date,c.created_date)>1 then datediff(receive_date,c.created_date)
  else 0
  end as created_age
  
, cont.source, contribution_status_id as status_id
, utm_source_30 as utm_source, utm_medium_31 as utm_medium
,utm_campaign_33 as utm_campaign, campaign_id 
from civicrm_contribution cont 
join civicrm_option_value on option_group_id=10 and value=payment_instrument_id 
/* join civicrm_financial_type t on t.id=financial_type_id */
join civicrm_contact c on c.id=contact_id left join civicrm_value_utm_5 on entity_id=cont.id 
left join civicrm_address a on a.contact_id=c.id and a.is_primary=1 
join civicrm_country on a.country_id=civicrm_country.id 
where financial_type_id=1 and payment_instrument_id !=7 and cont.is_test=0
order by receive_date desc;
