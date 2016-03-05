/* now display the actual metrics !!! */

/*CONCAT('https://act.wemove.eu/campaigns/',
            kampagne.speakout_id) AS URL, */
 
SELECT 
    CONCAT('https://act.wemove.eu/campaigns/',
            speakout_id) AS URL,
    civicrm_camp_id AS CiviCRM_Campaign_ID,
    speakout_title,
    language,
    new_people_signees,
    added AS people_that_actually_came_in,
    added / new_people_signees AS ratio_added,
    pending / new_people_signees AS ratio_pending,
    opt_out / new_people_signees AS ratio_opt_out,
    total_signatures,
    new_people_signees / total_signatures AS ratio_new,
    added / total_signatures AS ratio_actually_added,
    people_who_share / total_signatures AS ratio_share,
	stamp as last_calculated_on	
FROM
    (SELECT 
        civicrm_camp_id,
            speakout_title,
            speakout_id,
            language,
            SUM(IF(activity IN ('Added' , 'Pending', 'Removed'), npeople, 0)) AS new_people_signees,
            SUM(IF(activity = 'Added' AND is_opt_out = 0, npeople, 0)) AS added,
            SUM(IF(activity = 'Pending' AND is_opt_out = 0, npeople, 0)) AS pending,
            SUM(IF(activity = 'Removed' AND is_opt_out = 0, npeople, 0)) AS removed,
            SUM(IF(is_opt_out = 1, npeople, 0)) AS opt_out,
            SUM(IF(activity = 'Petition signature', npeople, 0)) AS total_signatures,
            SUM(IF(activity = 'Petition signature'
                AND status = 'Completed', npeople, 0)) AS completed_signatures,
            SUM(IF(activity = 'Petition signature'
                AND status = 'Scheduled', npeople, 0)) AS scheduled_signatures,
            SUM(IF(activity = 'Petition signature'
                AND status = 'Opt-out', npeople, 0)) AS opted_out_signatures,
            SUM(IF(activity = 'share', npeople, 0)) AS people_who_share,
      stamp
    FROM
        analytics_petitions_1week
    GROUP BY civicrm_camp_id) AS aggregate
    where total_signatures > 20 
ORDER BY language,  total_signatures desc;

    
    
    