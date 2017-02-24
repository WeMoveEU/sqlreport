
-- analytics_temp_mailing contains mailings which should be updated
TRUNCATE analytics_temp_mailing;

-- step 0. remove those which don't have values
DELETE FROM analytics_mailing_counter_datetime
WHERE `value` IS NULL;



-- step 1. insert those which don't have counters
INSERT IGNORE INTO analytics_temp_mailing
  SELECT m.id FROM civicrm_mailing m
    LEFT JOIN analytics_mailing_counter_datetime c ON c.mailing_id = m.id AND c.counter = 'median_original'
  WHERE m.is_completed = 1 AND c.mailing_id IS NULL;

INSERT IGNORE INTO analytics_temp_mailing
  SELECT m.id FROM civicrm_mailing m
    LEFT JOIN analytics_mailing_counter_datetime c ON c.mailing_id = m.id AND c.counter = 'median_mailjet'
  WHERE m.is_completed = 1 AND c.mailing_id IS NULL;

INSERT IGNORE INTO analytics_temp_mailing
  SELECT m.id FROM civicrm_mailing m
    LEFT JOIN analytics_mailing_counter_datetime c ON c.mailing_id = m.id AND c.counter = 'max_mailjet'
  WHERE m.is_completed = 1 AND c.mailing_id IS NULL;

-- step 2. insert those which have newer events than date of preparing report
INSERT IGNORE INTO analytics_temp_mailing
  SELECT cd.mailing_id
  FROM analytics_mailing_counter_datetime cd
    JOIN civicrm_mailing_job mj ON mj.mailing_id = cd.mailing_id AND mj.is_test = 0
    JOIN civicrm_mailing_event_queue eq ON eq.job_id = mj.id
    JOIN civicrm_mailing_event_delivered ed ON ed.event_queue_id = eq.id
  WHERE cd.counter = 'max_mailjet' AND ed.time_stamp > cd.updated_at AND ed.original_time_stamp > '1970-01-01';


-- step 3. remove counters those which should be updated
DELETE cd FROM analytics_mailing_counter_datetime cd JOIN analytics_temp_mailing tm ON tm.id = cd.mailing_id;



INSERT IGNORE INTO analytics_mailing_counter_datetime
  SELECT m.id, 'median_original', analyticsMedianOriginalTimeStamp(m.id), NOW()
  FROM civicrm_mailing m
    JOIN analytics_temp_mailing tm ON tm.id = m.id
  WHERE m.is_completed = 1;

INSERT IGNORE INTO analytics_mailing_counter_datetime
  SELECT m.id, 'median_mailjet', analyticsMedianTimeStamp(m.id), NOW()
  FROM civicrm_mailing m
    JOIN analytics_temp_mailing tm ON tm.id = m.id
  WHERE m.is_completed = 1;

-- time_stamp include date from mailjet
-- original_time_stamp > '1970-01-01' means that we get records with all data
INSERT IGNORE INTO analytics_mailing_counter_datetime
  SELECT id, 'max_mailjet', max_time_stamp, NOW()
  FROM  (SELECT m.id, max(ed.time_stamp) max_time_stamp
  FROM civicrm_mailing_event_delivered ed
    JOIN civicrm_mailing_event_queue eq ON eq.id = ed.event_queue_id AND ed.original_time_stamp > '1970-01-01'
    JOIN civicrm_mailing_job mj ON mj.id = eq.job_id AND mj.is_test = 0
    JOIN civicrm_mailing m ON m.id = mj.mailing_id
    JOIN analytics_temp_mailing tm ON tm.id = m.id
  WHERE m.is_completed = 1
  GROUP BY m.id) t;
