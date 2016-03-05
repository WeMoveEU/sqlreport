

SELECT 
    kpidate AS date,
    SUM(active) AS total_3m,
    SUM(IF(language = 'de_DE', active, 0)) AS de_DE,
    SUM(IF(language = 'en_GB', active, 0)) AS en_GB,
    SUM(IF(language = 'es_ES', active, 0)) AS es_ES,
    SUM(IF(language = 'fr_FR', active, 0)) AS fr_FR,
    SUM(IF(language = 'it_IT', active, 0)) AS it_IT,
    SUM(IF(language = 'en_US', active, 0)) AS en_US,
    stamp as calculated_on
FROM
analytics_active_3m
GROUP BY kpidate
ORDER BY kpidate DESC;

