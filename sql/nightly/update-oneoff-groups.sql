--
-- @trello https://trello.com/c/vm2saVsq/167-first-second-third-time-donors-groups
-- @author Tomasz
--

SET @cnt = 1;
SET @member_group = 42;
SET @group_id = (SELECT id FROM civicrm_group WHERE title = 'ONE one-off');

DELETE FROM civicrm_group_contact WHERE group_id = @group_id;

DELETE FROM civicrm_subscription_history WHERE group_id = @group_id;

SELECT @group_id, t.contact_id, 'Added'
FROM (
        SELECT ct.contact_id, max(ct.total_amount) max_total_amount
        FROM civicrm_contribution ct
          JOIN civicrm_group_contact gc ON gc.group_id = @member_group AND gc.status = 'Added' AND gc.contact_id = ct.contact_id
          LEFT JOIN civicrm_contribution_recur cr ON cr.contact_id = ct.contact_id
        WHERE ct.contribution_status_id = 1
          AND ct.receive_date >= DATE_ADD(CURRENT_DATE(), INTERVAL -18 MONTH)
          AND ct.is_test = 0
          AND ct.contribution_recur_id IS NULL
          AND cr.id IS NULL
        GROUP BY ct.contact_id
        HAVING count(ct.id) = @cnt
      ) t
WHERE t.max_total_amount <= 500 INTO OUTFILE '/var/lib/mysql-files/nightly-donor-groups-%NOW%.tsv';

LOAD DATA INFILE '/var/lib/mysql-files/nightly-donor-groups-%NOW%.tsv' IGNORE
INTO TABLE civicrm_group_contact (group_id, contact_id, `status`);


SELECT
  contact_id, group_id, 'Admin', status, NOW()
FROM civicrm_group_contact
WHERE group_id = @group_id AND status = 'Added' 
INTO OUTFILE  '/var/lib/mysql-files/nightly-donor-groups-subscription-history-%NOW%.tsv';

LOAD DATA INFILE '/var/lib/mysql-files/nightly-donor-groups-subscription-history-%NOW%.tsv' IGNORE
INTO TABLE civicrm_subscription_history (contact_id, group_id, method, `status`, `date`);


SET @cnt = 2;
SET @member_group = 42;
SET @group_id = (SELECT id FROM civicrm_group WHERE title = 'TWO one-off');

DELETE FROM civicrm_group_contact WHERE group_id = @group_id;

DELETE FROM civicrm_subscription_history WHERE group_id = @group_id;

SELECT @group_id, t.contact_id, 'Added'
FROM (
        SELECT ct.contact_id, max(ct.total_amount) max_total_amount
        FROM civicrm_contribution ct
          JOIN civicrm_group_contact gc ON gc.group_id = @member_group AND gc.status = 'Added' AND gc.contact_id = ct.contact_id
          LEFT JOIN civicrm_contribution_recur cr ON cr.contact_id = ct.contact_id
        WHERE ct.contribution_status_id = 1
          AND ct.receive_date >= DATE_ADD(CURRENT_DATE(), INTERVAL -18 MONTH)
          AND ct.is_test = 0
          AND ct.contribution_recur_id IS NULL
          AND cr.id IS NULL
        GROUP BY ct.contact_id
        HAVING count(ct.id) = @cnt
      ) t
WHERE t.max_total_amount <= 500
INTO OUTFILE '/var/lib/mysql-files/nightly-donor-groups-group-two-%NOW%.tsv';

LOAD DATA INFILE '/var/lib/mysql-files/nightly-donor-groups-group-two-%NOW%.tsv' IGNORE
INTO TABLE civicrm_group_contact (group_id, contact_id, `status`);

SELECT
  contact_id, group_id, 'Admin', status, NOW()
FROM civicrm_group_contact
WHERE group_id = @group_id AND status = 'Added'
INTO OUTFILE '/var/lib/mysql-files/nightly-donor-groups-two-history-%NOW%.tsv';

LOAD DATA INFILE '/var/lib/mysql-files/nightly-donor-groups-two-history-%NOW%.tsv' IGNORE
INTO TABLE civicrm_subscription_history (contact_id, group_id, method, `status`, `date`);

SET @cnt = 3;
SET @member_group = 42;
SET @group_id = (SELECT id FROM civicrm_group WHERE title = 'THREE one-off');

DELETE FROM civicrm_group_contact WHERE group_id = @group_id;

DELETE FROM civicrm_subscription_history WHERE group_id = @group_id;

SELECT @group_id, t.contact_id, 'Added'
FROM (
  SELECT ct.contact_id, max(ct.total_amount) max_total_amount
  FROM civicrm_contribution ct
         JOIN civicrm_group_contact gc ON gc.group_id = @member_group AND gc.status = 'Added' AND gc.contact_id = ct.contact_id
         LEFT JOIN civicrm_contribution_recur cr ON cr.contact_id = ct.contact_id
  WHERE ct.contribution_status_id = 1
    AND ct.receive_date >= DATE_ADD(CURRENT_DATE(), INTERVAL -18 MONTH)
    AND ct.is_test = 0
    AND ct.contribution_recur_id IS NULL
    AND cr.id IS NULL
  GROUP BY ct.contact_id
  HAVING count(ct.id) = @cnt
) t
WHERE t.max_total_amount <= 500
INTO OUTFILE '/var/lib/mysql-files/nightly-donor-groups-three-%NOW%.tsv';

LOAD DATA INFILE '/var/lib/mysql-files/nightly-donor-groups-three-%NOW%.tsv' IGNORE
INTO TABLE civicrm_group_contact (group_id, contact_id, `status`);

SELECT
  contact_id, group_id, 'Admin', status, NOW()
FROM civicrm_group_contact
WHERE group_id = @group_id AND status = 'Added'
INTO OUTFILE '/var/lib/mysql-files/nightly-donor-groups-three-history-%NOW%.tsv';

LOAD DATA INFILE '/var/lib/mysql-files/nightly-donor-groups-three-history-%NOW%.tsv' IGNORE
INTO TABLE civicrm_subscription_history (contact_id, group_id, method, `status`, `date`);
