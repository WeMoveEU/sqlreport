
# Select limit = 3 für die besten 3 Länder. 
;

set @start_date :=  DATE_ADD(now(), INTERVAL - 1 WEEK);
set @end_date := now() ;
-- set @end_date := now();


/* search by sources of people 

gives wrong data for people not becoming members on the first campaign they join. 

country is still missing
*/

insert into analytics_petitions_1week
(civicrm_camp_id, activity, is_opt_out, npeople)
SELECT 
        civicrm_camp_id as civicrm_camp_id,
            status AS activity,
            is_opt_out AS is_opt_out,
            COUNT(*) AS npeople
    FROM
	civicrm_contact c 
    JOIN civicrm_group_contact g ON g.contact_id = c.id AND g.group_id = 42
        AND c.is_deleted = 0

/* DATe */
--        and c.created_date >= '2016-02-19 12:00'
			and  c.created_date >=  @start_date
and  c.created_date  <=   @end_date
            
-- DATE_ADD(now(), INTERVAL - 1 WEEK)       
    JOIN (SELECT 
        CONCAT('speakout petition ', CAST(camp.external_identifier AS CHAR (10))) COLLATE utf8_unicode_ci AS source_string,
            camp.external_identifier AS speakout_id,
            camp.name AS name,
            camp.title AS title,
            camp.id AS civicrm_camp_id
    FROM
        civicrm_campaign AS camp) AS kampagne ON kampagne.source_string = c.source
    GROUP BY civicrm_camp_id , status , is_opt_out;

/* select by activity 
important: select distinct

country is not in there yet. 

Is really made sure it is about signatories, not signatures? 


*/


insert into analytics_petitions_1week
(civicrm_camp_id, activity, status, npeople)
SELECT 
    ca.civicrm_camp_id AS civicrm_camp_id,
    ca.stand AS activity,
    ca.status AS status,
    COUNT(*) AS npeople
FROM
    (SELECT DISTINCT
        civicrm_campaign.id AS civicrm_camp_id,
            civicrm_option_value.label AS stand,
            option_value_status.label AS status,
            c.id
    FROM
        civicrm_contact c
    JOIN civicrm_activity_contact ON civicrm_activity_contact.contact_id = c.id
    JOIN civicrm_activity ON civicrm_activity.id = civicrm_activity_contact.activity_id
    JOIN civicrm_campaign ON civicrm_campaign.id = civicrm_activity.campaign_id
    JOIN civicrm_option_group ON civicrm_option_group.name = 'activity_type'
    JOIN civicrm_option_value ON civicrm_option_value.option_group_id = civicrm_option_group.id
        AND civicrm_activity.activity_type_id = civicrm_option_value.value
    JOIN civicrm_option_group AS option_group_status ON option_group_status.name = 'activity_status'
    JOIN civicrm_option_value AS option_value_status ON option_value_status.option_group_id = option_group_status.id
        AND civicrm_activity.status_id = option_value_status.value
    WHERE
        civicrm_option_value.label IN ('Petition Signature' , 'share')
        /* date */
--        and  civicrm_activity.activity_date_time >= '2016-02-19 12:00' 
and  civicrm_activity.activity_date_time >=   @start_date
and  civicrm_activity.activity_date_time <=   @end_date

        ) AS ca
GROUP BY civicrm_camp_id , stand , status
;


/* now add speakout_id, speakout_name, language */

SET SQL_SAFE_UPDATES=0;


UPDATE analytics_petitions_1week
        JOIN
    civicrm_campaign AS camp ON camp.id = analytics_petitions_1week.civicrm_camp_id
        JOIN
    civicrm_value_speakout_integration_2 speakout_integration ON camp.id = speakout_integration.entity_id 
SET 
    speakout_id = camp.external_identifier,
    speakout_name = camp.name,
    speakout_title = camp.title,
    language = speakout_integration.language_4
WHERE
    analytics_petitions_1week.civicrm_camp_id IS NOT NULL
