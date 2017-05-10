SELECT
  cr.month,
  nr.new_recur, nr.new_amount,
  lr.cancelled_recur, lr.cancelled_amount,
  nrl.nrc_total, nrl.nrc_en_INT, nrl.nrc_de_DE, nrl.nrc_UK, nrl.nrc_es_ES, nrl.nrc_fr_FR, nrl.nrc_it_IT, nrl.nrc_pl_PL,
  nrl.nrc_en_US, nrl.nrc_other, nrl.nrm_total, nrl.nrm_en_INT, nrl.nrm_de_DE, nrl.nrm_UK, nrl.nrm_es_ES, nrl.nrm_fr_FR,
  nrl.nrm_it_IT, nrl.nrm_pl_PL, nrl.nrm_en_US, nrl.nrm_other,
  lrl.lrc_total_lost, lrl.lrc_en_INT, lrl.lrc_de_DE, lrl.lrc_UK, lrl.lrc_es_ES, lrl.lrc_fr_FR, lrl.lrc_it_IT, lrl.lrc_pl_PL,
  lrl.lrc_en_US, lrl.lrc_other, lrl.lrm_total_lost, lrl.lrm_en_INT, lrl.lrm_de_DE, lrl.lrm_UK, lrl.lrm_es_ES, lrl.lrm_fr_FR,
  lrl.lrm_it_IT, lrl.lrm_pl_PL, lrl.lrm_en_US, lrl.lrm_other
