SET @iced_group = (SELECT id FROM civicrm_group WHERE name = 'ICED_Contacts');

DROP TABLE IF EXISTS tmp_6months_actions;
CREATE TABLE tmp_6months_actions (
  contact_id INT UNSIGNED PRIMARY KEY
);
-- opens

SELECT q.contact_id
FROM civicrm_mailing_event_opened o1
  JOIN civicrm_mailing_event_queue q ON o1.event_queue_id = q.id
WHERE o1.time_stamp BETWEEN DATE_ADD(DATE_ADD(CURRENT_DATE, INTERVAL -6 MONTH), INTERVAL -3 DAY)
AND DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY)
INTO OUTFILE '/var/lib/mysql-files/nightly-iced-opens-%NOW%.tsv';

LOAD DATA INFILE '/var/lib/mysql-files/nightly-iced-opens-%NOW%.tsv' 
IGNORE INTO TABLE tmp_6months_actions
(contact_id);

-- clicks
SELECT q.contact_id
FROM civicrm_mailing_event_trackable_url_open o1
  JOIN civicrm_mailing_event_queue q ON o1.event_queue_id = q.id
WHERE o1.time_stamp BETWEEN DATE_ADD(DATE_ADD(CURRENT_DATE, INTERVAL -6 MONTH), INTERVAL -3 DAY)
AND DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY)
INTO OUTFILE '/var/lib/mysql-files/nightly-iced-clicks-%NOW%.tsv';

LOAD DATA INFILE '/var/lib/mysql-files/nightly-iced-clicks-%NOW%.tsv' 
IGNORE INTO TABLE tmp_6months_actions
(contact_id);

-- list of all iced contacts
DROP TABLE IF EXISTS tmp_6months;
CREATE TABLE tmp_6months (
  id INT UNSIGNED PRIMARY KEY
);

SELECT
  eq.contact_id
FROM civicrm_mailing_event_delivered ed
  JOIN civicrm_mailing_event_queue eq ON eq.id = ed.event_queue_id
  JOIN civicrm_contact c ON c.id = eq.contact_id
  LEFT JOIN tmp_6months_actions a ON a.contact_id = eq.contact_id
WHERE ed.time_stamp BETWEEN DATE_ADD(DATE_ADD(CURRENT_DATE, INTERVAL -6 MONTH), INTERVAL -3 DAY)
AND DATE_ADD(CURRENT_DATE, INTERVAL -3 DAY)
AND c.created_date < DATE_ADD(CURRENT_DATE, INTERVAL -6 MONTH)
    AND a.contact_id IS NULL
INTO OUTFILE '/var/lib/mysql-files/nightly-iced-contacts-%NOW%.tsv';

LOAD DATA INFILE '/var/lib/mysql-files/nightly-iced-contacts-%NOW%.tsv'
IGNORE INTO TABLE tmp_6months (id);

-- add if needed
SET @iced_count = (SELECT sum(result)
FROM
  (SELECT dontusSetGroupContact(@iced_group, id, 'Added') result
  FROM tmp_6months) t);

-- remove id needed
DROP TABLE IF EXISTS tmp_6months_remove;
CREATE TABLE tmp_6months_remove (
  id INT UNSIGNED PRIMARY KEY
);
  SELECT gc.contact_id
  FROM civicrm_group_contact gc
    LEFT JOIN tmp_6months m ON m.id = gc.contact_id
  WHERE m.id IS NULL AND gc.group_id = @iced_group AND gc.status = 'Added'
  INTO OUTFILE '/var/lib/mysql-files/nightly-iced-remove-%NOW%.tsv';

LOAD DATA INFILE  '/var/lib/mysql-files/nightly-iced-remove-%NOW%.tsv'
IGNORE INTO TABLE tmp_6months_remove (id);

SET @iced_removed = (SELECT sum(result)
FROM
  (SELECT dontusSetGroupContact(@iced_group, id, 'Removed') result
  FROM tmp_6months_remove) t);
SELECT @iced_removed;
