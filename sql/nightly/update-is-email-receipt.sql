UPDATE civicrm_contribution_recur cr
  JOIN civicrm_contribution ct ON ct.contribution_recur_id = cr.id
SET cr.is_email_receipt = 0
WHERE cr.is_email_receipt = 1;
