-- it's necessary to remove triggers on civicrm_value_contact_segments! in order to use civicrm_contact table

--
-- Insert any new contacts
--

SELECT
  contact.id, 0, 0
FROM civicrm_contact contact
WHERE contact.id > (
  SELECT MAX(entity_id) FROM civicrm_value_contact_segments
)
INTO OUTFILE '/var/lib/mysql-files/nightly-contact-segments-%NOW%.tsv';
;

LOAD DATA INFILE '/var/lib/mysql-files/nightly-contact-segments-%NOW%.tsv'
  INTO TABLE civicrm_value_contact_segments 
  (entity_id, recurring_donor, active_status)
;

--
-- Recurring donors segment
--
  SELECT recur.contact_id,
    MAX(
      CASE
        WHEN donation.id IS NULL
        AND recur.cancel_date IS NOT NULL THEN 1
        WHEN donation.id IS NULL THEN 3
        WHEN donation.contribution_status_id != 1 THEN 1
        WHEN recur.cancel_date IS NOT NULL OR recur.end_date IS NOT NULL THEN 2
        ELSE 3
      END
    ) recurring_donor
  FROM civicrm_contribution_recur recur
  LEFT JOIN civicrm_contribution donation ON recur.id = donation.contribution_recur_id
  WHERE recur.is_test = 0
  GROUP BY contact_id
  INTO OUTFILE '/var/lib/mysql-files/nightly-recurring-segments-%NOW%.tsv';

LOAD DATA INFILE  '/var/lib/mysql-files/nightly-recurring-segments-%NOW%.tsv' 
REPLACE
INTO TABLE civicrm_value_contact_segments (entity_id, recurring_donor);

--
-- Active members segment
--
-- pre-fill everyone as not member or inactive, 
-- this must reset active_status = 0 if the contact isn't currently "Added".
UPDATE civicrm_value_contact_segments s
  JOIN civicrm_group_contact gc ON s.entity_id = gc.contact_id AND gc.group_id = 42
  SET s.active_status = IF(gc.status = 'Added', 1, 0)
;

-- Temporary table of active members
CREATE TEMPORARY TABLE active_users (
  contact_id int
);

SELECT
  DISTINCT gc.contact_id
FROM civicrm_contact contact
JOIN civicrm_group_contact gc ON gc.contact_id = contact.id
JOIN civicrm_activity_contact ac1 ON gc.contact_id = ac1.contact_id
JOIN civicrm_activity a1 ON ac1.activity_id = a1.id
WHERE gc.group_id = 42
  AND gc.status = 'Added'
  AND a1.activity_type_id IN (2, 3, 6, 28, 32, 54, 59, 67)
  AND a1.activity_date_time >= DATE_ADD(NOW(), INTERVAL - 3 MONTH)
  AND a1.activity_date_time >= DATE_ADD(contact.created_date, INTERVAL 1 DAY)
INTO OUTFILE 
'/var/lib/mysql-files/nightly-active-users-%NOW%.tsv'
;
LOAD DATA INFILE '/var/lib/mysql-files/nightly-active-users-%NOW%.tsv'
INTO TABLE active_users
(contact_id);

-- Update segment value for active members
UPDATE civicrm_value_contact_segments s
  JOIN active_users active ON s.entity_id = active.contact_id
  SET s.active_status = 2
;

DROP TABLE active_users;
