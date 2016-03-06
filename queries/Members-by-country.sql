SELECT 
    country_id,
    civicrm_country.iso_code,
    civicrm_country.name,
    SUM(number_added-number_removed) as members
FROM
    analytics_member_metrics
        LEFT JOIN
    civicrm_country ON civicrm_country.id = country_id
GROUP BY country_id
ORDER BY members DESC
;
