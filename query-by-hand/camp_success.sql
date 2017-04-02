SELECT
  camp.id, camp.name, camp.parent_id, campx.language_4 AS language, mails.recipients,
  SUM(acts.activity_type_id=32) AS signs, SUM(acts.activity_type_id=54) AS shares, COUNT(useful_shares.infected_id) AS useful_shares,
  SUM(acts.status_id=9) AS growth,
  SUM(source_27 LIKE 'civimail-%') AS civimail_growth,  # Fwded emails, copied URL
  SUM(source_27 LIKE '%member%' OR source_27 LIKE 'share%' OR source_27='mail_share') AS member_growth  # Speakout share, share kicker, post-action mail
FROM civicrm_campaign camp
JOIN civicrm_value_speakout_integration_2 campx ON campx.entity_id=camp.id
JOIN (
    SELECT m.campaign_id AS camp_id, COUNT(r.id) AS recipients
    FROM civicrm_mailing m JOIN civicrm_mailing_recipients r ON r.mailing_id=m.id
    GROUP BY m.campaign_id
  ) mails ON mails.camp_id=camp.id
JOIN civicrm_activity acts ON acts.campaign_id=camp.id
LEFT JOIN civicrm_value_action_source_4 utm ON utm.entity_id=acts.id AND acts.status_id=9
LEFT JOIN (
    SELECT 
      sp.entity_id AS share_id, MIN(viral.id) AS infected_id
    FROM civicrm_value_share_params_6 sp JOIN civicrm_value_action_source_4 viral 
      ON sp.utm_source_37=viral.source_27 AND sp.utm_campaign_39=viral.campaign_26 AND sp.utm_medium_38=viral.media_28
    JOIN civicrm_activity a ON a.id=viral.entity_id AND a.activity_type_id=32
    GROUP BY sp.entity_id
  ) useful_shares ON useful_shares.share_id=acts.id
WHERE camp.name LIKE '20%' AND camp.name > '2016-10' AND camp.external_identifier < 10000
GROUP BY camp.id ORDER BY camp.name;
