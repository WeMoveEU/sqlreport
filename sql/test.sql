insert into test_oliver
(added_date)
select now();


/*

create temporary table member_metrics
(
id int not null auto_increment,
added_date date,
language varchar(5),
number_added int, 
-- +100 = 100  subscribed , -1 =  1 opted out
number_removed int,
primary key(id)
);

*/

/* subscriptions */

delete from analytics_member_metrics where added_date > "1900-00-00"; 


insert into analytics_member_metrics
(number_added, number_removed, added_date, language)
SELECT 
    COUNT(*) AS count, 0, percontact.added_date AS added_date, percontact.preferred_language as language
FROM	
    (SELECT 
        contact.id,
            MAX(DATE(hist.date)) AS added_date,
            contact.preferred_language as preferred_language
    FROM
        civicrm_contact AS contact 
    JOIN civicrm_group_contact gc ON contact.id = gc.contact_id
        AND gc.group_id = 42
        AND gc.status = 'Added'
    JOIN civicrm_subscription_history hist ON hist.contact_id = contact.id
        AND hist.group_id = gc.group_id
        AND hist.status = 'Added'
	join civicrm_email em on em.contact_id=contact.id
        and em.is_primary is true
        and on_hold in (0,2)       
        /* 2 = unsubscribe 1 = bounce, with not very good timing therefore excluded from the analysis 
        very few people anyway.         
        */
	WHERE
        is_deleted = 0 AND is_opt_out = 0   
--       and source != "change.org"
    GROUP BY contact.id) AS percontact
GROUP BY added_date, preferred_language ;


/* unsubscribe */

insert into analytics_member_metrics
(number_added, number_removed, added_date, language)
SELECT 
    0, COUNT(*) AS number_removed,
    DATE(email.hold_date) AS added_date,
    contact.preferred_language AS language
FROM
civicrm_contact contact 
    join      civicrm_email email on email.contact_id=contact.id
          and email.is_primary IS true  
        and email.on_hold = 2  
        JOIN civicrm_group_contact gc ON contact.id = gc.contact_id
        AND gc.group_id = 42
        AND gc.status = 'Added'
     
	where contact.is_opt_out =0 and contact.is_deleted=0
    GROUP BY language , added_date; 

/* we are still missing the ones that left the group members. 

*/


/*
insert into member_metrics
(number_removed, added_date, language)
SELECT 
    COUNT(*) AS count, percontact.added_date AS added_date, percontact.preferred_language as language
FROM
    (SELECT 
        contact.id,
            MAX(DATE(hist.date)) AS added_date,
            contact.preferred_language as preferred_language
    FROM
        civicrm_contact AS contact 
    JOIN civicrm_group_contact gc ON contact.id = gc.contact_id
        AND gc.group_id = 42
        AND gc.status = 'Added'
    JOIN civicrm_subscription_history hist ON hist.contact_id = contact.id
        AND hist.group_id = gc.group_id
        AND hist.status = 'Added'
    WHERE
        is_deleted = 0 AND is_opt_out = 0
    GROUP BY contact.id) AS percontact
GROUP BY added_date, preferred_language 
;



*/


-- select * from member_metrics; 


/*
SELECT 
    added_date AS date,
    SUM(number_added) AS total_added,
    SUM(number_removed) AS total_removed,
    SUM(number_added) - SUM(number_removed) AS net,
    SUM(IF(language = 'de_DE', number_added, 0)) AS de_DE,
    SUM(IF(language = 'en_GB', number_added, 0)) AS en_GB,
    SUM(IF(language = 'es_ES', number_added, 0)) AS es_ES,
    SUM(IF(language = 'fr_FR', number_added, 0)) AS fr_FR,
    SUM(IF(language = 'it_IT', number_added, 0)) AS it_IT,
    SUM(IF(language = 'en_US', number_added, 0)) AS en_US,
    SUM(IF(language = 'de_DE', number_removed, 0)) AS un_de_DE,
    SUM(IF(language = 'en_GB', number_removed, 0)) AS un_en_GB,
    SUM(IF(language = 'es_ES', number_removed, 0)) AS un_es_ES,
    SUM(IF(language = 'fr_FR', number_removed, 0)) AS un_fr_FR,
    SUM(IF(language = 'it_IT', number_removed, 0)) AS un_it_IT,
    SUM(IF(language = 'en_US', number_removed, 0)) AS un_en_US
   
FROM
    member_metrics
GROUP BY added_date
ORDER BY added_date DESC; 

*/


/*

-- idee: prozentuales Wachstum. Geht aber auch in xlsx.

SELECT 
    DATE(NOW()) - 1 AS date,
    SUM(IF(added_date <= date(now())-1,
        number_added - number_removed,
        0)) AS total_members,
    SUM(number_removed) AS total_removed,
    SUM(number_added) - SUM(number_removed) AS net,
    SUM(IF(language = 'de_DE', number_added, 0)) AS de_DE,
    SUM(IF(language = 'en_GB', number_added, 0)) AS en_GB,
    SUM(IF(language = 'es_ES', number_added, 0)) AS es_ES,
    SUM(IF(language = 'fr_FR', number_added, 0)) AS fr_FR,
    SUM(IF(language = 'it_IT', number_added, 0)) AS it_IT,
    SUM(IF(language = 'en_US', number_added, 0)) AS en_US,
    SUM(IF(language = 'de_DE',
        number_removed,
        0)) AS un_de_DE,
    SUM(IF(language = 'en_GB',
        number_removed,
        0)) AS un_en_GB,
    SUM(IF(language = 'es_ES',
        number_removed,
        0)) AS un_es_ES,
    SUM(IF(language = 'fr_FR',
        number_removed,
        0)) AS un_fr_FR,
    SUM(IF(language = 'it_IT',
        number_removed,
        0)) AS un_it_IT,
    SUM(IF(language = 'en_US',
        number_removed,
        0)) AS un_en_US
FROM
    member_metrics; 

*/

/*
SELECT 
    m1.added_date AS date,
    SUM(m1.number_added) AS total_added,
    SUM(m1.number_removed) AS total_removed,
    SUM(m1.number_added) - SUM(m1.number_removed) AS net,
    SUM(IF(m1.language = 'de_DE', m1.number_added, 0)) AS de_DE,
    SUM(IF(m1.language = 'en_GB', m1.number_added, 0)) AS en_GB,
    SUM(IF(m1.language = 'es_ES', m1.number_added, 0)) AS es_ES,
    SUM(IF(m1.language = 'fr_FR', m1.number_added, 0)) AS fr_FR,
    SUM(IF(m1.language = 'it_IT', m1.number_added, 0)) AS it_IT,
    SUM(IF(m1.language = 'en_US', m1.number_added, 0)) AS en_US,
    SUM(IF(m1.language = 'de_DE', m1.number_removed, 0)) AS un_de_DE,
    SUM(IF(language = 'en_GB', m1.number_removed, 0)) AS un_en_GB,
    SUM(IF(language = 'es_ES', m1.number_removed, 0)) AS un_es_ES,
    SUM(IF(language = 'fr_FR', m1.number_removed, 0)) AS un_fr_FR,
    SUM(IF(language = 'it_IT', m1.number_removed, 0)) AS un_it_IT,
    SUM(IF(language = 'en_US', m1.number_removed, 0)) AS un_en_US
   
FROM
    member_metrics m1
GROUP BY added_date
ORDER BY added_date DESC; 
*/

-- select count(*) from member_metrics;
