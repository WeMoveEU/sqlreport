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
  SUM(if(language not IN ('de_DE', 'en_GB', 'es_ES', 'fr_FR', 'it_IT', 'en_US', 'pl_PL'), active, 0)) AS other,  
  MAX(stamp) AS calculated,
  '00' AS prio
FROM analytics_active_2m_decay_4m
WHERE kpidate = DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)

UNION

SELECT
  IF(relative, "last day (%)", "last day"),
  IF(relative, CAST((yesterday.total - lastday.total) / lastday.total * 100 AS DECIMAL(5, 2)), yesterday.total - lastday.total),
  IF(relative, CAST((yesterday.en_INT - lastday.en_INT) / lastday.en_INT * 100 AS DECIMAL(5, 2)), yesterday.en_INT - lastday.en_INT),
  IF(relative, CAST((yesterday.de_DE - lastday.de_DE) / lastday.de_DE * 100 AS DECIMAL(5, 2)), yesterday.de_DE - lastday.de_DE),
  IF(relative, CAST((yesterday.UK - lastday.UK) / lastday.UK * 100 AS DECIMAL(5, 2)), yesterday.UK - lastday.UK),
  IF(relative, CAST((yesterday.es_ES - lastday.es_ES) / lastday.es_ES * 100 AS DECIMAL(5, 2)), yesterday.es_ES - lastday.es_ES),
  IF(relative, CAST((yesterday.fr_FR - lastday.fr_FR) / lastday.fr_FR * 100 AS DECIMAL(5, 2)), yesterday.fr_FR - lastday.fr_FR),
  IF(relative, CAST((yesterday.it_IT - lastday.it_IT) / lastday.it_IT * 100 AS DECIMAL(5, 2)), yesterday.it_IT - lastday.it_IT),
  IF(relative, CAST((yesterday.pl_PL - lastday.pl_PL) / lastday.pl_PL * 100 AS DECIMAL(5, 2)), yesterday.pl_PL - lastday.pl_PL),
  IF(relative, CAST((yesterday.en_US - lastday.en_US) / lastday.en_US * 100 AS DECIMAL(5, 2)), yesterday.en_US - lastday.en_US),
  IF(relative, CAST((yesterday.other - lastday.other) / lastday.other * 100 AS DECIMAL(5, 2)), yesterday.other - lastday.other),
  lastday.calculated,
  CONCAT(relative, '1')
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
    SELECT 0 AS relative UNION SELECT 1 AS relative
  ) growth

UNION

SELECT
  IF(relative, "day before (%)", "day before"),
  IF(relative, CAST((lastday.total - daybefore.total) / daybefore.total * 100 AS DECIMAL(5, 2)), lastday.total - daybefore.total),
  IF(relative, CAST((lastday.en_INT - daybefore.en_INT) / daybefore.en_INT * 100 AS DECIMAL(5, 2)), lastday.en_INT - daybefore.en_INT),
  IF(relative, CAST((lastday.de_DE - daybefore.de_DE) / daybefore.de_DE * 100 AS DECIMAL(5, 2)), lastday.de_DE - daybefore.de_DE),
  IF(relative, CAST((lastday.UK - daybefore.UK) / daybefore.UK * 100 AS DECIMAL(5, 2)), lastday.UK - daybefore.UK),
  IF(relative, CAST((lastday.es_ES - daybefore.es_ES) / daybefore.es_ES * 100 AS DECIMAL(5, 2)), lastday.es_ES - daybefore.es_ES),
  IF(relative, CAST((lastday.fr_FR - daybefore.fr_FR) / daybefore.fr_FR * 100 AS DECIMAL(5, 2)), lastday.fr_FR - daybefore.fr_FR),
  IF(relative, CAST((lastday.it_IT - daybefore.it_IT) / daybefore.it_IT * 100 AS DECIMAL(5, 2)), lastday.it_IT - daybefore.it_IT),
  IF(relative, CAST((lastday.pl_PL - daybefore.pl_PL) / daybefore.pl_PL * 100 AS DECIMAL(5, 2)), lastday.pl_PL - daybefore.pl_PL),
  IF(relative, CAST((lastday.en_US - daybefore.en_US) / daybefore.en_US * 100 AS DECIMAL(5, 2)), lastday.en_US - daybefore.en_US),
  IF(relative, CAST((lastday.other - daybefore.other) / daybefore.other * 100 AS DECIMAL(5, 2)), lastday.other - daybefore.other),
  daybefore.calculated,
  CONCAT(relative, '2')
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
    SELECT 0 AS relative UNION SELECT 1 AS relative
  ) growth

UNION

