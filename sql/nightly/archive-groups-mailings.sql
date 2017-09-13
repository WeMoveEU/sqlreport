UPDATE civicrm_group g
JOIN (
  SELECT go.id AS id
  FROM civicrm_group go JOIN civicrm_subscription_history h ON h.group_id=go.id
  WHERE go.title LIKE 'zz%' AND go.is_active = 1 
  GROUP BY go.id HAVING MAX(h.date) < DATE_ADD(NOW(), INTERVAL -1 MONTH)
) o ON g.id=o.id
SET g.is_active=0;

DELETE LOW_PRIORITY g, gc, gh
FROM (
  SELECT go.id AS id
  FROM civicrm_group go JOIN civicrm_subscription_history h ON h.group_id=go.id
  WHERE go.title LIKE 'zz%' AND go.is_active = 0 
  GROUP BY go.id HAVING MAX(h.date) < DATE_ADD(NOW(), INTERVAL -3 MONTH)
) o
JOIN civicrm_group g ON g.id=o.id
JOIN civicrm_group_contact gc ON gc.group_id=o.id
JOIN civicrm_subscription_history gh ON gh.group_id=o.id;


UPDATE civicrm_mailing
SET is_archived=1
WHERE scheduled_date < DATE_ADD(NOW(), INTERVAL -3 MONTH);

DELETE FROM civicrm_mailing
WHERE scheduled_id IS NULL AND created_date < DATE_ADD(NOW(), INTERVAL -6 MONTH);
