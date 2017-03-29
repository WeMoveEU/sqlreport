use wemove_47;
SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));



SELECT 
    DATE_FORMAT(date, '%Y-%m') AS month, COUNT(*) as new_recur, SUM(amount)
FROM
    (SELECT 
        R.id,
            co.first_name,
            R.contact_id,
            utm_campaign_33 AS camp,
            utm_source_30 AS source,
            utm_medium_31 AS medium,
            utm_content_32 AS content,
            create_date AS date,
            R.cancel_date,
            R.currency,
            pp.name AS processor,
            status.name AS status,
            M.status AS sepa_status,
            frequency_unit AS frequency,
            amount,
            SUM(IF(c.contribution_status_id = 1, 1, 0)) AS nb,
            SUM(IF(c.contribution_status_id = 1, c.total_amount, 0)) AS total_amount,
            ctry.iso_code AS country,
            co.created_date AS contact_since,
            co.preferred_language as language
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
    GROUP BY R.id
    ORDER BY date DESC) AS recurtab
GROUP BY month
ORDER BY month DESC
; 
 
  
SELECT 
    DATE_FORMAT(cancel_date, '%Y-%m') AS month, COUNT(*) as cancelled_recur, SUM(amount)
FROM
    (SELECT 
        R.id,
            co.first_name,
            R.contact_id,
            utm_campaign_33 AS camp,
            utm_source_30 AS source,
            utm_medium_31 AS medium,
            utm_content_32 AS content,
            create_date AS date,
            R.cancel_date,
            R.currency,
            pp.name AS processor,
            status.name AS status,
            M.status AS sepa_status,
            frequency_unit AS frequency,
            amount,
            SUM(IF(c.contribution_status_id = 1, 1, 0)) AS nb,
            SUM(IF(c.contribution_status_id = 1, c.total_amount, 0)) AS total_amount,
            ctry.iso_code AS country,
            co.created_date AS contact_since,
                   co.preferred_language as language
    
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
    GROUP BY R.id
    ORDER BY date DESC) AS recurtab
GROUP BY month
ORDER BY month DESC
; 
 
 
 select month, 
 
     SUM(new_recur) AS total,
   sum(if(language = 'en_GB' and (country != "GB" or country is NULL), new_recur,0)) as en_INT,
   SUM(IF(language = 'de_DE', new_recur, 0)) AS de_DE,
	SUM(IF(language = 'en_GB' and country = "GB", new_recur, 0)) AS UK,