SELECT
  IF(relative, "last week (%)", "last week"),
  IF(relative, CAST((yesterday.total - lastweek.total) / lastweek.total * 100 AS DECIMAL(5, 2)), yesterday.total - lastweek.total),
  IF(relative, CAST((yesterday.en_INT - lastweek.en_INT) / lastweek.en_INT * 100 AS DECIMAL(5, 2)), yesterday.en_INT - lastweek.en_INT),
  IF(relative, CAST((yesterday.de_DE - lastweek.de_DE) / lastweek.de_DE * 100 AS DECIMAL(5, 2)), yesterday.de_DE - lastweek.de_DE),
  IF(relative, CAST((yesterday.UK - lastweek.UK) / lastweek.UK * 100 AS DECIMAL(5, 2)), yesterday.UK - lastweek.UK),
  IF(relative, CAST((yesterday.es_ES - lastweek.es_ES) / lastweek.es_ES * 100 AS DECIMAL(5, 2)), yesterday.es_ES - lastweek.es_ES),
  IF(relative, CAST((yesterday.fr_FR - lastweek.fr_FR) / lastweek.fr_FR * 100 AS DECIMAL(5, 2)), yesterday.fr_FR - lastweek.fr_FR),
  IF(relative, CAST((yesterday.it_IT - lastweek.it_IT) / lastweek.it_IT * 100 AS DECIMAL(5, 2)), yesterday.it_IT - lastweek.it_IT),
  IF(relative, CAST((yesterday.pl_PL - lastweek.pl_PL) / lastweek.pl_PL * 100 AS DECIMAL(5, 2)), yesterday.pl_PL - lastweek.pl_PL),
  IF(relative, CAST((yesterday.en_US - lastweek.en_US) / lastweek.en_US * 100 AS DECIMAL(5, 2)), yesterday.en_US - lastweek.en_US),
  IF(relative, CAST((yesterday.other - lastweek.other) / lastweek.other * 100 AS DECIMAL(5, 2)), yesterday.other - lastweek.other),
  lastweek.calculated,
  CONCAT(relative, '3')
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
    SELECT 0 AS relative UNION SELECT 1 AS relative
  ) growth

UNION

SELECT
  IF(relative, "week before (%)", "week before"),
  IF(relative, CAST((lastweek.total - weekbefore.total) / weekbefore.total * 100 AS DECIMAL(5, 2)), lastweek.total - weekbefore.total),
  IF(relative, CAST((lastweek.en_INT - weekbefore.en_INT) / weekbefore.en_INT * 100 AS DECIMAL(5, 2)), lastweek.en_INT - weekbefore.en_INT),
  IF(relative, CAST((lastweek.de_DE - weekbefore.de_DE) / weekbefore.de_DE * 100 AS DECIMAL(5, 2)), lastweek.de_DE - weekbefore.de_DE),
  IF(relative, CAST((lastweek.UK - weekbefore.UK) / weekbefore.UK * 100 AS DECIMAL(5, 2)), lastweek.UK - weekbefore.UK),
  IF(relative, CAST((lastweek.es_ES - weekbefore.es_ES) / weekbefore.es_ES * 100 AS DECIMAL(5, 2)), lastweek.es_ES - weekbefore.es_ES),
  IF(relative, CAST((lastweek.fr_FR - weekbefore.fr_FR) / weekbefore.fr_FR * 100 AS DECIMAL(5, 2)), lastweek.fr_FR - weekbefore.fr_FR),
  IF(relative, CAST((lastweek.it_IT - weekbefore.it_IT) / weekbefore.it_IT * 100 AS DECIMAL(5, 2)), lastweek.it_IT - weekbefore.it_IT),
  IF(relative, CAST((lastweek.pl_PL - weekbefore.pl_PL) / weekbefore.pl_PL * 100 AS DECIMAL(5, 2)), lastweek.pl_PL - weekbefore.pl_PL),
  IF(relative, CAST((lastweek.en_US - weekbefore.en_US) / weekbefore.en_US * 100 AS DECIMAL(5, 2)), lastweek.en_US - weekbefore.en_US),
  IF(relative, CAST((lastweek.other - weekbefore.other) / weekbefore.other * 100 AS DECIMAL(5, 2)), lastweek.other - weekbefore.other),
  weekbefore.calculated,
  CONCAT(relative, '4')
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
    SELECT 0 AS relative UNION SELECT 1 AS relative
  ) growth

UNION

