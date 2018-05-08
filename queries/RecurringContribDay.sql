select 
  utm_campaign_33 as camp, date(create_date) as date, R.currency, pp.name, max(status.name) as status_contrib, M.status,
  frequency_unit as frequency, count(*) as nb, sum(amount) sum, avg(amount) avg 
from civicrm_contribution_recur  as R 
left join civicrm_payment_processor pp on payment_processor_id=pp.id
left join civicrm_option_value status on option_group_id=11 and contribution_status_id=status.value 
left join civicrm_sdd_mandate M on R.id=M.entity_id and M.entity_table="civicrm_contribution_recur" 
join  civicrm_contribution c on contribution_recur_id=R.id 
left join civicrm_value_utm_5 utm on c.id=utm.entity_id 
where R.is_test=0 and c.is_test=0
group by utm_campaign_33, date(create_date), R.contribution_status_id, pp.id, status, currency, frequency_unit
order by date desc; 
