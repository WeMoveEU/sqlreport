-- update signatures
UPDATE civicrm_value_share_params_6 shup
  JOIN (SELECT
    sh.entity_id, count(a.id) counter
  FROM
    civicrm_value_action_source_4 ac
    JOIN civicrm_value_share_params_6 sh ON ac.media_28 = sh.utm_medium_38 AND ac.campaign_26 = sh.utm_campaign_39
    JOIN civicrm_activity a ON a.id = ac.entity_id
  WHERE a.activity_type_id = 32
  GROUP BY sh.entity_id, ac.campaign_26) r ON r.entity_id = shup.entity_id
SET shup.signatures_46 = r.counter;

-- update shares
UPDATE civicrm_value_share_params_6 shup
  JOIN (SELECT
    sh.entity_id, count(a.id) counter
  FROM
    civicrm_value_action_source_4 ac
    JOIN civicrm_value_share_params_6 sh ON ac.media_28 = sh.utm_medium_38 AND ac.campaign_26 = sh.utm_campaign_39
    JOIN civicrm_activity a ON a.id = ac.entity_id
  WHERE a.activity_type_id = 54
  GROUP BY sh.entity_id, ac.campaign_26) r ON r.entity_id = shup.entity_id
SET shup.shares_47 = r.counter;

-- update new members
UPDATE civicrm_value_share_params_6 shup
  JOIN (SELECT
    sh.entity_id, count(a.id) counter
  FROM
    civicrm_value_action_source_4 ac
    JOIN civicrm_value_share_params_6 sh ON ac.media_28 = sh.utm_medium_38 AND ac.campaign_26 = sh.utm_campaign_39
    JOIN civicrm_activity a ON a.id = ac.entity_id
  WHERE a.activity_type_id = 32 AND a.status_id = 9
  GROUP BY sh.entity_id) r ON r.entity_id = shup.entity_id
SET shup.new_members_48 = r.counter;