SELECT
  IF(relative, "last month (%)", "last month"),
  IF(relative, CAST((yesterday.total - lastmonth.total) / lastmonth.total * 100 AS DECIMAL(5, 2)), yesterday.total - lastmonth.total),
  IF(relative, CAST((yesterday.en_INT - lastmonth.en_INT) / lastmonth.en_INT * 100 AS DECIMAL(5, 2)), yesterday.en_INT - lastmonth.en_INT),
  IF(relative, CAST((yesterday.de_DE - lastmonth.de_DE) / lastmonth.de_DE * 100 AS DECIMAL(5, 2)), yesterday.de_DE - lastmonth.de_DE),
  IF(relative, CAST((yesterday.UK - lastmonth.UK) / lastmonth.UK * 100 AS DECIMAL(5, 2)), yesterday.UK - lastmonth.UK),
  IF(relative, CAST((yesterday.es_ES - lastmonth.es_ES) / lastmonth.es_ES * 100 AS DECIMAL(5, 2)), yesterday.es_ES - lastmonth.es_ES),
  IF(relative, CAST((yesterday.fr_FR - lastmonth.fr_FR) / lastmonth.fr_FR * 100 AS DECIMAL(5, 2)), yesterday.fr_FR - lastmonth.fr_FR),
  IF(relative, CAST((yesterday.it_IT - lastmonth.it_IT) / lastmonth.it_IT * 100 AS DECIMAL(5, 2)), yesterday.it_IT - lastmonth.it_IT),
  IF(relative, CAST((yesterday.pl_PL - lastmonth.pl_PL) / lastmonth.pl_PL * 100 AS DECIMAL(5, 2)), yesterday.pl_PL - lastmonth.pl_PL),
  IF(relative, CAST((yesterday.en_US - lastmonth.en_US) / lastmonth.en_US * 100 AS DECIMAL(5, 2)), yesterday.en_US - lastmonth.en_US),
  IF(relative, CAST((yesterday.other - lastmonth.other) / lastmonth.other * 100 AS DECIMAL(5, 2)), yesterday.other - lastmonth.other),
  lastmonth.calculated,
  CONCAT(relative, '5')
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
    WHERE kpidate = DATE_SUB(CURRENT_DATE(), INTERVAL 31 DAY)
  ) lastmonth
  JOIN (
    SELECT 0 AS relative UNION SELECT 1 AS relative
  ) growth

UNION

SELECT
  IF(relative, "month before (%)", "month before"),
  IF(relative, CAST((lastmonth.total - monthbefore.total) / monthbefore.total * 100 AS DECIMAL(5, 2)), lastmonth.total - monthbefore.total),
  IF(relative, CAST((lastmonth.en_INT - monthbefore.en_INT) / monthbefore.en_INT * 100 AS DECIMAL(5, 2)), lastmonth.en_INT - monthbefore.en_INT),
  IF(relative, CAST((lastmonth.de_DE - monthbefore.de_DE) / monthbefore.de_DE * 100 AS DECIMAL(5, 2)), lastmonth.de_DE - monthbefore.de_DE),
  IF(relative, CAST((lastmonth.UK - monthbefore.UK) / monthbefore.UK * 100 AS DECIMAL(5, 2)), lastmonth.UK - monthbefore.UK),
  IF(relative, CAST((lastmonth.es_ES - monthbefore.es_ES) / monthbefore.es_ES * 100 AS DECIMAL(5, 2)), lastmonth.es_ES - monthbefore.es_ES),
  IF(relative, CAST((lastmonth.fr_FR - monthbefore.fr_FR) / monthbefore.fr_FR * 100 AS DECIMAL(5, 2)), lastmonth.fr_FR - monthbefore.fr_FR),
  IF(relative, CAST((lastmonth.it_IT - monthbefore.it_IT) / monthbefore.it_IT * 100 AS DECIMAL(5, 2)), lastmonth.it_IT - monthbefore.it_IT),
  IF(relative, CAST((lastmonth.pl_PL - monthbefore.pl_PL) / monthbefore.pl_PL * 100 AS DECIMAL(5, 2)), lastmonth.pl_PL - monthbefore.pl_PL),
  IF(relative, CAST((lastmonth.en_US - monthbefore.en_US) / monthbefore.en_US * 100 AS DECIMAL(5, 2)), lastmonth.en_US - monthbefore.en_US),
  IF(relative, CAST((lastmonth.other - monthbefore.other) / monthbefore.other * 100 AS DECIMAL(5, 2)), lastmonth.other - monthbefore.other),
  monthbefore.calculated,
  CONCAT(relative, '6')
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
    WHERE kpidate = DATE_SUB(CURRENT_DATE(), INTERVAL 31 DAY)
  ) lastmonth
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
    WHERE kpidate = DATE_SUB(CURRENT_DATE(), INTERVAL 61 DAY)
  ) monthbefore
  JOIN (
    SELECT 0 AS relative UNION SELECT 1 AS relative
  ) growth

ORDER BY prio ASC
;
