SELECT
  CONCAT('https://act.wemove.eu/campaigns/', speakout_id) AS URL,
  civicrm_camp_id AS CiviCRM_Campaign_ID,
  speakout_title,
  language,
  total_signatures,
  new_people_signees,
  added AS all_people_that_came_in,
  added_UK UK_FR_IT_people_that_came,
  (added - added_UK) / (new_people_signees-added_UK) AS ratio_added,
  scheduled / (new_people_signees - added_UK) AS ratio_pending,
  opt_out / (new_people_signees - added_UK) AS ratio_opt_out,
  new_people_signees / total_signatures AS ratio_new,
  people_who_share / total_signatures AS ratio_share,
  stamp as last_calculated_on
FROM
  (SELECT
    civicrm_camp_id,
    max(speakout_title) speakout_title,
    max(speakout_id) speakout_id,
    max(language) language,
    SUM(IF(activity_type_id = 32 and status_id in (1, 4, 9), npeople, 0)) AS new_people_signees,
    SUM(IF(activity_type_id = 32 and status_id = 9 and country_id in (1226,1107,1076), npeople, 0)) AS added_UK,
    SUM(IF(activity_type_id = 32 and status_id = 9, npeople, 0)) AS added,
    SUM(IF(activity_type_id = 57 , npeople, 0)) AS joined,
    SUM(IF(activity_type_id = 32 and status_id = 4, npeople, 0)) AS opt_out,
    SUM(IF(activity_type_id = 32, npeople, 0)) AS total_signatures,
    SUM(IF(activity_type_id = 32 and status_id = 1, npeople, 0)) AS scheduled,
    SUM(IF(activity_type_id = 54, npeople, 0)) AS people_who_share,
    MAX(stamp) stamp
  FROM
    analytics_petitions_total
  GROUP BY civicrm_camp_id) AS aggregate
ORDER BY language, total_signatures DESC;
