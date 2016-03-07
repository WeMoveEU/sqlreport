select * from analytics_member_metrics
where language = 'en_GB' and country_id = 1126;


select * from analytics_member_metrics
where language = 'en_GB' and country_id != 1126;

select * from analytics_member_metrics
where language = 'en_GB' ;


SELECT 
    m1.added_date AS date,
    SUM(m1.number_added) AS total_added,
    SUM(m1.number_removed) AS total_removed,
    SUM(m1.number_added) - SUM(m1.number_removed) AS net,
    sum(if(language = 'en_GB' and (country_id != 1226 or country_id is NULL), number_added,0)) as en_INT,
       sum(if(language = 'en_GB' and not (country_id = 1226 ) , number_added,0)) as en_INT,
   SUM(IF(m1.language = 'de_DE', m1.number_added, 0)) AS de_DE,
    SUM(IF(language = 'en_GB' and country_id = 1226, number_added, 0)) AS en_GB,
    SUM(IF(language = 'en_GB' and country_id is NULL , number_added, 0)) AS en_GB_null,
    SUM(IF(language = 'en_GB' , number_added, 0)) AS en_GB2,
  
    SUM(IF(m1.language = 'es_ES', m1.number_added, 0)) AS es_ES,
    SUM(IF(m1.language = 'fr_FR', m1.number_added, 0)) AS fr_FR,
    SUM(IF(m1.language = 'it_IT', m1.number_added, 0)) AS it_IT,
    SUM(IF(m1.language = 'en_US', m1.number_added, 0)) AS en_US,
    SUM(IF(m1.language = 'de_DE', m1.number_removed, 0)) AS un_de_DE,
    SUM(IF(language = 'en_GB', m1.number_removed, 0)) AS un_en_GB,
    SUM(IF(language = 'es_ES', m1.number_removed, 0)) AS un_es_ES,
    SUM(IF(language = 'fr_FR', m1.number_removed, 0)) AS un_fr_FR,
    SUM(IF(language = 'it_IT', m1.number_removed, 0)) AS un_it_IT,
    SUM(IF(language = 'en_US', m1.number_removed, 0)) AS un_en_US,
    max(stamp) as last_calculated_on
FROM
    analytics_member_metrics m1
GROUP BY added_date
ORDER BY added_date DESC; 
