-- how many days to analyse after the mailing
SELECT @timeslot := 11;

-- Recipients
-- INSERT IGNORE does not work because A/B mailing recipients may not be correct until they are sent
INSERT INTO data_mailing_counter
  SELECT mailing_id, 'recipients', 0, COUNT(*), NOW() 
    FROM civicrm_mailing_recipients r JOIN civicrm_mailing m ON r.mailing_id=m.id
    WHERE m.scheduled_id IS NOT NULL
    GROUP BY mailing_id
  ON DUPLICATE KEY UPDATE value=VALUES(value), last_updated=NOW();

-- Delivered by Mailjet
INSERT INTO data_mailing_counter
  SELECT mj.mailing_id, 'delivered_mailjet', 0, COUNT(ed.id), NOW()
  FROM civicrm_mailing_event_delivered ed
    JOIN civicrm_mailing_event_queue eq ON eq.id = ed.event_queue_id
    JOIN civicrm_mailing_job mj ON mj.id = eq.job_id AND mj.is_test = 0
  WHERE ed.mailjet_time_stamp > '1970-01-01'
  GROUP BY mj.mailing_id
ON DUPLICATE KEY UPDATE value = VALUES(value), last_updated = NOW();

-- Opens
INSERT INTO data_mailing_counter 
  SELECT j.mailing_id, 'opens', b.box, COUNT(DISTINCT q.id), NOW()
    FROM civicrm_mailing_job j
    JOIN civicrm_mailing_event_queue q ON q.job_id=j.id
    JOIN civicrm_mailing_event_opened o ON o.event_queue_id=q.id
    JOIN data_timeboxes b ON TIMESTAMPDIFF(MINUTE, j.start_date, o.time_stamp)<b.box
    WHERE j.is_test=0 AND TIMESTAMPADD(DAY, @timeslot , j.start_date) > NOW()
    GROUP BY j.mailing_id, b.box
  ON DUPLICATE KEY UPDATE value=VALUES(value), last_updated=NOW();

-- Clicks
INSERT INTO data_mailing_counter 
  SELECT j.mailing_id, 'clicks', b.box, COUNT(DISTINCT q.id), NOW() 
    FROM civicrm_mailing_job j
    JOIN civicrm_mailing_event_queue q ON q.job_id=j.id
    JOIN civicrm_mailing_event_trackable_url_open o ON o.event_queue_id=q.id
    JOIN data_timeboxes b ON TIMESTAMPDIFF(MINUTE, j.start_date, o.time_stamp)<b.box
    WHERE j.is_test=0 AND TIMESTAMPADD(DAY, @timeslot, j.start_date) > NOW()
    GROUP BY j.mailing_id, b.box
  ON DUPLICATE KEY UPDATE value=VALUES(value), last_updated=NOW();

-- Unsubscribes
INSERT INTO data_mailing_counter 
  SELECT j.mailing_id, 'unsubs', b.box, COUNT(DISTINCT q.id), NOW() 
    FROM civicrm_mailing_job j
    JOIN civicrm_mailing_event_queue q ON q.job_id=j.id
    JOIN civicrm_mailing_event_unsubscribe o ON o.event_queue_id=q.id
    JOIN data_timeboxes b ON TIMESTAMPDIFF(MINUTE, j.start_date, o.time_stamp)<b.box
    WHERE j.is_test=0 AND TIMESTAMPADD(DAY, @timeslot, j.start_date) > NOW()
    GROUP BY j.mailing_id, b.box
  ON DUPLICATE KEY UPDATE value=VALUES(value), last_updated=NOW();

-- Direct activities
-- Assumes that the status of shares is always the same (Completed)
-- Force order of joins for MySQL 5.5, could be removed in later versions
INSERT INTO data_mailing_counter
  SELECT  SUBSTRING(s.source_27, 10), 
      IF(a.activity_type_id=32,
        CASE
          WHEN a.status_id=9 THEN 'new_direct_signs'
          WHEN a.status_id=4 THEN 'optout_direct_signs'
          WHEN a.status_id=2 THEN 'known_direct_signs'
          WHEN a.status_id=5 THEN 'bounced_direct_signs'
          WHEN a.status_id=10 THEN 'activated_direct_signs'

          ELSE 'pending_direct_signs'
        END, 
        'direct_shares'), 
      b.box, 
      COUNT(DISTINCT c.contact_id),
      NOW() 
    FROM civicrm_value_action_source_4 s
    JOIN civicrm_activity a ON a.id=s.entity_id 
    JOIN civicrm_activity_contact c on a.id=c.activity_id
    JOIN (SELECT mailing_id, MIN(start_date) AS start_date FROM civicrm_mailing_job WHERE is_test=0 GROUP BY mailing_id) j 
      ON j.mailing_id=SUBSTRING(s.source_27, 10)
    JOIN data_timeboxes b ON TIMESTAMPDIFF(MINUTE, j.start_date, a.activity_date_time)<b.box
    WHERE (a.activity_type_id=32 OR a.activity_type_id=54)
      AND a.status_id IN (1, 2, 4, 5, 9, 10)
      AND s.source_27 LIKE 'civimail-%'
      AND TIMESTAMPADD(DAY, @timeslot, j.start_date) > NOW()
    GROUP BY s.source_27, a.activity_type_id, a.status_id, b.box
  ON DUPLICATE KEY UPDATE value=VALUES(value), last_updated=NOW();

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
          WHEN inf_a.status_id=5 THEN 'bounced_viral_signs'
          WHEN inf_a.status_id=10 THEN 'activated_viral_signs'
          ELSE 'pending_viral_signs'
        END, 
        'viral_shares'), 
      b.box, 
      COUNT(DISTINCT inf_c.contact_id),
      NOW()
    FROM civicrm_value_action_source_4 infected
    JOIN civicrm_value_share_params_6 share ON infected.campaign_26=share.utm_campaign_39 AND infected.media_28=share.utm_medium_38
    JOIN civicrm_value_action_source_4 source ON share.entity_id=source.entity_id AND source.source_27 LIKE 'civimail-%'
    JOIN civicrm_activity inf_a ON inf_a.id=infected.entity_id
    JOIN civicrm_activity_contact inf_c on inf_a.id=inf_c.activity_id
    JOIN (SELECT mailing_id, MIN(start_date) AS start_date FROM civicrm_mailing_job WHERE is_test=0 GROUP BY mailing_id) j 
      ON j.mailing_id=SUBSTRING(source.source_27, 10)
    JOIN data_timeboxes b ON TIMESTAMPDIFF(MINUTE, j.start_date, inf_a.activity_date_time)<b.box
    WHERE TIMESTAMPADD(DAY, @timeslot, j.start_date) > NOW()
    GROUP BY source.source_27, inf_a.activity_type_id, inf_a.status_id, b.box
  ON DUPLICATE KEY UPDATE value=VALUES(value), last_updated=NOW();