--    SUM(IF(m1.language = 'en_GB', m1.number_added - number_removed, 0)) AS en_GB,
    SUM(IF(language = 'es_ES',new_recur, 0)) AS es_ES,
    SUM(IF(language = 'fr_FR', new_recur, 0)) AS fr_FR,
    SUM(IF(language = 'it_IT',new_recur, 0)) AS it_IT,
    SUM(IF(language = 'pl_PL',new_recur, 0)) AS pl_PL,
    SUM(IF(language = 'en_US', new_recur, 0)) AS en_US,
    SUM(if(language not in ('de_DE','en_GB',  'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), new_recur, 0)) AS other,  
 
     SUM(money) AS total,
   sum(if(language = 'en_GB' and (country != "GB" or country is NULL), money,0)) as en_INT,
   SUM(IF(language = 'de_DE', money, 0)) AS de_DE,
	SUM(IF(language = 'en_GB' and country = "GB", money, 0)) AS UK,
--    SUM(IF(m1.language = 'en_GB', m1.number_added - number_removed, 0)) AS en_GB,
    SUM(IF(language = 'es_ES',money, 0)) AS es_ES,
    SUM(IF(language = 'fr_FR', money, 0)) AS fr_FR,
    SUM(IF(language = 'it_IT',money, 0)) AS it_IT,
    SUM(IF(language = 'pl_PL',money, 0)) AS pl_PL,
    SUM(IF(language = 'en_US', money, 0)) AS en_US,
    SUM(if(language not in ('de_DE','en_GB',  'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), money, 0)) AS other
 
 from (
SELECT 
    DATE_FORMAT(date, '%Y-%m') AS month, COUNT(*) as new_recur, SUM(amount) as money, language, country
FROM
    (SELECT 
        R.id,
            co.first_name,
            R.contact_id,
            utm_campaign_33 AS camp,
            utm_source_30 AS source,
            utm_medium_31 AS medium,
            utm_content_32 AS content,
            create_date AS date,
            R.cancel_date,
            R.currency,
            pp.name AS processor,
            status.name AS status,
            M.status AS sepa_status,
            frequency_unit AS frequency,
            amount,
            SUM(IF(c.contribution_status_id = 1, 1, 0)) AS nb,
            SUM(IF(c.contribution_status_id = 1, c.total_amount, 0)) AS total_amount,
            ctry.iso_code AS country,
            co.created_date AS contact_since,
            co.preferred_language as language
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
    GROUP BY R.id
    ORDER BY date DESC) AS recurtab
GROUP BY month, language, country
ORDER BY month DESC) as recurtab2
group by month
order by month desc

; 
 
   
   
   select month, 
 
     SUM(new_recur) AS total_lost,
   sum(if(language = 'en_GB' and (country != "GB" or country is NULL), new_recur,0)) as en_INT,
   SUM(IF(language = 'de_DE', new_recur, 0)) AS de_DE,
	SUM(IF(language = 'en_GB' and country = "GB", new_recur, 0)) AS UK,
--    SUM(IF(m1.language = 'en_GB', m1.number_added - number_removed, 0)) AS en_GB,
    SUM(IF(language = 'es_ES',new_recur, 0)) AS es_ES,
    SUM(IF(language = 'fr_FR', new_recur, 0)) AS fr_FR,
    SUM(IF(language = 'it_IT',new_recur, 0)) AS it_IT,
    SUM(IF(language = 'pl_PL',new_recur, 0)) AS pl_PL,
    SUM(IF(language = 'en_US', new_recur, 0)) AS en_US,
    SUM(if(language not in ('de_DE','en_GB',  'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), new_recur, 0)) AS other,  
 
     SUM(money) AS total_lost,
   sum(if(language = 'en_GB' and (country != "GB" or country is NULL), money,0)) as en_INT,
   SUM(IF(language = 'de_DE', money, 0)) AS de_DE,
	SUM(IF(language = 'en_GB' and country = "GB", money, 0)) AS UK,
--    SUM(IF(m1.language = 'en_GB', m1.number_added - number_removed, 0)) AS en_GB,
    SUM(IF(language = 'es_ES',money, 0)) AS es_ES,
    SUM(IF(language = 'fr_FR', money, 0)) AS fr_FR,
    SUM(IF(language = 'it_IT',money, 0)) AS it_IT,
    SUM(IF(language = 'pl_PL',money, 0)) AS pl_PL,
    SUM(IF(language = 'en_US', money, 0)) AS en_US,
    SUM(if(language not in ('de_DE','en_GB',  'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), money, 0)) AS other
 
 from (
    
    SELECT 
    DATE_FORMAT(cancel_date, '%Y-%m') AS month, COUNT(*) as new_recur, SUM(amount) as money, language, country
FROM
    (SELECT 
        R.id,
            co.first_name,
            R.contact_id,
            utm_campaign_33 AS camp,
            utm_source_30 AS source,
            utm_medium_31 AS medium,
            utm_content_32 AS content,
            create_date AS date,
            R.cancel_date,
            R.currency,
            pp.name AS processor,
            status.name AS status,
            M.status AS sepa_status,
            frequency_unit AS frequency,
            amount,
            SUM(IF(c.contribution_status_id = 1, 1, 0)) AS nb,
            SUM(IF(c.contribution_status_id = 1, c.total_amount, 0)) AS total_amount,
            ctry.iso_code AS country,
            co.created_date AS contact_since,
                   co.preferred_language as language
    
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
    GROUP BY R.id
    ORDER BY date DESC) AS recurtab
GROUP BY month, language, country
ORDER BY month DESC) as recurtab2
group by month
order by month desc
; 
 
  
