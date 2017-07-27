-- Active member growth

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
  WHERE goal.metric='active_member_growth'
