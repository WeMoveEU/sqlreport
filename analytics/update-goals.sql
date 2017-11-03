SELECT @gb := 1226;

-- Active member count per language
UPDATE 
  analytics_goals_dates goal
  JOIN (
    SELECT
      scope, `end`, SUM(e.active) AS nb
    FROM analytics_goals_dates
    JOIN (
      SELECT 
        kpidate, 
        IF(language='en_GB' AND country_id!=@gb, 'en_INT', language) AS segment, 
        SUM(active) AS active
      FROM analytics_active_3m
      GROUP BY kpidate, segment
    ) e ON e.segment=scope AND e.kpidate=`end` 
    WHERE metric = 'active_member_growth'
    GROUP BY scope, `end`
  ) val ON val.scope=goal.scope AND val.end=goal.end
  SET goal.actual=val.nb
  WHERE goal.metric='active_member_count';

-- Active member count per organization
UPDATE 
  analytics_goals_dates goal
  JOIN (
    SELECT
      scope, `end`, SUM(e.active) AS nb
    FROM analytics_goals_dates
    JOIN (
      SELECT kpidate, SUM(active) AS active
      FROM analytics_active_3m
      GROUP BY kpidate
    ) e ON scope='organization' AND e.kpidate=`end`
    WHERE metric = 'active_member_growth'
    GROUP BY scope, `end`
  ) val ON val.scope=goal.scope AND val.end=goal.end
  SET goal.actual=val.nb
  WHERE goal.metric='active_member_count';

-- Active member growth per language
UPDATE 
  analytics_goals_dates goal
  JOIN (
    SELECT
        scope, `begin`, `end`, 100 * (SUM(e.active) - SUM(b.active)) / SUM(b.active) AS growth
      FROM analytics_goals_dates
      JOIN (
        SELECT
          kpidate, 
          IF(language='en_GB' AND country_id!=@gb, 'en_INT', language) AS segment, 
          SUM(active) AS active
        FROM analytics_active_3m
        GROUP BY kpidate, segment
      ) b ON b.language=scope AND b.kpidate=`begin`
      JOIN (
        SELECT
          kpidate, 
          IF(language='en_GB' AND country_id!=@gb, 'en_INT', language) AS segment, 
          SUM(active) AS active
        FROM analytics_active_3m
        GROUP BY kpidate, segment
      ) e ON e.language=scope AND e.kpidate=`end`
      WHERE metric = 'active_member_growth'
      GROUP BY scope, `begin`, `end`
  ) val ON val.scope=goal.scope AND val.begin=goal.begin AND val.end=goal.end
  SET goal.actual=val.growth
  WHERE goal.metric='active_member_growth';

-- Active member growth per organization
UPDATE
  analytics_goals_dates goal
  JOIN (
    SELECT
      `begin`, `end`, ROUND(100 * (SUM(e.active) - SUM(b.active)) / SUM(b.active)) AS growth
    FROM analytics_goals_dates
      JOIN (
        SELECT
          kpidate, SUM(active) AS active
        FROM analytics_active_3m
        GROUP BY kpidate
      ) b ON b.kpidate = `begin`
      JOIN (
        SELECT
          kpidate, SUM(active) AS active
        FROM analytics_active_3m
        GROUP BY kpidate
      ) e ON e.kpidate = `end`
    WHERE metric = 'active_member_growth'
    GROUP BY `begin`, `end`
 ) val ON val.begin = goal.begin AND val.end = goal.end
SET goal.actual = val.growth
WHERE goal.metric = 'active_member_growth' AND goal.scope = 'organization';

-- Recurring donations per languages
-- UPDATE analytics_goals_dates g2
--   JOIN (SELECT
--     g.scope, g.begin, g.end, sum(cr.total_amount) growth
--   FROM civicrm_contribution cr
--     JOIN analytics_goals_dates g
--       ON g.metric = 'recurring_donations' AND (cr.receive_date >= g.begin AND cr.receive_date <= g.end)
--     JOIN civicrm_contact c ON c.id = cr.contact_id AND c.preferred_language COLLATE utf8_unicode_ci = g.scope
--   WHERE cr.contribution_recur_id IS NOT NULL AND contribution_status_id = 1 AND is_test = 0
--   GROUP BY g.scope, g.begin, g.end) t ON g2.scope = t.scope AND g2.begin = t.begin AND g2.end = t.end
-- SET g2.actual = t.growth
-- WHERE g2.metric = 'recurring_donations';

