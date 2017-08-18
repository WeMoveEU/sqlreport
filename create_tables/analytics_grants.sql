
-- Query to set the privileges of the analytics user;

GRANT USAGE, SELECT ON wemove_47.* TO analytics@localhost;
GRANT USAGE, SELECT ON drupal_47.* TO analytics@localhost;

GRANT ALL ON wemove_47.ab_mailings TO analytics@localhost;
GRANT ALL ON wemove_47.analytics_active_1m TO analytics@localhost;
GRANT ALL ON wemove_47.analytics_active_2m_decay_4m TO analytics@localhost;
GRANT ALL ON wemove_47.analytics_active_3m TO analytics@localhost;
GRANT ALL ON wemove_47.analytics_calculation_times TO analytics@localhost;
GRANT ALL ON wemove_47.analytics_delta_t_h TO analytics@localhost;
GRANT ALL ON wemove_47.analytics_goals_dates TO analytics@localhost;
GRANT ALL ON wemove_47.analytics_kpidates TO analytics@localhost;
GRANT ALL ON wemove_47.analytics_mailing_counter_datetime TO analytics@localhost;
GRANT ALL ON wemove_47.analytics_member_metrics TO analytics@localhost;
GRANT ALL ON wemove_47.analytics_member_metrics_dt TO analytics@localhost;
GRANT ALL ON wemove_47.analytics_members_country_language TO analytics@localhost;
GRANT ALL ON wemove_47.analytics_petitions_1week TO analytics@localhost;
GRANT ALL ON wemove_47.analytics_petitions_48h TO analytics@localhost;
GRANT ALL ON wemove_47.analytics_petitions_total TO analytics@localhost;
GRANT ALL ON wemove_47.analytics_temp_mailing TO analytics@localhost;
GRANT ALL ON wemove_47.data_mailing_ab TO analytics@localhost;
GRANT ALL ON wemove_47.data_mailing_counter TO analytics@localhost;

GRANT EXECUTE ON FUNCTION wemove_47.analyticsMedianOriginalTimeStamp TO 'analytics'@'pirandello.wemove.eu';
GRANT EXECUTE ON FUNCTION wemove_47.analyticsMailjetMedianTimeStamp TO 'analytics'@'pirandello.wemove.eu';
