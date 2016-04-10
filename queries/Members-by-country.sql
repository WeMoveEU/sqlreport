SELECT 
    civicrm_country.name,
    SUM(members) as members,
    stamp as last_calculated
FROM
    analytics_members_country_language
        LEFT JOIN
    civicrm_country ON civicrm_country.id = country_id
GROUP BY country_id
ORDER BY members DESC
;
