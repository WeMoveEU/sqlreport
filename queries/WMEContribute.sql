select c.id as contact_id, first_name, civicrm_country.iso_code as country
, payment_instrument_id as instrument_id
, IF(cont.contribution_recur_id is NULL, 0, 1) as recurring
, total_amount as amount, currency
, IF (sepa.creation_date is not NULL,sepa.creation_date,receive_date)  as date
, 
  case when datediff(receive_date,c.created_date)>1 then datediff(receive_date,c.created_date)
  else 0
  end as created_age
  
, cont.source, contribution_status_id as status_id
, utm_source_30 as utm_source, utm_medium_31 as utm_medium
,utm_campaign_33 as utm_campaign, cont.campaign_id 
,contribution_recur_id
from civicrm_contribution cont 
/*join civicrm_option_value on option_group_id=10 and value=payment_instrument_id */
join civicrm_contact c on c.id=contact_id left join civicrm_value_utm_5 on entity_id=cont.id 
left join civicrm_address a on a.contact_id=c.id and a.is_primary=1 
join civicrm_country on a.country_id=civicrm_country.id
left join civicrm_sdd_mandate sepa on cont.id=sepa.entity_id and sepa.entity_table="civicrm_contribution" 
where financial_type_id=1 and payment_instrument_id !=7 and cont.is_test=0 and receive_date >= (CURDATE() - INTERVAL 1 MONTH )
order by receive_date desc;
