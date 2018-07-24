select c.id as contact_id
, first_name 
, right(c.preferred_language,2) lang
, cont.payment_instrument_id as instrument_id
, IF(cont.contribution_recur_id is NULL, 0, 1) as is_recurring
, CASE
    WHEN cont.receive_date=r.create_date THEN "first_recur"
    WHEN cont.payment_instrument_id = 6 THEN "first_recur"
    WHEN cont.payment_instrument_id = 7 THEN "recur"
    WHEN cont.payment_instrument_id not in (6,7) AND cont.contribution_recur_id is NOT NULL THEN "recur"
    ELSE "one_off"
END as recurring
, total_amount as amount, cont.currency
, CASE 
    WHEN sepa.creation_date is not NULL THEN sepa.creation_date
    WHEN sepa_recur.creation_date is not NULL and cont.payment_instrument_id = 6 THEN sepa_recur.creation_date
    ELSE receive_date
END as date
, IF(datediff(receive_date,c.created_date)>1,datediff(receive_date,c.created_date),0) as created_age
, cont.source, cont.contribution_status_id as status_id
, utm_source_30 as utm_source, utm_medium_31 as utm_medium
,utm_campaign_33 as utm_campaign, cont.campaign_id 
,contribution_recur_id
from civicrm_contribution cont 
join civicrm_contact c on c.id=contact_id left join civicrm_value_utm_5 on entity_id=cont.id 
left join civicrm_contribution_recur r on cont.contribution_recur_id = r.id
left join civicrm_sdd_mandate sepa on cont.id=sepa.entity_id and sepa.entity_table="civicrm_contribution" 
left join civicrm_sdd_mandate sepa_recur on r.id is not null and r.id=sepa_recur.entity_id and sepa_recur.entity_table="civicrm_contribution_recur" 
where cont.financial_type_id=1 and cont.is_test=0 and receive_date >= (CURDATE() - INTERVAL 1 MONTH )
order by receive_date desc;