;



/**********************************************************************************************************************/


set @start_date :=  DATE_ADD(now(), INTERVAL - 2 day);
set @end_date := now() ;
-- set @end_date := now();


/* search by sources of people 

gives wrong data for people not becoming members on the first campaign they join. 

country is still missing
*/

insert into analytics_petitions_48h
(civicrm_camp_id, activity, is_opt_out, npeople)
SELECT 
        civicrm_camp_id as civicrm_camp_id,
            status AS activity,
            is_opt_out AS is_opt_out,
            COUNT(*) AS npeople
    FROM
	civicrm_contact c 
    JOIN civicrm_group_contact g ON g.contact_id = c.id AND g.group_id = 42
        AND c.is_deleted = 0

/* DATe */
--        and c.created_date >= '2016-02-19 12:00'
			and  c.created_date >=  @start_date
and  c.created_date  <=   @end_date
            
-- DATE_ADD(now(), INTERVAL - 1 WEEK)       
    JOIN (SELECT 
        CONCAT('speakout petition ', CAST(camp.external_identifier AS CHAR (10))) COLLATE utf8_unicode_ci AS source_string,
            camp.external_identifier AS speakout_id,
            camp.name AS name,
            camp.title AS title,
            camp.id AS civicrm_camp_id
    FROM
        civicrm_campaign AS camp) AS kampagne ON kampagne.source_string = c.source
    GROUP BY civicrm_camp_id , status , is_opt_out;

/* select by activity 
important: select distinct

country is not in there yet. 

Is really made sure it is about signatories, not signatures? 


*/


insert into analytics_petitions_48h
(civicrm_camp_id, activity, status, npeople)
SELECT 
    ca.civicrm_camp_id AS civicrm_camp_id,
    ca.stand AS activity,
    ca.status AS status,
    COUNT(*) AS npeople
FROM
    (SELECT DISTINCT
        civicrm_campaign.id AS civicrm_camp_id,
            civicrm_option_value.label AS stand,
            option_value_status.label AS status,
            c.id
    FROM
        civicrm_contact c
    JOIN civicrm_activity_contact ON civicrm_activity_contact.contact_id = c.id
    JOIN civicrm_activity ON civicrm_activity.id = civicrm_activity_contact.activity_id
    JOIN civicrm_campaign ON civicrm_campaign.id = civicrm_activity.campaign_id
    JOIN civicrm_option_group ON civicrm_option_group.name = 'activity_type'
    JOIN civicrm_option_value ON civicrm_option_value.option_group_id = civicrm_option_group.id
        AND civicrm_activity.activity_type_id = civicrm_option_value.value
    JOIN civicrm_option_group AS option_group_status ON option_group_status.name = 'activity_status'
    JOIN civicrm_option_value AS option_value_status ON option_value_status.option_group_id = option_group_status.id
        AND civicrm_activity.status_id = option_value_status.value
    WHERE
        civicrm_option_value.label IN ('Petition Signature' , 'share')
        /* date */
--        and  civicrm_activity.activity_date_time >= '2016-02-19 12:00' 
and  civicrm_activity.activity_date_time >=   @start_date
and  civicrm_activity.activity_date_time <=   @end_date

        ) AS ca
GROUP BY civicrm_camp_id , stand , status
;


/* now add speakout_id, speakout_name, language */

SET SQL_SAFE_UPDATES=0;


UPDATE analytics_petitions_48h
        JOIN
    civicrm_campaign AS camp ON camp.id = analytics_petitions_48h.civicrm_camp_id
        JOIN
    civicrm_value_speakout_integration_2 speakout_integration ON camp.id = speakout_integration.entity_id 
SET 
    speakout_id = camp.external_identifier,
    speakout_name = camp.name,
    speakout_title = camp.title,
    language = speakout_integration.language_4
WHERE
    analytics_petitions_48h.civicrm_camp_id IS NOT NULL
;



