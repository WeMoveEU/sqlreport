-- Create the value of recurring_donor segment
-- it's necessary to remove triggers on civicrm_value_contact_segments! in order to use civicrm_contact table
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
