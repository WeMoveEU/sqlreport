-- Active member growth per language
UPDATE 
  analytics_goals_dates goal
  JOIN (
    SELECT
        scope, `begin`, `end`, 100 * (SUM(e.active) - SUM(b.active)) / SUM(b.active) AS growth
      FROM analytics_goals_dates
      JOIN (
        SELECT kpidate, language, SUM(active) AS active
        FROM analytics_active_3m
        GROUP BY kpidate, language
      ) b ON b.language=scope AND b.kpidate=`begin`
      JOIN (
        SELECT kpidate, language, SUM(active) AS active
        FROM analytics_active_3m
        GROUP BY kpidate, language
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
UPDATE analytics_goals_dates g2
  JOIN (SELECT
    g.scope, g.begin, g.end, sum(cr.total_amount) growth
  FROM civicrm_contribution cr
    JOIN analytics_goals_dates g
      ON g.metric = 'recurring_donations' AND (cr.receive_date >= g.begin AND cr.receive_date <= g.end)
    JOIN civicrm_contact c ON c.id = cr.contact_id AND c.preferred_language COLLATE utf8_unicode_ci = g.scope
  WHERE cr.contribution_recur_id IS NOT NULL AND contribution_status_id = 1 AND is_test = 0
  GROUP BY g.scope, g.begin, g.end) t ON g2.scope = t.scope AND g2.begin = t.begin AND g2.end = t.end
SET g2.actual = t.growth
WHERE g2.metric = 'recurring_donations';

-- Recurring donations per organization
UPDATE analytics_goals_dates g2
  JOIN (SELECT
    g.begin, g.end, sum(cr.total_amount) growth
  FROM civicrm_contribution cr
    JOIN analytics_goals_dates g
      ON g.metric = 'recurring_donations' AND (cr.receive_date >= g.begin AND cr.receive_date <= g.end)
  WHERE g.scope = 'organization' AND cr.contribution_recur_id IS NOT NULL AND contribution_status_id = 1 AND is_test = 0
  GROUP BY g.begin, g.end) t ON g2.begin = t.begin AND g2.end = t.end
SET g2.actual = t.growth
WHERE g2.metric = 'recurring_donations' AND g2.scope = 'organization';

-- Member growth per languages
UPDATE analytics_goals_dates g2
  JOIN (SELECT
    pre.language, pre.begin, round((sum_post - sum_pre) / sum_pre * 100, 0) growth
  FROM
    (SELECT
      m.language, g.`begin`, SUM(m.number_added) - SUM(m.number_removed) sum_pre
    FROM analytics_member_metrics m
      JOIN analytics_goals_dates g ON m.language = g.scope
    WHERE g.metric = 'member_growth' AND m.added_date < g.`begin`
    GROUP BY m.language, g.`begin`) pre
    JOIN
    (SELECT
      m.language, g.`begin`, SUM(m.number_added) - SUM(m.number_removed) sum_post
    FROM analytics_member_metrics m
      JOIN analytics_goals_dates g ON m.language = g.scope
    WHERE g.metric = 'member_growth' AND m.added_date < g.`end`
    GROUP BY m.language, g.`begin`) post
      ON post.language = pre.language AND post.begin = pre.begin) t
    ON g2.scope = t.language AND g2.begin = t.begin
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