-- Recurring donations per organization
UPDATE analytics_goals_dates g2
  JOIN (
    SELECT
      g.begin, g.end, sum(cr.total_amount) growth
    FROM civicrm_contribution cr
    JOIN analytics_goals_dates g
        ON g.metric = 'recurring_donations' AND (cr.receive_date >= g.begin AND cr.receive_date <= g.end)
    WHERE g.scope = 'organization' AND cr.contribution_recur_id IS NOT NULL AND contribution_status_id = 1 AND is_test = 0
    GROUP BY g.begin, g.end
  ) t ON g2.begin = t.begin AND g2.end = t.end
SET g2.actual = t.growth
WHERE g2.metric = 'recurring_donations' AND g2.scope = 'organization';

-- Member count per language
UPDATE analytics_goals_dates g2
  JOIN (
    SELECT
      IF(language='en_GB' AND country_id!=@gb, 'en_INT', language) AS segment, 
      g.`end`, 
      SUM(m.number_added) - SUM(m.number_removed) AS nb_members
    FROM analytics_member_metrics m
    JOIN analytics_goals_dates g 
      ON IF(language='en_GB' AND country_id!=@gb, 'en_INT', language) = g.scope AND m.added_date <= g.`end`
    WHERE g.metric = 'member_count'
    GROUP BY segment, g.`end`
  ) t
  ON g2.scope = t.segment AND g2.end = t.end
SET g2.actual = t.nb_members
WHERE g2.metric = 'member_count';

-- Member count per organization
UPDATE analytics_goals_dates g2
  JOIN (
    SELECT
      g.scope, g.`end`, SUM(m.number_added) - SUM(m.number_removed) AS nb_members
    FROM analytics_member_metrics m
    JOIN analytics_goals_dates g ON g.scope='organization' AND m.added_date <= g.`end`
    WHERE g.metric = 'member_count'
    GROUP BY g.`end`
  ) t
  ON g2.scope = 'organization' AND g2.end = t.end
SET g2.actual = t.nb_members
WHERE g2.metric = 'member_count';

-- Member growth per language
UPDATE analytics_goals_dates g2
  JOIN (
    SELECT
      pre.segment, pre.begin, round((sum_post - sum_pre) / sum_pre * 100, 0) growth
    FROM
      (SELECT
        IF(language='en_GB' AND country_id!=@gb, 'en_INT', language) AS segment, 
        g.`begin`, 
        SUM(m.number_added) - SUM(m.number_removed) sum_pre
      FROM analytics_member_metrics m
      JOIN analytics_goals_dates g
        ON IF(language='en_GB' AND country_id!=@gb, 'en_INT', language) = g.scope
      WHERE g.metric = 'member_growth' AND m.added_date < g.`begin`
      GROUP BY segment, g.`begin`) pre
    JOIN
      (SELECT
        IF(language='en_GB' AND country_id!=@gb, 'en_INT', language) AS segment, 
        g.`begin`, 
        SUM(m.number_added) - SUM(m.number_removed) sum_post
      FROM analytics_member_metrics m
      JOIN analytics_goals_dates g 
        ON IF(language='en_GB' AND country_id!=@gb, 'en_INT', language) = g.scope
      WHERE g.metric = 'member_growth' AND m.added_date < g.`end`
      GROUP BY segment, g.`begin`) post
    ON post.segment = pre.segment AND post.begin = pre.begin
  ) t
  ON g2.scope = t.segment AND g2.begin = t.begin
SET g2.actual = t.growth
WHERE g2.metric = 'member_growth';

-- Member growth per organization
UPDATE analytics_goals_dates g2
  JOIN (SELECT
    pre.begin, round((sum_post - sum_pre) / sum_pre * 100, 0) growth
  FROM
    (SELECT
      g.`begin`, SUM(m.number_added) - SUM(m.number_removed) sum_pre
    FROM analytics_member_metrics m, analytics_goals_dates g
    WHERE g.metric = 'member_growth' AND g.scope = 'organization' AND m.added_date < g.`begin`
    GROUP BY g.`begin`) pre
    JOIN
    (SELECT
      g.`begin`, SUM(m.number_added) - SUM(m.number_removed) sum_post
    FROM analytics_member_metrics m, analytics_goals_dates g
    WHERE g.metric = 'member_growth' AND g.scope = 'organization' AND m.added_date < g.`end`
    GROUP BY g.`begin`) post ON post.begin = pre.begin) t
    ON g2.begin = t.begin
SET g2.actual = t.growth
WHERE g2.metric = 'member_growth' AND g2.scope = 'organization';
