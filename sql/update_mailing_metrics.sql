-- 
-- These queries assume that they are run at least daily
--

-- Recipients
INSERT IGNORE INTO data_mailing_counter
  SELECT mailing_id, 'recipients', 0, COUNT(*) FROM civicrm_mailing_recipients GROUP BY mailing_id;

-- Opens
INSERT INTO data_mailing_counter 
  SELECT j.mailing_id, 'opens', b.box, COUNT(DISTINCT q.id) 
    FROM civicrm_mailing_job j
    JOIN civicrm_mailing_event_queue q ON q.job_id=j.id
    JOIN civicrm_mailing_event_opened o ON o.event_queue_id=q.id
    JOIN data_timeboxes b ON TIMESTAMPDIFF(MINUTE, j.start_date, o.time_stamp)<b.box
    WHERE j.is_test=0 AND TIMESTAMPADD(DAY, 100, j.start_date) > NOW()
    GROUP BY j.mailing_id, b.box
  ON DUPLICATE KEY UPDATE value=VALUES(value);

-- Clicks
INSERT INTO data_mailing_counter 
  SELECT j.mailing_id, 'clicks', b.box, COUNT(DISTINCT q.id) 
    FROM civicrm_mailing_job j
    JOIN civicrm_mailing_event_queue q ON q.job_id=j.id
    JOIN civicrm_mailing_event_trackable_url_open o ON o.event_queue_id=q.id
    JOIN data_timeboxes b ON TIMESTAMPDIFF(MINUTE, j.start_date, o.time_stamp)<b.box
    WHERE j.is_test=0 AND TIMESTAMPADD(DAY, 100, j.start_date) > NOW()
    GROUP BY j.mailing_id, b.box
  ON DUPLICATE KEY UPDATE value=VALUES(value);

-- Direct activities
-- Assumes that the status of shares is always the same (Completed)
-- Force order of joins for MySQL 5.5, could be removed in later versions
INSERT INTO data_mailing_counter
  SELECT STRAIGHT_JOIN SUBSTRING(s.source_27, 10), 
      IF(a.activity_type_id=32,
        CASE
          WHEN a.status_id=9 THEN 'new_direct_signs'
          WHEN a.status_id=4 THEN 'optout_direct_signs'
          WHEN a.status_id=2 THEN 'known_direct_signs'
          ELSE 'pending_direct_signs'
        END, 
        'direct_shares'), 
      b.box, 
      COUNT(DISTINCT c.contact_id) 
    FROM civicrm_value_action_source_4 s
    JOIN civicrm_activity a ON a.id=s.entity_id 
    JOIN civicrm_activity_contact c on a.id=c.activity_id
    JOIN (SELECT mailing_id, MIN(start_date) AS start_date FROM civicrm_mailing_job WHERE is_test=0 GROUP BY mailing_id) j 
      ON j.mailing_id=SUBSTRING(s.source_27, 10)
    JOIN data_timeboxes b ON TIMESTAMPDIFF(MINUTE, j.start_date, a.activity_date_time)<b.box
    WHERE (a.activity_type_id=32 OR a.activity_type_id=54)
      AND a.status_id IN (1, 2, 4, 9)
      AND s.source_27 LIKE 'civimail-%'
      AND TIMESTAMPADD(DAY, 100, j.start_date) > NOW()
    GROUP BY s.source_27, a.activity_type_id, a.status_id, b.box
  ON DUPLICATE KEY UPDATE value=VALUES(value);

-- Viral activities
-- Assumes that the status of shares is always the same (Completed)
-- Force order of joins for MySQL 5.5, could be removed in later versions
INSERT INTO data_mailing_counter
  SELECT STRAIGHT_JOIN SUBSTRING(source.source_27, 10), 
      IF(inf_a.activity_type_id=32, 
        CASE
          WHEN inf_a.status_id=9 THEN 'new_viral_signs'
          WHEN inf_a.status_id=4 THEN 'optout_viral_signs'
          WHEN inf_a.status_id=2 THEN 'known_viral_signs'
          ELSE 'pending_viral_signs'
        END, 
        'viral_shares'), 
      b.box, 
      COUNT(DISTINCT inf_c.contact_id)
    FROM civicrm_value_action_source_4 infected
    JOIN civicrm_value_share_params_6 share ON infected.campaign_26=share.utm_campaign_39 AND infected.media_28=share.utm_medium_38
    JOIN civicrm_value_action_source_4 source ON share.entity_id=source.entity_id AND source.source_27 LIKE 'civimail-%'
    JOIN civicrm_activity inf_a ON inf_a.id=infected.entity_id
    JOIN civicrm_activity_contact inf_c on inf_a.id=inf_c.activity_id
    JOIN (SELECT mailing_id, MIN(start_date) AS start_date FROM civicrm_mailing_job WHERE is_test=0 GROUP BY mailing_id) j 
      ON j.mailing_id=SUBSTRING(source.source_27, 10)
    JOIN data_timeboxes b ON TIMESTAMPDIFF(MINUTE, j.start_date, inf_a.activity_date_time)<b.box
    WHERE TIMESTAMPADD(DAY, 100, j.start_date) > NOW()
    GROUP BY source.source_27, inf_a.activity_type_id, inf_a.status_id, b.box
  ON DUPLICATE KEY UPDATE value=VALUES(value);

