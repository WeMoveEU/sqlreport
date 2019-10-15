-- it's necessary to remove triggers on civicrm_value_contact_segments! in order to use civicrm_contact table

-- Create the value of recurring_donor segment
INSERT INTO civicrm_value_contact_segments (entity_id, recurring_donor)
  SELECT
    c.id,
    IF(contact_id IS NULL, 0, segment_value)
  FROM civicrm_contact c
  LEFT JOIN (
    SELECT
        r.contact_id AS contact_id,
        MAX(
          CASE
            WHEN d.id IS NULL AND r.cancel_date IS NOT NULL THEN 1 -- failed
            WHEN d.id IS NULL THEN 3 -- current (new)
            WHEN d.contribution_status_id != 1 THEN 1 -- failed
            WHEN r.cancel_date IS NOT NULL OR r.end_date IS NOT NULL THEN 2 -- past
            ELSE 3 -- current
          END
        ) AS segment_value
      FROM civicrm_contribution_recur r
      LEFT JOIN civicrm_contribution d ON r.id=d.contribution_recur_id
      GROUP BY contact_id
  ) v ON v.contact_id=c.id
  ON DUPLICATE KEY UPDATE recurring_donor=VALUES(recurring_donor)
;

BEGIN;
-- Active members segment: pre-fill everyone as not member or inactive
  INSERT INTO civicrm_value_contact_segments (entity_id, active_status)
    SELECT
      c.id,
      IF(group_id IS NULL, 0, 1)
    FROM civicrm_contact c
    LEFT JOIN civicrm_group_contact gc ON gc.contact_id=c.id AND gc.group_id=42 AND gc.status='Added'
    ON DUPLICATE KEY UPDATE active_status=VALUES(active_status)
  ;

-- Active members segment: update active rows
  UPDATE civicrm_value_contact_segments s
    JOIN (
      SELECT
        gc.contact_id
      FROM
        civicrm_contact c
        JOIN civicrm_group_contact gc ON gc.contact_id=c.id
        JOIN civicrm_activity_contact ac1 ON gc.contact_id = ac1.contact_id
        JOIN civicrm_activity a1 ON ac1.activity_id = a1.id
      WHERE gc.group_id = 42
        AND gc.status = 'Added'
        AND a1.activity_type_id IN (2, 3, 6, 28, 32, 54, 59, 67)
        AND a1.activity_date_time >= DATE_ADD(NOW(), INTERVAL - 3 MONTH)
        AND a1.activity_date_time >= DATE_ADD(c.created_date, INTERVAL 1 DAY)
      GROUP BY gc.contact_id
    ) tmp ON tmp.contact_id = s.entity_id
    SET s.active_status=2
  ;
COMMIT;