-- sum signatures

insert into data_mailing_counter (mailing_id, counter, value, timebox,last_updated) select mailing_id, 'signs',sum(value), timebox as sign,now() from data_mailing_counter where timebox=14400 and counter like '%_signs' group by mailing_id on DUPLICATE KEY UPDATE value=VALUES(value), last_updated=NOW();


-- Contribution amounts
-- TODO: fix and simplify: we do not need the recur_amount anymore, specific query
INSERT INTO data_mailing_counter
  SELECT 
      SUBSTRING(utm_source_30, 10),
      IF (r.id IS NULL, 'oneoff_amount', 'recur_amount') AS counter,
      b.box,
      CAST(SUM(total_amount) AS UNSIGNED INTEGER),
      NOW() 
    FROM civicrm_contribution c 
    JOIN civicrm_value_utm_5 utm ON c.id=entity_id
    LEFT JOIN civicrm_contribution_recur r ON r.id=c.contribution_recur_id
    JOIN (SELECT mailing_id, MIN(start_date) AS start_date FROM civicrm_mailing_job WHERE is_test=0 GROUP BY mailing_id) j 
      ON j.mailing_id=SUBSTRING(utm_source_30, 10)
    JOIN data_timeboxes b 
      ON TIMESTAMPDIFF(MINUTE, j.start_date, IF(r.id IS NULL, c.receive_date, r.create_date))<b.box
    WHERE utm_medium_31 in ('email','speakout') AND utm_source_30 LIKE 'civimail-%'
    GROUP BY utm_source_30, counter, b.box
  ON DUPLICATE KEY UPDATE value=VALUES(value), last_updated=NOW();

-- contribution recurring amount

INSERT INTO data_mailing_counter select SUBSTRING(utm_source, 10), 'recur_amount' AS counter, 14400, CAST(SUM(amount) AS UNSIGNED INTEGER), NOW() from civicrm_contribution_recur r join civicrm_value_recur_utm utm on utm.entity_id=r.id  where utm_source like "civimail-%" group by utm_source order by utm_source desc ON DUPLICATE KEY UPDATE value=VALUES(value), last_updated=NOW();


-- Number of contributions
-- TODO: fix and simplify: we do not need the recur_donation anymore, specific query
INSERT INTO data_mailing_counter
  SELECT 
      SUBSTRING(utm_source_30, 10),
      IF (r.id IS NULL, 'oneoff_donations', 'recur_donations') AS counter,
      b.box,
      COUNT(*),
      NOW()
    FROM civicrm_contribution c 
    JOIN civicrm_value_utm_5 utm ON c.id=entity_id
    LEFT JOIN civicrm_contribution_recur r ON r.id=c.contribution_recur_id
    JOIN (SELECT mailing_id, MIN(start_date) AS start_date FROM civicrm_mailing_job WHERE is_test=0 GROUP BY mailing_id) j 
      ON j.mailing_id=SUBSTRING(utm_source_30, 10)
    JOIN data_timeboxes b 
      ON TIMESTAMPDIFF(MINUTE, j.start_date, IF(r.id IS NULL, c.receive_date, r.create_date))<b.box
    WHERE utm_medium_31 in ('email','speakout') AND utm_source_30 LIKE 'civimail-%'
    GROUP BY utm_source_30, counter, b.box
  ON DUPLICATE KEY UPDATE value=VALUES(value), last_updated=NOW();

-- Number of recurring contributions
INSERT INTO data_mailing_counter select SUBSTRING(utm_source, 10), 'recur_donations' AS counter, 14400, count(*) a, NOW() from civicrm_contribution_recur r join civicrm_value_recur_utm utm on utm.entity_id=r.id  where utm_source like "civimail-%" group by utm_source order by utm_source desc ON DUPLICATE KEY UPDATE value=VALUES(value), last_updated=NOW();
