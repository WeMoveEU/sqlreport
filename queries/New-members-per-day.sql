SELECT 
    m1.added_date AS date,
    SUM(m1.number_added) AS total_added,
    SUM(m1.number_removed) AS total_removed,
    SUM(m1.number_added) - SUM(m1.number_removed) AS net,
    SUM(IF(m1.language = 'de_DE', m1.number_added, 0)) AS de_DE,
    SUM(IF(m1.language = 'en_GB', m1.number_added, 0)) AS en_GB,
    SUM(IF(m1.language = 'es_ES', m1.number_added, 0)) AS es_ES,
    SUM(IF(m1.language = 'fr_FR', m1.number_added, 0)) AS fr_FR,
    SUM(IF(m1.language = 'it_IT', m1.number_added, 0)) AS it_IT,
    SUM(IF(m1.language = 'en_US', m1.number_added, 0)) AS en_US,
    SUM(IF(m1.language = 'de_DE', m1.number_removed, 0)) AS un_de_DE,
    SUM(IF(language = 'en_GB', m1.number_removed, 0)) AS un_en_GB,
    SUM(IF(language = 'es_ES', m1.number_removed, 0)) AS un_es_ES,
    SUM(IF(language = 'fr_FR', m1.number_removed, 0)) AS un_fr_FR,
    SUM(IF(language = 'it_IT', m1.number_removed, 0)) AS un_it_IT,
    SUM(IF(language = 'en_US', m1.number_removed, 0)) AS un_en_US
FROM
    analytics_member_metrics m1
GROUP BY added_date
ORDER BY added_date DESC; 
