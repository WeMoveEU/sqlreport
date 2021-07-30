-- Set to "Completed Activated (id:10)" the status of activities
-- that are completed and [re-]activated the member
-- Activity types looked at: phone call, email, contribution, survey, petition signature, share, tweet, facebook

SELECT @stamp := NULL, @contact := NULL, @active_once := 0, @active_threshold := 90; 

SELECT 
  a.id AS id,
  a.status_id AS status_id,
  @creation_days := TIMESTAMPDIFF(DAY, c.created_date, a.activity_date_time) creation_days,
  @inactive_days := IF(@contact = ac.contact_id, TIMESTAMPDIFF(DAY, @stamp, a.activity_date_time), -1) inactive_days,
  @activated := (NOT @active_once AND @creation_days > 0) OR (@inactive_days > @active_threshold) AS activated,
  IF(NOT @active_once AND @creation_days > 0, @creation_days, @inactive_days) AS `days`,
  @active_once := IF(@contact = ac.contact_id, @activated OR @active_once, 0) active_once,
  @contact := ac.contact_id contact_id,
  @stamp := a.activity_date_time stamp
FROM civicrm_activity_contact ac 
JOIN civicrm_activity a ON a.id=ac.activity_id 
JOIN civicrm_contact c ON c.id=ac.contact_id
WHERE a.activity_type_id IN (2, 3, 6, 28, 32, 54, 59, 67) 
  AND a.status_id IN (2, 9, 10)
ORDER BY ac.contact_id ASC, a.activity_date_time ASC 
INTO OUTFILE '/var/lib/mysql-files/nightly-update-activities-%NOW%.sql';

CREATE TEMPORARY TABLE tmp_update_activated (
  id INT,
  status_id INT,
  creation_days INT,
  inactive_days INT,
  activated INT,
  `days` INT,
  active_once INT,
  contact_id INT,
  stamp TIMESTAMP
);

LOAD DATA INFILE '/var/lib/mysql-files/nightly-update-activities-%NOW%.sql' 
REPLACE INTO TABLE tmp_update_activated;

UPDATE civicrm_activity act 
JOIN tmp_update_activated aa
ON act.id=aa.id
SET act.status_id=10, act.duration=aa.days
WHERE aa.status_id=2 AND aa.activated=1;
