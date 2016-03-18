
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
    delta_t_h_id,
    0,
    COUNT(*) AS count,
    percontact.preferred_language AS language
FROM
    (SELECT 
     analytics_delta_t_h.id as delta_t_h_id,
 --       contact.id,
        c.preferred_language as preferred_language
    FROM
    analytics_delta_t_h join
    civicrm_activity a on  a.activity_type_id = @leave
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

