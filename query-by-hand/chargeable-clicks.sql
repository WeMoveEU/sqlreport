
-- On Pirandello:
-- psql -qt -c "SELECT id FROM campaigns WHERE internal_name LIKE '%-DE' OR internal_name LIKE '%-EN' OR parent_campaign_id IN (SELECT parent_campaign_id FROM campaigns WHERE internal_name LIKE '%-DE' OR internal_name LIKE '%-EN')" speakout_you > charity-campaigns.txt
-- Copy output file to /var/lib/mysql-files on production civicrm server, after removing trailing new line at end of file.

CREATE TEMPORARY TABLE tmp_charity_campaign (id INT UNSIGNED PRIMARY KEY);
LOAD DATA INFILE '/var/lib/mysql-files/charity-campaigns.txt' INTO TABLE tmp_charity_campaign;

SELECT 'year', 'month', 'contacts', 'clicks'
UNION ALL
SELECT
  YEAR(evt.time_stamp) AS year, MONTH(evt.time_stamp) AS month, COUNT(distinct q.id) AS contacts, COUNT(*) AS clicks
FROM 
  civicrm_mailing_event_trackable_url_open evt
  JOIN civicrm_mailing_event_queue q ON evt.event_queue_id=q.id
  JOIN civicrm_contact c ON c.id=q.contact_id
  JOIN civicrm_mailing_job j ON j.id=q.job_id
  JOIN civicrm_mailing m ON m.id=j.mailing_id
  JOIN civicrm_campaign camp ON m.campaign_id=camp.id
  JOIN tmp_charity_campaign ch ON ch.id=camp.external_identifier
WHERE 
  c.source NOT LIKE 'speakout petition 10___'
  AND j.is_test=0
GROUP BY year, month
INTO OUTFILE '/var/lib/mysql-files/chargeable-clicks.csv'
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
;