FROM
  (SELECT DISTINCT (DATE_FORMAT(create_date, '%Y-%m')) AS month
   FROM civicrm_contribution_recur
   UNION SELECT DISTINCT (DATE_FORMAT(cancel_date, '%Y-%m')) AS month
   FROM civicrm_contribution_recur WHERE cancel_date IS NOT NULL) cr
  LEFT JOIN (SELECT
  (DATE_FORMAT(date, '%Y-%m')) AS month, COUNT(*) AS new_recur, SUM(amount) new_amount
FROM
  (SELECT
    R.id,
    create_date AS date,
    amount
  FROM
    civicrm_contribution_recur AS R
    JOIN civicrm_contact co ON R.contact_id = co.id
    JOIN civicrm_payment_processor pp ON payment_processor_id = pp.id
    LEFT JOIN civicrm_option_value status ON option_group_id = 11
      AND contribution_status_id = status.value
    LEFT JOIN civicrm_sdd_mandate M ON R.id = M.entity_id
      AND M.entity_table = 'civicrm_contribution_recur'
    LEFT JOIN civicrm_contribution c ON contribution_recur_id = R.id
    LEFT JOIN civicrm_value_utm_5 utm ON c.id = utm.entity_id
    LEFT JOIN civicrm_address a ON a.contact_id = c.contact_id
      AND is_primary = 1
    LEFT JOIN civicrm_country ctry ON a.country_id = ctry.id
  GROUP BY R.id) AS recurtab
GROUP BY month) nr ON nr.month = cr.month
  LEFT JOIN (SELECT
  DATE_FORMAT(cancel_date, '%Y-%m') AS month, COUNT(*) AS cancelled_recur, SUM(amount) cancelled_amount
FROM
  (SELECT
    R.id,
    R.cancel_date,
    amount
  FROM
    civicrm_contribution_recur AS R
    JOIN civicrm_contact co ON R.contact_id = co.id
    JOIN civicrm_payment_processor pp ON payment_processor_id = pp.id
    LEFT JOIN civicrm_option_value status ON option_group_id = 11
      AND contribution_status_id = status.value
    LEFT JOIN civicrm_sdd_mandate M ON R.id = M.entity_id
      AND M.entity_table = 'civicrm_contribution_recur'
    LEFT JOIN civicrm_contribution c ON contribution_recur_id = R.id
    LEFT JOIN civicrm_value_utm_5 utm ON c.id = utm.entity_id
    LEFT JOIN civicrm_address a ON a.contact_id = c.contact_id
      AND is_primary = 1
    LEFT JOIN civicrm_country ctry ON a.country_id = ctry.id
  GROUP BY R.id) AS recurtab
GROUP BY month) lr ON lr.month = cr.month
  LEFT JOIN (SELECT
  month,
  SUM(new_recur) AS nrc_total,
  SUM(if(language = 'en_GB' AND (country != 'GB' OR country IS NULL), new_recur, 0)) AS nrc_en_INT,
  SUM(IF(language = 'de_DE', new_recur, 0)) AS nrc_de_DE,
  SUM(IF(language = 'en_GB' AND country = 'GB', new_recur, 0)) AS nrc_UK,
  SUM(IF(language = 'es_ES', new_recur, 0)) AS nrc_es_ES,
  SUM(IF(language = 'fr_FR', new_recur, 0)) AS nrc_fr_FR,
  SUM(IF(language = 'it_IT', new_recur, 0)) AS nrc_it_IT,
  SUM(IF(language = 'pl_PL', new_recur, 0)) AS nrc_pl_PL,
  SUM(IF(language = 'en_US', new_recur, 0)) AS nrc_en_US,
  SUM(if(language NOT IN ('de_DE', 'en_GB', 'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), new_recur, 0)) AS nrc_other,
  SUM(money) AS nrm_total,
  SUM(if(language = 'en_GB' AND (country != 'GB' OR country IS NULL), money, 0)) AS nrm_en_INT,
  SUM(IF(language = 'de_DE', money, 0)) AS nrm_de_DE,
  SUM(IF(language = 'en_GB' AND country = 'GB', money, 0)) AS nrm_UK,
  SUM(IF(language = 'es_ES', money, 0)) AS nrm_es_ES,
  SUM(IF(language = 'fr_FR', money, 0)) AS nrm_fr_FR,
  SUM(IF(language = 'it_IT', money, 0)) AS nrm_it_IT,
  SUM(IF(language = 'pl_PL', money, 0)) AS nrm_pl_PL,
  SUM(IF(language = 'en_US', money, 0)) AS nrm_en_US,
  SUM(if(language NOT IN ('de_DE', 'en_GB', 'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), money, 0)) AS nrm_other
FROM (SELECT
  DATE_FORMAT(date, '%Y-%m') AS month, language, country, COUNT(*) AS new_recur, SUM(amount) AS money
FROM
  (SELECT DISTINCTROW
    R.id,
    create_date AS date,
    amount,
    ctry.iso_code AS country,
    co.preferred_language AS language
  FROM
    civicrm_contribution_recur AS R
    JOIN civicrm_contact co ON R.contact_id = co.id
    JOIN civicrm_payment_processor pp ON payment_processor_id = pp.id
    LEFT JOIN civicrm_option_value status ON option_group_id = 11 AND contribution_status_id = status.value
    LEFT JOIN civicrm_sdd_mandate M ON R.id = M.entity_id AND M.entity_table = 'civicrm_contribution_recur'
    LEFT JOIN civicrm_contribution c ON contribution_recur_id = R.id
    LEFT JOIN civicrm_value_utm_5 utm ON c.id = utm.entity_id
    LEFT JOIN civicrm_address a ON a.contact_id = c.contact_id AND is_primary = 1
    LEFT JOIN civicrm_country ctry ON a.country_id = ctry.id
  ) AS recurtab
GROUP BY month, language, country) AS recurtab2
GROUP BY month) nrl ON nrl.month = cr.month
  LEFT JOIN (SELECT
  month,
  SUM(new_recur) AS lrc_total_lost,
  sum(if(language = 'en_GB' AND (country != 'GB' OR country IS NULL), new_recur, 0)) AS lrc_en_INT,
  SUM(IF(language = 'de_DE', new_recur, 0)) AS lrc_de_DE,
  SUM(IF(language = 'en_GB' AND country = 'GB', new_recur, 0)) AS lrc_UK,
  SUM(IF(language = 'es_ES', new_recur, 0)) AS lrc_es_ES,
  SUM(IF(language = 'fr_FR', new_recur, 0)) AS lrc_fr_FR,
  SUM(IF(language = 'it_IT', new_recur, 0)) AS lrc_it_IT,
  SUM(IF(language = 'pl_PL', new_recur, 0)) AS lrc_pl_PL,
  SUM(IF(language = 'en_US', new_recur, 0)) AS lrc_en_US,
  SUM(if(language NOT IN ('de_DE', 'en_GB', 'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), new_recur, 0)) AS lrc_other,
  SUM(money) AS lrm_total_lost,
  sum(if(language = 'en_GB' AND (country != 'GB' OR country IS NULL), money, 0)) AS lrm_en_INT,
  SUM(IF(language = 'de_DE', money, 0)) AS lrm_de_DE,
  SUM(IF(language = 'en_GB' AND country = 'GB', money, 0)) AS lrm_UK,
  SUM(IF(language = 'es_ES', money, 0)) AS lrm_es_ES,
  SUM(IF(language = 'fr_FR', money, 0)) AS lrm_fr_FR,
  SUM(IF(language = 'it_IT', money, 0)) AS lrm_it_IT,
  SUM(IF(language = 'pl_PL', money, 0)) AS lrm_pl_PL,
  SUM(IF(language = 'en_US', money, 0)) AS lrm_en_US,
  SUM(if(language NOT IN ('de_DE', 'en_GB', 'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), money, 0)) AS lrm_other
FROM (
       SELECT
         DATE_FORMAT(cancel_date, '%Y-%m') AS month, language, country, COUNT(*) AS new_recur, SUM(amount) AS money
       FROM
         (SELECT DISTINCTROW
           R.id,
           R.cancel_date,
           amount,
           ctry.iso_code AS country,
           co.preferred_language AS language
         FROM
           civicrm_contribution_recur AS R
           JOIN civicrm_contact co ON R.contact_id = co.id
           JOIN civicrm_payment_processor pp ON payment_processor_id = pp.id
           LEFT JOIN civicrm_option_value status ON option_group_id = 11
             AND contribution_status_id = status.value
           LEFT JOIN civicrm_sdd_mandate M ON R.id = M.entity_id
             AND M.entity_table = 'civicrm_contribution_recur'
           LEFT JOIN civicrm_contribution c ON contribution_recur_id = R.id
           LEFT JOIN civicrm_value_utm_5 utm ON c.id = utm.entity_id
           LEFT JOIN civicrm_address a ON a.contact_id = c.contact_id
             AND is_primary = 1
           LEFT JOIN civicrm_country ctry ON a.country_id = ctry.id
         ) AS recurtab
       GROUP BY month, language, country) AS recurtab2
GROUP BY month) lrl ON lrl.month = cr.month
ORDER BY cr.month DESC;
