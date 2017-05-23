SELECT
  "total active members (yesterday)" as description, 
  SUM(active) AS total,
  SUM(if(language = 'en_GB' and (country_id != 1226 or country_id is NULL), active, 0)) as en_INT,
  SUM(IF(language = 'de_DE', active, 0)) AS de_DE,
  SUM(IF(language = 'en_GB' and country_id = 1226, active, 0)) AS UK,
  SUM(IF(language = 'es_ES', active, 0)) AS es_ES,
  SUM(IF(language = 'fr_FR', active, 0)) AS fr_FR,
  SUM(IF(language = 'it_IT', active, 0)) AS it_IT,
  SUM(IF(language = 'pl_PL', active, 0)) AS pl_PL,
  SUM(IF(language = 'en_US', active, 0)) AS en_US,
  SUM(if(language not in ('de_DE', 'en_GB', 'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), active, 0)) AS other,  
  MAX(stamp) as calculated
FROM analytics_active_2m_decay_4m
WHERE kpidate = DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)

UNION

SELECT
  IF(relative = 'yes', "last day (%)", "last day"),
  IF(relative = 'yes', CAST((yesterday.total - lastday.total) / lastday.total * 100 AS DECIMAL(5, 2)), yesterday.total - lastday.total),
  IF(relative = 'yes', CAST((yesterday.en_INT - lastday.en_INT) / lastday.total * 100 AS DECIMAL(5, 2)), yesterday.en_INT - lastday.en_INT),
  IF(relative = 'yes', CAST((yesterday.de_DE - lastday.de_DE) / lastday.total * 100 AS DECIMAL(5, 2)), yesterday.de_DE - lastday.de_DE),
  IF(relative = 'yes', CAST((yesterday.UK - lastday.UK) / lastday.total * 100 AS DECIMAL(5, 2)), yesterday.UK - lastday.UK),
  IF(relative = 'yes', CAST((yesterday.es_ES - lastday.es_ES) / lastday.total * 100 AS DECIMAL(5, 2)), yesterday.es_ES - lastday.es_ES),
  IF(relative = 'yes', CAST((yesterday.fr_FR - lastday.fr_FR) / lastday.total * 100 AS DECIMAL(5, 2)), yesterday.fr_FR - lastday.fr_FR),
  IF(relative = 'yes', CAST((yesterday.it_IT - lastday.it_IT) / lastday.total * 100 AS DECIMAL(5, 2)), yesterday.it_IT - lastday.it_IT),
  IF(relative = 'yes', CAST((yesterday.pl_PL - lastday.pl_PL) / lastday.total * 100 AS DECIMAL(5, 2)), yesterday.pl_PL - lastday.pl_PL),
  IF(relative = 'yes', CAST((yesterday.en_US - lastday.en_US) / lastday.total * 100 AS DECIMAL(5, 2)), yesterday.en_US - lastday.en_US),
  IF(relative = 'yes', CAST((yesterday.other - lastday.other) / lastday.total * 100 AS DECIMAL(5, 2)), yesterday.other - lastday.other),
  lastday.calculated
FROM (
    SELECT
      SUM(active) AS total,
      SUM(if(language = 'en_GB' and (country_id != 1226 or country_id is NULL), active, 0)) as en_INT,
      SUM(IF(language = 'de_DE', active, 0)) AS de_DE,
      SUM(IF(language = 'en_GB' and country_id = 1226, active, 0)) AS UK,
      SUM(IF(language = 'es_ES', active, 0)) AS es_ES,
      SUM(IF(language = 'fr_FR', active, 0)) AS fr_FR,
      SUM(IF(language = 'it_IT', active, 0)) AS it_IT,
      SUM(IF(language = 'pl_PL', active, 0)) AS pl_PL,
      SUM(IF(language = 'en_US', active, 0)) AS en_US,
      SUM(if(language not in ('de_DE', 'en_GB', 'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), active, 0)) AS other,  
      MAX(stamp) as calculated
    FROM analytics_active_2m_decay_4m
    WHERE kpidate = DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)
  ) yesterday
  JOIN (
    SELECT
      SUM(active) AS total,
      SUM(if(language = 'en_GB' and (country_id != 1226 or country_id is NULL), active, 0)) as en_INT,
      SUM(IF(language = 'de_DE', active, 0)) AS de_DE,
      SUM(IF(language = 'en_GB' and country_id = 1226, active, 0)) AS UK,
      SUM(IF(language = 'es_ES', active, 0)) AS es_ES,
      SUM(IF(language = 'fr_FR', active, 0)) AS fr_FR,
      SUM(IF(language = 'it_IT', active, 0)) AS it_IT,
      SUM(IF(language = 'pl_PL', active, 0)) AS pl_PL,
      SUM(IF(language = 'en_US', active, 0)) AS en_US,
      SUM(if(language not in ('de_DE', 'en_GB', 'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), active, 0)) AS other,  
      MAX(stamp) as calculated
    FROM analytics_active_2m_decay_4m
    WHERE kpidate = DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY)
  ) lastday
  JOIN (
    SELECT 'yes' AS relative UNION SELECT 'no' AS relative
  ) growth

UNION

SELECT
  IF(relative = 'yes', "day before (%)", "day before"),
  IF(relative = 'yes', CAST((lastday.total - daybefore.total) / daybefore.total * 100 AS DECIMAL(5, 2)), lastday.total - daybefore.total),
  IF(relative = 'yes', CAST((lastday.en_INT - daybefore.en_INT) / daybefore.total * 100 AS DECIMAL(5, 2)), lastday.en_INT - daybefore.en_INT),
  IF(relative = 'yes', CAST((lastday.de_DE - daybefore.de_DE) / daybefore.total * 100 AS DECIMAL(5, 2)), lastday.de_DE - daybefore.de_DE),
  IF(relative = 'yes', CAST((lastday.UK - daybefore.UK) / daybefore.total * 100 AS DECIMAL(5, 2)), lastday.UK - daybefore.UK),
  IF(relative = 'yes', CAST((lastday.es_ES - daybefore.es_ES) / daybefore.total * 100 AS DECIMAL(5, 2)), lastday.es_ES - daybefore.es_ES),
  IF(relative = 'yes', CAST((lastday.fr_FR - daybefore.fr_FR) / daybefore.total * 100 AS DECIMAL(5, 2)), lastday.fr_FR - daybefore.fr_FR),
  IF(relative = 'yes', CAST((lastday.it_IT - daybefore.it_IT) / daybefore.total * 100 AS DECIMAL(5, 2)), lastday.it_IT - daybefore.it_IT),
  IF(relative = 'yes', CAST((lastday.pl_PL - daybefore.pl_PL) / daybefore.total * 100 AS DECIMAL(5, 2)), lastday.pl_PL - daybefore.pl_PL),
  IF(relative = 'yes', CAST((lastday.en_US - daybefore.en_US) / daybefore.total * 100 AS DECIMAL(5, 2)), lastday.en_US - daybefore.en_US),
  IF(relative = 'yes', CAST((lastday.other - daybefore.other) / daybefore.total * 100 AS DECIMAL(5, 2)), lastday.other - daybefore.other),
  daybefore.calculated
FROM (
    SELECT
      SUM(active) AS total,
      SUM(if(language = 'en_GB' and (country_id != 1226 or country_id is NULL), active, 0)) as en_INT,
      SUM(IF(language = 'de_DE', active, 0)) AS de_DE,
      SUM(IF(language = 'en_GB' and country_id = 1226, active, 0)) AS UK,
      SUM(IF(language = 'es_ES', active, 0)) AS es_ES,
      SUM(IF(language = 'fr_FR', active, 0)) AS fr_FR,
      SUM(IF(language = 'it_IT', active, 0)) AS it_IT,
      SUM(IF(language = 'pl_PL', active, 0)) AS pl_PL,
      SUM(IF(language = 'en_US', active, 0)) AS en_US,
      SUM(if(language not in ('de_DE', 'en_GB', 'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), active, 0)) AS other,  
      MAX(stamp) as calculated
    FROM analytics_active_2m_decay_4m
    WHERE kpidate = DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY)
  ) lastday
  JOIN (
    SELECT
      SUM(active) AS total,
      SUM(if(language = 'en_GB' and (country_id != 1226 or country_id is NULL), active, 0)) as en_INT,
      SUM(IF(language = 'de_DE', active, 0)) AS de_DE,
      SUM(IF(language = 'en_GB' and country_id = 1226, active, 0)) AS UK,
      SUM(IF(language = 'es_ES', active, 0)) AS es_ES,
      SUM(IF(language = 'fr_FR', active, 0)) AS fr_FR,
      SUM(IF(language = 'it_IT', active, 0)) AS it_IT,
      SUM(IF(language = 'pl_PL', active, 0)) AS pl_PL,
      SUM(IF(language = 'en_US', active, 0)) AS en_US,
      SUM(if(language not in ('de_DE', 'en_GB', 'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), active, 0)) AS other,  
      MAX(stamp) as calculated
    FROM analytics_active_2m_decay_4m
    WHERE kpidate = DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)
  ) daybefore
  JOIN (
    SELECT 'yes' AS relative UNION SELECT 'no' AS relative
  ) growth

UNION

SELECT
  IF(relative = 'yes', "last week (%)", "last week"),
  IF(relative = 'yes', CAST((yesterday.total - lastweek.total) / lastweek.total * 100 AS DECIMAL(5, 2)), yesterday.total - lastweek.total),
  IF(relative = 'yes', CAST((yesterday.en_INT - lastweek.en_INT) / lastweek.total * 100 AS DECIMAL(5, 2)), yesterday.en_INT - lastweek.en_INT),
  IF(relative = 'yes', CAST((yesterday.de_DE - lastweek.de_DE) / lastweek.total * 100 AS DECIMAL(5, 2)), yesterday.de_DE - lastweek.de_DE),
  IF(relative = 'yes', CAST((yesterday.UK - lastweek.UK) / lastweek.total * 100 AS DECIMAL(5, 2)), yesterday.UK - lastweek.UK),
  IF(relative = 'yes', CAST((yesterday.es_ES - lastweek.es_ES) / lastweek.total * 100 AS DECIMAL(5, 2)), yesterday.es_ES - lastweek.es_ES),
  IF(relative = 'yes', CAST((yesterday.fr_FR - lastweek.fr_FR) / lastweek.total * 100 AS DECIMAL(5, 2)), yesterday.fr_FR - lastweek.fr_FR),
  IF(relative = 'yes', CAST((yesterday.it_IT - lastweek.it_IT) / lastweek.total * 100 AS DECIMAL(5, 2)), yesterday.it_IT - lastweek.it_IT),
  IF(relative = 'yes', CAST((yesterday.pl_PL - lastweek.pl_PL) / lastweek.total * 100 AS DECIMAL(5, 2)), yesterday.pl_PL - lastweek.pl_PL),
  IF(relative = 'yes', CAST((yesterday.en_US - lastweek.en_US) / lastweek.total * 100 AS DECIMAL(5, 2)), yesterday.en_US - lastweek.en_US),
  IF(relative = 'yes', CAST((yesterday.other - lastweek.other) / lastweek.total * 100 AS DECIMAL(5, 2)), yesterday.other - lastweek.other),
  lastweek.calculated
FROM (
    SELECT
      SUM(active) AS total,
      SUM(if(language = 'en_GB' and (country_id != 1226 or country_id is NULL), active, 0)) as en_INT,
      SUM(IF(language = 'de_DE', active, 0)) AS de_DE,
      SUM(IF(language = 'en_GB' and country_id = 1226, active, 0)) AS UK,
      SUM(IF(language = 'es_ES', active, 0)) AS es_ES,
      SUM(IF(language = 'fr_FR', active, 0)) AS fr_FR,
      SUM(IF(language = 'it_IT', active, 0)) AS it_IT,
      SUM(IF(language = 'pl_PL', active, 0)) AS pl_PL,
      SUM(IF(language = 'en_US', active, 0)) AS en_US,
      SUM(if(language not in ('de_DE', 'en_GB', 'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), active, 0)) AS other,  
      MAX(stamp) as calculated
    FROM analytics_active_2m_decay_4m
    WHERE kpidate = DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)
  ) yesterday
  JOIN (
    SELECT
      SUM(active) AS total,
      SUM(if(language = 'en_GB' and (country_id != 1226 or country_id is NULL), active, 0)) as en_INT,
      SUM(IF(language = 'de_DE', active, 0)) AS de_DE,
      SUM(IF(language = 'en_GB' and country_id = 1226, active, 0)) AS UK,
      SUM(IF(language = 'es_ES', active, 0)) AS es_ES,
      SUM(IF(language = 'fr_FR', active, 0)) AS fr_FR,
      SUM(IF(language = 'it_IT', active, 0)) AS it_IT,
      SUM(IF(language = 'pl_PL', active, 0)) AS pl_PL,
      SUM(IF(language = 'en_US', active, 0)) AS en_US,
      SUM(if(language not in ('de_DE', 'en_GB', 'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), active, 0)) AS other,  
      MAX(stamp) as calculated
    FROM analytics_active_2m_decay_4m
    WHERE kpidate = DATE_SUB(CURRENT_DATE(), INTERVAL 8 DAY)
  ) lastweek
  JOIN (
    SELECT 'yes' AS relative UNION SELECT 'no' AS relative
  ) growth

UNION

SELECT
  IF(relative = 'yes', "last week (%)", "last week"),
  IF(relative = 'yes', CAST((lastweek.total - weekbefore.total) / weekbefore.total * 100 AS DECIMAL(5, 2)), lastweek.total - weekbefore.total),
  IF(relative = 'yes', CAST((lastweek.en_INT - weekbefore.en_INT) / weekbefore.total * 100 AS DECIMAL(5, 2)), lastweek.en_INT - weekbefore.en_INT),
  IF(relative = 'yes', CAST((lastweek.de_DE - weekbefore.de_DE) / weekbefore.total * 100 AS DECIMAL(5, 2)), lastweek.de_DE - weekbefore.de_DE),
  IF(relative = 'yes', CAST((lastweek.UK - weekbefore.UK) / weekbefore.total * 100 AS DECIMAL(5, 2)), lastweek.UK - weekbefore.UK),
  IF(relative = 'yes', CAST((lastweek.es_ES - weekbefore.es_ES) / weekbefore.total * 100 AS DECIMAL(5, 2)), lastweek.es_ES - weekbefore.es_ES),
  IF(relative = 'yes', CAST((lastweek.fr_FR - weekbefore.fr_FR) / weekbefore.total * 100 AS DECIMAL(5, 2)), lastweek.fr_FR - weekbefore.fr_FR),
  IF(relative = 'yes', CAST((lastweek.it_IT - weekbefore.it_IT) / weekbefore.total * 100 AS DECIMAL(5, 2)), lastweek.it_IT - weekbefore.it_IT),
  IF(relative = 'yes', CAST((lastweek.pl_PL - weekbefore.pl_PL) / weekbefore.total * 100 AS DECIMAL(5, 2)), lastweek.pl_PL - weekbefore.pl_PL),
  IF(relative = 'yes', CAST((lastweek.en_US - weekbefore.en_US) / weekbefore.total * 100 AS DECIMAL(5, 2)), lastweek.en_US - weekbefore.en_US),
  IF(relative = 'yes', CAST((lastweek.other - weekbefore.other) / weekbefore.total * 100 AS DECIMAL(5, 2)), lastweek.other - weekbefore.other),
  weekbefore.calculated
FROM (
    SELECT
      SUM(active) AS total,
      SUM(if(language = 'en_GB' and (country_id != 1226 or country_id is NULL), active, 0)) as en_INT,
      SUM(IF(language = 'de_DE', active, 0)) AS de_DE,
      SUM(IF(language = 'en_GB' and country_id = 1226, active, 0)) AS UK,
      SUM(IF(language = 'es_ES', active, 0)) AS es_ES,
      SUM(IF(language = 'fr_FR', active, 0)) AS fr_FR,
      SUM(IF(language = 'it_IT', active, 0)) AS it_IT,
      SUM(IF(language = 'pl_PL', active, 0)) AS pl_PL,
      SUM(IF(language = 'en_US', active, 0)) AS en_US,
      SUM(if(language not in ('de_DE', 'en_GB', 'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), active, 0)) AS other,  
      MAX(stamp) as calculated
    FROM analytics_active_2m_decay_4m
    WHERE kpidate = DATE_SUB(CURRENT_DATE(), INTERVAL 8 DAY)
  ) lastweek
  JOIN (
    SELECT
      SUM(active) AS total,
      SUM(if(language = 'en_GB' and (country_id != 1226 or country_id is NULL), active, 0)) as en_INT,
      SUM(IF(language = 'de_DE', active, 0)) AS de_DE,
      SUM(IF(language = 'en_GB' and country_id = 1226, active, 0)) AS UK,
      SUM(IF(language = 'es_ES', active, 0)) AS es_ES,
      SUM(IF(language = 'fr_FR', active, 0)) AS fr_FR,
      SUM(IF(language = 'it_IT', active, 0)) AS it_IT,
      SUM(IF(language = 'pl_PL', active, 0)) AS pl_PL,
      SUM(IF(language = 'en_US', active, 0)) AS en_US,
      SUM(if(language not in ('de_DE', 'en_GB', 'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), active, 0)) AS other,  
      MAX(stamp) as calculated
    FROM analytics_active_2m_decay_4m
    WHERE kpidate = DATE_SUB(CURRENT_DATE(), INTERVAL 15 DAY)
  ) weekbefore
  JOIN (
    SELECT 'yes' AS relative UNION SELECT 'no' AS relative
  ) growth
;