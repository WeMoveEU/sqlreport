select mailing.name as mailing,
  count(infected.entity_id) as infected_signs_and_shares,
  count(inf_a.id) as infected_signs 
from civicrm_value_action_source_4 source 
join civicrm_mailing mailing on mailing.id=right(source.source_27, 4)
join civicrm_activity a on a.id=source.entity_id 
join civicrm_value_share_params_6 share on share.entity_id=a.id 
join civicrm_value_action_source_4 infected on infected.campaign_26=share.utm_campaign_39 
left join civicrm_activity inf_a on inf_a.id=infected.entity_id and inf_a.activity_type_id=32 
where source.source_27 like 'civimail-%' 
group by source.source_27;
