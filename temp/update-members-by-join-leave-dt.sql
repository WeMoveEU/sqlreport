
set @join := 57;
set @leave := 56;


truncate table analytics_member_metrics_dt; 


insert into analytics_member_metrics_dt
(delta_t_h_id, number_added, number_removed, language)
SELECT 
    delta_t_h_id, COUNT(*) AS count, 0 , percontact.preferred_language as language
FROM	
    (SELECT 
     analytics_delta_t_h.id as delta_t_h_id,
 --       contact.id,
        c.preferred_language as preferred_language
    FROM
    analytics_delta_t_h join
    civicrm_activity a on  a.activity_type_id = @join
    and 
    a.is_test=0
    
       and a.activity_date_time<=  DATE_ADD(now(), INTERVAL - analytics_delta_t_h.hours_to hour)
        and a.activity_date_time>=  DATE_ADD(now(), INTERVAL - analytics_delta_t_h.hours_from hour)
     
   
    join civicrm_activity_contact ac on a.id = ac.activity_id
    join civicrm_contact c on c.id = ac.contact_id and source != "change.org" 
/*    and
    is_deleted = 0 AND is_opt_out = 0 
    */
--       and source != "change.org"
    ) AS percontact
GROUP BY delta_t_h_id, preferred_language ;

/*
select * from analytics_delta_t_h;

select * from analytics_member_metrics_dt;

*/

/* unsubscribe */

insert into analytics_member_metrics_dt
(delta_t_h_id, number_added, number_removed, language)
SELECT 
    analytics_delta_t_h.id as delta_t_h_id,
    0,
    COUNT(*) AS count,
    contact.preferred_language AS language
FROM
    civicrm_contact contact
        join analytics_delta_t_h 
        JOIN
    civicrm_email email ON email.contact_id = contact.id
        AND email.is_primary IS TRUE
        AND email.on_hold = 2
       and email.hold_date <=  DATE_ADD(now(), INTERVAL - analytics_delta_t_h.hours_to hour)
        and email.hold_date >=  DATE_ADD(now(), INTERVAL - analytics_delta_t_h.hours_from hour)
        JOIN
    civicrm_group_contact gc ON contact.id = gc.contact_id
        AND gc.group_id = 42
        AND gc.status = 'Added'
        WHERE
    contact.is_opt_out = 0
        AND contact.is_deleted = 0
GROUP BY delta_t_h_id, language; 


SELECT * from analytics_member_metrics_dt;

select delta_t_h_id, sum(number_added-number_removed) from analytics_member_metrics_dt
group by delta_t_h_id; 

select delta_t_h.period as description,   
    SUM(number_added -number_removed) AS total,
    SUM(IF(language = 'de_DE', number_added - number_removed, 0)) AS de_DE,
    SUM(IF(language = 'en_GB', number_added - number_removed, 0)) AS en_GB,
    SUM(IF(language = 'es_ES', number_added - number_removed, 0)) AS es_ES,
    SUM(IF(language = 'fr_FR', number_added - number_removed, 0)) AS fr_FR,
    SUM(IF(language = 'it_IT', number_added - number_removed, 0)) AS it_IT,
    SUM(IF(language = 'en_US', number_added - number_removed, 0)) AS en_US,
    SUM(if(language not in ('de_DE','en_GB',  'es_ES', 'fr_FR', 'it_IT', 'en_US'), number_added - number_removed, 0)) AS other,  
    max(stamp) as last_calculated
FROM
    analytics_member_metrics_dt dt
    join analytics_delta_t_h delta_t_h on dt.delta_t_h_id = delta_t_h.id
    group by delta_t_h.id
    ;
    
select * from analytics_delta_t_h;