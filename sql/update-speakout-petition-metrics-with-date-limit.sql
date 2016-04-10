
# Select limit = 3 für die besten 3 Länder. 

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


insert into analytics_calculation_times
( calculation ) 
values ("before speakout petition kpis");


truncate table analytics_petitions_1week; 

truncate table analytics_petitions_total; 
truncate table analytics_petitions_48h; 



set @start_date :=  DATE_ADD(now(), INTERVAL - 1 WEEK);
set @end_date := now() ;


/* select by activity 
important: select distinct

country is not in there yet. 

Is really made sure it is about signatories, not signatures? 


*/


insert into analytics_petitions_1week
(civicrm_camp_id, activity_type_id, status_id, npeople)
SELECT 
    ca.civicrm_camp_id AS civicrm_camp_id,
    ca.activity_type_id AS activity_type_id,
    ca.status_id AS status_id,
    COUNT(*) AS npeople
FROM
    (SELECT DISTINCT
        civicrm_campaign.id AS civicrm_camp_id,
        activity.activity_type_id as activity_type_id,
        activity.status_id as status_id,
        contact.id 
    FROM
        civicrm_contact contact
    JOIN civicrm_activity_contact ON civicrm_activity_contact.contact_id = contact.id
    JOIN civicrm_activity activity ON activity.id = civicrm_activity_contact.activity_id 
    and activity.activity_type_id in (@share, @signature, @leave, @join)
	and  activity.activity_date_time >=   @start_date
	and  activity.activity_date_time <=   @end_date
    and activity.is_test=0
    JOIN civicrm_campaign ON civicrm_campaign.id = activity.campaign_id 
        ) AS ca
GROUP BY civicrm_camp_id , activity_type_id, status_id;

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
(civicrm_camp_id, activity_type_id, status_id, npeople)
SELECT 
    ca.civicrm_camp_id AS civicrm_camp_id,
    ca.activity_type_id AS activity_type_id,
    ca.status_id AS status_id,
    COUNT(*) AS npeople
FROM
    (SELECT DISTINCT
        civicrm_campaign.id AS civicrm_camp_id,
        activity.activity_type_id as activity_type_id,
        activity.status_id as status_id,
        contact.id 
    FROM
        civicrm_contact contact
    JOIN civicrm_activity_contact ON civicrm_activity_contact.contact_id = contact.id
    JOIN civicrm_activity activity ON activity.id = civicrm_activity_contact.activity_id 
    and activity.activity_type_id in (@share, @signature, @leave, @join)
	and  activity.activity_date_time >=   @start_date
	and  activity.activity_date_time <=   @end_date
    and activity.is_test=0
    JOIN civicrm_campaign ON civicrm_campaign.id = activity.campaign_id 
        ) AS ca
GROUP BY civicrm_camp_id , activity_type_id, status_id;

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


/**********************************************************************************************************************/


set @start_date :=  "1990-01-01" ;
set @end_date := now() ;
-- set @end_date := now();


/* search by sources of people 

gives wrong data for people not becoming members on the first campaign they join. 

country is still missing
*/

insert into analytics_petitions_total
(civicrm_camp_id, activity_type_id, status_id, npeople)
SELECT 
    ca.civicrm_camp_id AS civicrm_camp_id,
    ca.activity_type_id AS activity_type_id,
    ca.status_id AS status_id,
    COUNT(*) AS npeople
FROM
    (SELECT DISTINCT
        civicrm_campaign.id AS civicrm_camp_id,
        activity.activity_type_id as activity_type_id,
        activity.status_id as status_id,
        contact.id 
    FROM
        civicrm_contact contact
    JOIN civicrm_activity_contact ON civicrm_activity_contact.contact_id = contact.id
    JOIN civicrm_activity activity ON activity.id = civicrm_activity_contact.activity_id 
    and activity.activity_type_id in (@share, @signature, @leave, @join)
	and  activity.activity_date_time >=   @start_date
	and  activity.activity_date_time <=   @end_date
    and activity.is_test=0
    JOIN civicrm_campaign ON civicrm_campaign.id = activity.campaign_id 
        ) AS ca
GROUP BY civicrm_camp_id , activity_type_id, status_id;
/* now add speakout_id, speakout_name, language */

SET SQL_SAFE_UPDATES=0;


UPDATE analytics_petitions_total
        JOIN
    civicrm_campaign AS camp ON camp.id = analytics_petitions_total.civicrm_camp_id
        JOIN
    civicrm_value_speakout_integration_2 speakout_integration ON camp.id = speakout_integration.entity_id 
SET 
    speakout_id = camp.external_identifier,
    speakout_name = camp.name,
    speakout_title = camp.title,
    language = speakout_integration.language_4
WHERE
    analytics_petitions_total.civicrm_camp_id IS NOT NULL
;


insert into analytics_calculation_times
( calculation ) 
values ("after speakout petition kpis");




