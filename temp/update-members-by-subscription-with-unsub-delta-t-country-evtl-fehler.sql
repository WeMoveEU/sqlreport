

truncate table analytics_member_metrics_dt; 


insert into analytics_member_metrics_dt
(delta_t_h_id, number_added, number_removed, language, country_id)
SELECT 
    delta_t_h_id, COUNT(*) AS count, 0 , percontact.preferred_language as language, percontact.country_id
FROM	
    (SELECT 
     analytics_delta_t_h.id as delta_t_h_id,
        contact.id,
            MAX(DATE(hist.date)) AS added_date,
            contact.preferred_language as preferred_language,
                 address.country_id as country_id
    FROM
        civicrm_contact AS contact 
    JOIN civicrm_group_contact gc ON contact.id = gc.contact_id
        AND gc.group_id = 42
        AND gc.status = 'Added'
            join analytics_delta_t_h 
    JOIN civicrm_subscription_history hist ON hist.contact_id = contact.id
        AND hist.group_id = gc.group_id
        AND hist.status = 'Added'
        and hist.date <=  DATE_ADD(now(), INTERVAL - analytics_delta_t_h.hours_to hour)
        and hist.date >=  DATE_ADD(now(), INTERVAL - analytics_delta_t_h.hours_from hour)
	join civicrm_email em on em.contact_id=contact.id
        and em.is_primary is true
        and on_hold in (0,2)       
        /* 2 = unsubscribe 1 = bounce, with not very good timing therefore excluded from the analysis 
        very few people anyway.         
        */
        
	left JOIN
    civicrm_address address ON address.contact_id = contact.id
    and address.is_primary=1        
	WHERE
        is_deleted = 0 AND is_opt_out = 0 
--       and source != "change.org"
    GROUP BY  contact.id) AS percontact
GROUP BY delta_t_h_id, country_id, preferred_language ;

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


