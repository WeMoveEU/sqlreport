insert into analytics_calculation_times
( calculation ) 
values ("before member calculation 1");



truncate table analytics_member_metrics; 

insert into analytics_member_metrics
(number_added, number_removed, added_date, language, country_id)
SELECT 
    COUNT(*) AS count, 0, percontact.added_date AS added_date, percontact.preferred_language as language, percontact.country_id as country_id
FROM	
    (SELECT 
        contact.id,
            MAX(DATE(hist.date)) AS added_date,
            contact.preferred_language as preferred_language,
            MIN(address.country_id) as country_id
    FROM
        civicrm_contact AS contact 
/*    JOIN civicrm_group_contact gc ON contact.id = gc.contact_id
        AND gc.group_id = 42
        AND gc.status in ('Added','Removed')
        */
    JOIN civicrm_subscription_history hist ON hist.contact_id = contact.id
        AND hist.group_id = 42
        AND hist.status = 'Added'
	join civicrm_email em on em.contact_id=contact.id
        and em.is_primary is true
        and on_hold in(0,2) 
	left JOIN
    civicrm_address address ON address.contact_id = contact.id
    and address.is_primary=1        
	WHERE
        is_deleted = 0 AND is_opt_out = 0   
	GROUP BY contact.id) AS percontact
GROUP BY added_date, country_id, preferred_language;


insert into analytics_calculation_times
( calculation ) 
values ("after member calculation 1");




insert into analytics_member_metrics
(number_added, number_removed, added_date, language, country_id)
SELECT 
    0,
    COUNT(*) AS number_removed,
    DATE(email.hold_date) AS added_date,
    contact.preferred_language AS language,
    country_id
FROM
    civicrm_contact contact
        JOIN
    civicrm_email email ON email.contact_id = contact.id
        AND email.is_primary IS TRUE
        AND email.on_hold = 2
        JOIN
    civicrm_group_contact gc ON contact.id = gc.contact_id
        AND gc.group_id = 42
        AND gc.status = 'Removed'
	left JOIN
    civicrm_address address ON address.contact_id = contact.id
    and address.is_primary=1        
WHERE
    contact.is_opt_out = 0
        AND contact.is_deleted = 0
GROUP BY added_date, language, country_id; 



insert into analytics_calculation_times
( calculation ) 
values ("after member calculation 2");
