SELECT 
    civicrm_country.name,
    SUM(number_added-number_removed) as members,
    stamp as last_calculated
FROM
    analytics_member_metrics
        LEFT JOIN
    civicrm_country ON civicrm_country.id = country_id
WHERE
    language = 'en_GB'
GROUP BY civicrm_country.name
ORDER BY members DESC
;
