--
-- it's necessary to remove triggers on civicrm_value_contact_segments! in order to use civicrm_contact table
--
-- Insert any new contacts
--
INSERT INTO civicrm_value_contact_segments (entity_id, recurring_donor, active_status)
SELECT contact.id,
  0,
  0
FROM civicrm_contact contact
WHERE contact.id > (
    SELECT MAX(entity_id)
    FROM civicrm_value_contact_segments
  );
--
-- Create the value of recurring_donor segment
--
INSERT INTO civicrm_value_contact_segments (entity_id, recurring_donor)
SELECT recur.contact_id,
  MAX(
    CASE
      WHEN donation.id IS NULL
      AND recur.cancel_date IS NOT NULL THEN 1
      WHEN donation.id IS NULL THEN 3
      WHEN donation.contribution_status_id != 1 THEN 1
      WHEN recur.cancel_date IS NOT NULL
      OR recur.end_date IS NOT NULL THEN 2
      ELSE 3
    END
  ) recurring_donor
FROM civicrm_contribution_recur recur
  LEFT JOIN civicrm_contribution donation ON recur.id = donation.contribution_recur_id
WHERE recur.is_test = 0
GROUP BY contact_id ON DUPLICATE KEY
UPDATE recurring_donor =
VALUES(recurring_donor);
--
--- Active members segment: pre-fill everyone as not member or inactive
--
INSERT INTO civicrm_value_contact_segments (entity_id, active_status)
SELECT c.id,
  1 active_status
FROM civicrm_contact c
  JOIN civicrm_group_contact gc ON (
    gc.contact_id = c.id
    AND gc.group_id = 42
    AND gc.status = 'Added'
  ) ON DUPLICATE KEY
UPDATE active_status =
VALUES(active_status);
--
-- Active members segment: update active rows
--
UPDATE civicrm_value_contact_segments s
  JOIN (
    SELECT gc.contact_id
    FROM civicrm_contact c
      JOIN civicrm_group_contact gc ON gc.contact_id = c.id
      JOIN civicrm_activity_contact ac1 ON gc.contact_id = ac1.contact_id
      JOIN civicrm_activity a1 ON ac1.activity_id = a1.id
    WHERE gc.group_id = 42
      AND gc.status = 'Added'
      AND a1.activity_type_id IN (2, 3, 6, 28, 32, 54, 59, 67)
      AND a1.activity_date_time >= DATE_ADD(NOW(), INTERVAL - 3 MONTH)
      AND a1.activity_date_time >= DATE_ADD(c.created_date, INTERVAL 1 DAY)
    GROUP BY gc.contact_id
  ) tmp ON tmp.contact_id = s.entity_id
SET s.active_status = 2;