
SELECT
"total number of members" as description, 
    SUM(members) AS total,
   sum(if(language = 'en_GB' and (country_id != 1226 or country_id is NULL), members,0)) as en_INT,
  SUM(IF(language = 'de_DE', members, 0)) AS de_DE,
     SUM(IF(language = 'en_GB' and country_id = 1226, members, 0)) AS UK,
--    SUM(IF(m1.language = 'en_GB', m1.number_added - number_removed, 0)) AS en_GB,
    SUM(IF(language = 'es_ES',members, 0)) AS es_ES,
    SUM(IF(language = 'fr_FR', members, 0)) AS fr_FR,
    SUM(IF(language = 'it_IT',members, 0)) AS it_IT,
    SUM(IF(language = 'en_US', members, 0)) AS en_US,
    SUM(if(language not in ('de_DE','en_GB',  'es_ES', 'fr_FR', 'it_IT', 'en_US'), members, 0)) AS other,  
    max(stamp) as last_calculated
FROM
    analytics_members_country_language mcl;
    