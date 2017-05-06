
insert into analytics_calculation_times
( calculation ) 
values ("before delta-t update");

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

truncate table analytics_member_metrics_dt; 

insert into analytics_member_metrics_dt
(delta_t_h_id, country_id, number_added, number_removed, language)
SELECT 
    delta_t_h_id, country_id, COUNT(*) AS count, 0 , percontact.preferred_language as language
FROM	
    (SELECT 
     analytics_delta_t_h.id as delta_t_h_id,
 --       contact.id,
        c.preferred_language as preferred_language,
        address.country_id as country_id
    FROM
    analytics_delta_t_h join
    civicrm_activity a on  a.activity_type_id = @join
    and 
    a.is_test=0
    
       and a.activity_date_time<=  DATE_ADD(now(), INTERVAL - analytics_delta_t_h.hours_to hour)
        and a.activity_date_time>=  DATE_ADD(now(), INTERVAL - analytics_delta_t_h.hours_from hour)
     
   
    join civicrm_activity_contact ac on a.id = ac.activity_id
    join civicrm_contact c on c.id = ac.contact_id and source != "change.org" 
    left JOIN
    civicrm_address address ON address.contact_id = c.id
    and address.is_primary=1        

    ) AS percontact
GROUP BY delta_t_h_id, country_id, preferred_language ;


/* unsubscribe */

insert into analytics_member_metrics_dt
(delta_t_h_id, country_id, number_added, number_removed, language)
SELECT 
    delta_t_h_id,
    country_id,
    0,
    COUNT(*) AS count,
    percontact.preferred_language AS language
FROM
    (SELECT 
     analytics_delta_t_h.id as delta_t_h_id,
        c.preferred_language as preferred_language,
          address.country_id as country_id
    FROM
    analytics_delta_t_h join
    civicrm_activity a on  a.activity_type_id = @leave and date(activity_date_time) != "2016-04-01"
    and 
    a.is_test=0
           and a.activity_date_time<=  DATE_ADD(now(), INTERVAL - analytics_delta_t_h.hours_to hour)
        and a.activity_date_time>=  DATE_ADD(now(), INTERVAL - analytics_delta_t_h.hours_from hour)
      join civicrm_activity_contact ac on a.id = ac.activity_id
    join civicrm_contact c on c.id = ac.contact_id 
   left JOIN
    civicrm_address address ON address.contact_id = c.id
    and address.is_primary=1        
    ) AS percontact
GROUP BY delta_t_h_id, country_id, preferred_language ;

insert into analytics_calculation_times
( calculation ) 
values ("after delta-t update");

