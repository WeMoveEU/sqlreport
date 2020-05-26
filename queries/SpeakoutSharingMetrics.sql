SELECT 
  subject AS campaign,
  utm_medium_38 AS medium,
  utm_content_40 AS variation,
  count(*) AS count
FROM civicrm_activity a join civicrm_value_share_params_6 p ON a.id=p.entity_id 
GROUP BY subject, utm_medium_38, utm_content_40;
