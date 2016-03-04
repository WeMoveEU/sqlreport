SELECT 
    SUM(m1.number_added) - 
    SUM(m1.number_removed) AS total_members,
    SUM(IF(m1.language = 'de_DE', m1.number_added - number_removed, 0)) AS de_DE,
    SUM(IF(m1.language = 'en_GB', m1.number_added - number_removed, 0)) AS en_GB,
    SUM(IF(m1.language = 'es_ES', m1.number_added - number_removed, 0)) AS es_ES,
    SUM(IF(m1.language = 'fr_FR', m1.number_added - number_removed, 0)) AS fr_FR,
    SUM(IF(m1.language = 'it_IT', m1.number_added - number_removed, 0)) AS it_IT,
    SUM(IF(m1.language = 'en_US', m1.number_added - number_removed, 0)) AS en_US,
    SUM(if(language not in ('de_DE','en_GB',  'es_ES', 'fr_FR', 'it_IT', 'en_US'), m1.number_added - number_removed, 0)) AS other,  
    max(stamp) as last_calculated_on
FROM
    analytics_member_metrics m1
-- GROUP BY added_date
-- ORDER BY added_date DESC; 
