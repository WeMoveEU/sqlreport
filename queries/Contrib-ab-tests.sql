SELECT 
  IF(contribution_recur_id IS NULL, 'no', 'yes') AS recurring, 
  ab_testing_42 AS test, 
  ab_variant_43 AS variant, 
  COUNT(*) AS count, 
  SUM(total_amount) AS total 
FROM civicrm_contribution c JOIN civicrm_value_donor_extra_information_3 ab ON ab.entity_id=c.id 
WHERE ab_testing_42 IS NOT NULL AND ab_testing_42  != '' 
GROUP BY recurring, test, variant;
