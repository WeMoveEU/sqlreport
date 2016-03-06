SELECT 
    *
FROM
    analytics_member_metrics
WHERE
    language = 'en_GB'; 



SELECT 
    country_id,
    civicrm_country.iso_code,
    civicrm_country.name,
    SUM(number_added) members
FROM
    analytics_member_metrics
        LEFT JOIN
    civicrm_country ON civicrm_country.id = country_id
WHERE
    language = 'en_GB'
        AND added_date > '2016-02-01'
GROUP BY country_id
ORDER BY members DESC
;
