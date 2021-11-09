SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

INSERT INTO tmp_petition_metrics (campaign_id, activity, status, npeople)
  SELECT
    camp.id,
    act_type.name,
    a.status_id,
    COUNT(*)
  FROM civicrm_campaign camp
  JOIN civicrm_activity a ON a.campaign_id = camp.id
  JOIN civicrm_option_group og ON og.name = 'activity_type'
  JOIN civicrm_option_value act_type ON act_type.option_group_id = og.id AND act_type.value = a.activity_type_id
  WHERE act_type.name IN ('Petition', 'share')
  GROUP BY camp.id, act_type.name, a.status_id
;
