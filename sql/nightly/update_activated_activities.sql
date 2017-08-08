-- Set to "Completed Activated (id:10)" the status of activities
-- that are completed and [re-]activated the member
-- Activity types looked at: phone call, email, event registration, contribution, 
--     petition signature, created petition, share, tweet

SELECT @stamp := NULL, @contact := NULL, @active_once := 0, @active_threshold := 90; 
UPDATE
  civicrm_activity act 
  JOIN (
    SELECT 
      a.id AS id,
      a.status_id AS status_id,
      @creation_days := TIMESTAMPDIFF(DAY, c.created_date, a.activity_date_time),
      @days := IF(@contact = ac.contact_id, TIMESTAMPDIFF(DAY, @stamp, a.activity_date_time), -1),
      @activated := (NOT @active_once AND @creation_days > 0) OR (@days > @active_threshold) AS activated,
      @active_once := IF(@contact = ac.contact_id, @activated OR @active_once, 0),
      @contact := ac.contact_id,
      @stamp := a.activity_date_time
    FROM civicrm_activity_contact ac 
    JOIN civicrm_activity a ON a.id=ac.activity_id 
    JOIN civicrm_contact c ON c.id=ac.contact_id
    WHERE a.activity_type_id IN (6, 28, 32) 
      AND a.status_id IN (2, 9, 10)
    ORDER BY ac.contact_id ASC, a.activity_date_time ASC
  ) aa
  ON act.id=aa.id
  SET act.status_id=10
  WHERE aa.status_id=2 AND aa.activated=1;