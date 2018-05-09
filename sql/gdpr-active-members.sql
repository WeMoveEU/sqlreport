
SET @gdpr_group_id = (SELECT id FROM civicrm_group WHERE name = 'gdpr_active_members');

DELETE FROM civicrm_group_contact WHERE group_id = @gdpr_group_id;

INSERT INTO civicrm_group_contact (group_id, contact_id, status)
  SELECT
    @gdpr_group_id, gc.contact_id, 'Added'
  FROM
    civicrm_contact c
    JOIN civicrm_group_contact gc ON c.id = gc.contact_id
    JOIN civicrm_email email ON email.contact_id = c.id
    JOIN civicrm_activity_contact ac1 ON gc.contact_id = ac1.contact_id
    JOIN civicrm_activity a1 ON ac1.activity_id = a1.id
  WHERE
    c.is_opt_out = 0
      AND c.preferred_language IS NOT NULL
      AND gc.group_id = 42
      AND gc.status = 'Added'
      AND email.is_primary IS TRUE
      AND email.on_hold = 0
      AND a1.activity_type_id IN (6, 28, 32, 54, 59)
      AND a1.activity_date_time >= DATE_ADD(DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY), INTERVAL -12 MONTH)
      AND a1.activity_date_time >= DATE_ADD(c.created_date, INTERVAL 1 DAY)
  GROUP BY gc.contact_id;

DELETE FROM civicrm_subscription_history WHERE group_id = @gdpr_group_id;

INSERT INTO civicrm_subscription_history (contact_id, group_id, date, status)
  SELECT contact_id, group_id, NOW(), status FROM civicrm_group_contact
  WHERE group_id = @gdpr_group_id AND status = 'Added'
  LIMIT 1;
