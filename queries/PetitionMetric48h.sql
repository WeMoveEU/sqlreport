/* now display the actual metrics !!! */

/*
set @share:= 54;
set @signature:=32;
set @created_pet:=55;
set @leave:=56;
set @join:=57;

set @scheduled=1;
set @completed=2;
set @optout=4;
set @completed_new=9; 
set @member_group=42;

set @UK=1226;
set @FR=1076;
set @IT=1107;

*/
 
SELECT 
    CONCAT('https://act.wemove.eu/campaigns/',
            speakout_id) AS URL,
    civicrm_camp_id AS CiviCRM_Campaign_ID,
    speakout_title,
    language,
     total_signatures,
    new_people_signees,
   added AS all_people_that_came_in,
   added_UK UK_FR_IT_people_that_came,
--    joined as people_that_actually_came_in_2nd_calculation,
    (added - added_UK) / (new_people_signees-added_UK) AS ratio_added,
    scheduled / (new_people_signees - added_UK) AS ratio_pending,
    opt_out / (new_people_signees - added_UK) AS ratio_opt_out,
    new_people_signees / total_signatures AS ratio_new,
    people_who_share / total_signatures AS ratio_share,
	stamp as last_calculated_on	
FROM
    (SELECT 
        civicrm_camp_id,
            speakout_title,
            speakout_id,
            language,
      SUM(IF(activity_type_id = 32 and status_id in (1, 4, 9), npeople, 0)) AS new_people_signees,
      SUM(IF(activity_type_id = 32 and status_id = 9 and country_id  in (1226,1107,1076), npeople, 0)) AS added_UK,
      SUM(IF(activity_type_id = 32 and status_id = 9, npeople, 0)) AS added,
              SUM(IF(activity_type_id = 57 , npeople, 0)) AS joined,
--  LEAVE - SUM(IF(activity_type_id = 'Removed' AND is_opt_out = 0, npeople, 0)) AS removed,
            SUM(IF(activity_type_id = 32 and status_id = 4, npeople, 0)) AS opt_out,
            SUM(IF(activity_type_id = 32, npeople, 0)) AS total_signatures,
            SUM(IF(activity_type_id = 32 and status_id = 1, npeople, 0)) AS scheduled,
            SUM(IF(activity_type_id = 54, npeople, 0)) AS people_who_share,
                        
 /*           SUM(IF(activity_type_id = @signature and status_id in (@scheduled, @optout,@completed_new), npeople, 0)) AS new_people_signees,
            SUM(IF(activity_type_id = @signature and status_id = @completed_new, npeople, 0)) AS added,
--                      SUM(IF(activity_type_id = @join , npeople, 0)) AS joined,

--  LEAVE - SUM(IF(activity_type_id = 'Removed' AND is_opt_out = 0, npeople, 0)) AS removed,
            SUM(IF(activity_type_id = @signature and status_id = @optout, npeople, 0)) AS opt_out,
            SUM(IF(activity_type_id = @signature, npeople, 0)) AS total_signatures,
            SUM(IF(activity_type_id = @signature and status_id = @scheduled, npeople, 0)) AS scheduled,
            SUM(IF(activity_type_id = @share, npeople, 0)) AS people_who_share,
            */
            
            
      stamp
    FROM
        analytics_petitions_48h
    GROUP BY civicrm_camp_id) AS aggregate
    where total_signatures > 10 
ORDER BY language,  total_signatures desc;

    
    
    