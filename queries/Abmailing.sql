SELECT
  (SELECT mailing_abtest_id FROM data_mailing_ab WHERE id = m.id) AS abtest_id,
  id, IFNULL((SELECT concat(mailing_abtest_type, ':', mailing_type) FROM data_mailing_ab WHERE id = m.id), 'standalone') AS type,
  (SELECT min(start_date)
  FROM civicrm_mailing_job
  WHERE status = 'Complete' AND is_test = 0 AND mailing_id = m.id) start_date,
  (SELECT max(end_date)
  FROM civicrm_mailing_job
  WHERE status = 'Complete' AND is_test = 0 AND mailing_id = m.id) sent_date,
  co.value median_original,
  cm.value median_mailjet,
  cm2.value max_mailjet
FROM civicrm_mailing m
  LEFT JOIN analytics_mailing_counter_datetime co ON co.mailing_id = m.id AND co.counter = 'median_original'
  LEFT JOIN analytics_mailing_counter_datetime cm ON cm.mailing_id = m.id AND cm.counter = 'median_mailjet'
  LEFT JOIN analytics_mailing_counter_datetime cm2 ON cm2.mailing_id = m.id AND cm2.counter = 'max_mailjet'
WHERE m.is_completed = 1
ORDER BY id DESC;
