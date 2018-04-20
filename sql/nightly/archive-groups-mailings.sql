UPDATE civicrm_group g
JOIN (
  SELECT go.id AS id
  FROM civicrm_group go JOIN civicrm_subscription_history h ON h.group_id=go.id
  WHERE go.is_active = 1
    AND (go.title LIKE 'zz%' OR go.title LIKE 'survey-%' OR go.title LIKE '201%')
  GROUP BY go.id HAVING MAX(h.date) < DATE_ADD(NOW(), INTERVAL -1 MONTH)
) o ON g.id=o.id
SET g.is_active=0;

-- Entries in group_contact and subscription_history will be deleted on cascade
DELETE g
FROM (
  SELECT go.id AS id
  FROM civicrm_group go JOIN civicrm_subscription_history h ON h.group_id=go.id
  WHERE go.is_active = 0
    AND (go.title LIKE 'zz%' OR go.title LIKE 'survey-%' OR go.title LIKE '201%')
  GROUP BY go.id HAVING MAX(h.date) < DATE_ADD(NOW(), INTERVAL -3 MONTH)
) o
JOIN civicrm_group g ON g.id=o.id;

UPDATE civicrm_mailing
SET is_archived=1
WHERE scheduled_date < DATE_ADD(NOW(), INTERVAL -3 MONTH);

DELETE FROM civicrm_mailing
WHERE scheduled_id IS NULL AND created_date < DATE_ADD(NOW(), INTERVAL -6 MONTH);
