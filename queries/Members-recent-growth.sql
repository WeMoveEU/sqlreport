
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
    analytics_members_country_language mcl

union

SELECT
 CONCAT(delta_t_h.period, " (%)") as description,   
   cast( SUM(number_added -number_removed) / t_total * 100 as decimal(5,2))  AS total,
   cast(sum(if(language = 'en_GB' and (country_id != 1226 or country_id is NULL), number_added - number_removed,0))  / t_en_INT * 100 as decimal(5,2)) as en_INT,

    cast(SUM(IF(language = 'de_DE', number_added - number_removed, 0)) / t_de_DE * 100 as decimal(5,2))  AS de_DE,
--    cast(SUM(IF(language = 'en_GB', number_added - number_removed, 0)) / t_en_GB * 100 as decimal(5,2)) AS en_GB,
     cast(SUM(IF(language = 'en_GB' and country_id = 1226, number_added - number_removed, 0))  / t_UK * 100 as decimal(5,2)) AS UK,

    cast(SUM(IF(language = 'es_ES', number_added - number_removed, 0)) / t_es_ES * 100 as decimal(5,2)) AS es_ES,
    cast(SUM(IF(language = 'fr_FR', number_added - number_removed, 0)) / t_fr_FR * 100 as decimal(5,2)) AS fr_FR,
    cast(SUM(IF(language = 'it_IT', number_added - number_removed, 0)) / t_it_IT * 100 as decimal(5,2)) AS it_IT,
    cast(SUM(IF(language = 'en_US', number_added - number_removed, 0)) / t_en_US * 100 as decimal(5,2)) AS en_US,
    cast(SUM(if(language not in ('de_DE','en_GB',  'es_ES', 'fr_FR', 'it_IT', 'en_US'), number_added - number_removed, 0)) / t_other * 100 as decimal(5,2)) AS other,  
    max(stamp) as last_calculated
FROM
    analytics_member_metrics_dt dt
    join analytics_delta_t_h delta_t_h on dt.delta_t_h_id = delta_t_h.id
    join 
    (
        select
   SUM(members) AS t_total,
   sum(if(language = 'en_GB' and (country_id != 1226 or country_id is NULL), members,0)) as t_en_INT,
  SUM(IF(language = 'de_DE', members, 0)) AS t_de_DE,
     SUM(IF(language = 'en_GB' and country_id = 1226, members, 0)) AS t_UK,
--    SUM(IF(m1.language = 'en_GB', m1.number_added - number_removed, 0)) AS en_GB,
    SUM(IF(language = 'es_ES',members, 0)) AS t_es_ES,
    SUM(IF(language = 'fr_FR', members, 0)) AS t_fr_FR,
    SUM(IF(language = 'it_IT',members, 0)) AS t_it_IT,
    SUM(IF(language = 'en_US', members, 0)) AS t_en_US,
    SUM(if(language not in ('de_DE','en_GB',  'es_ES', 'fr_FR', 'it_IT', 'en_US'), members, 0)) AS t_other
FROM
    analytics_members_country_language mcl ) total 
     group by delta_t_h.id
    
union 

SELECT
delta_t_h.period as description,   
    SUM(number_added -number_removed) AS total,
     sum(if(language = 'en_GB' and (country_id != 1226 or country_id is NULL), number_added - number_removed,0)) as en_INT,
    SUM(IF(language = 'de_DE', number_added - number_removed, 0)) AS de_DE,
     SUM(IF(language = 'en_GB' and country_id = 1226, number_added - number_removed, 0))  AS UK,
     SUM(IF(language = 'es_ES', number_added - number_removed, 0)) AS es_ES,
    SUM(IF(language = 'fr_FR', number_added - number_removed, 0)) AS fr_FR,
    SUM(IF(language = 'it_IT', number_added - number_removed, 0)) AS it_IT,
    SUM(IF(language = 'en_US', number_added - number_removed, 0)) AS en_US,
    SUM(if(language not in ('de_DE','en_GB',  'es_ES', 'fr_FR', 'it_IT', 'en_US'), number_added - number_removed, 0)) AS other,  
    max(stamp) as last_calculated
FROM
    analytics_member_metrics_dt dt
    join analytics_delta_t_h delta_t_h on dt.delta_t_h_id = delta_t_h.id
    group by delta_t_h.id
    
