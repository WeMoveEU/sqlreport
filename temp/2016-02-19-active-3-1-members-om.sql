-- -- 6 contribution
-- -- 28 survey
-- -- 32 petition


drop temporary table if exists kpidates;

create temporary table kpidates
(
-- id int not null auto_increment,
date datetime/*,
-- primary key(id) */
);

/* insert into kpidates 
values ("2016-01-01"), ("2016-01-15"), ("2016-02-01"), ("2016-02-15");
-- values ("2016-02-15");
*/

insert into kpidates
(date) 
SELECT DISTINCT
    DATE(created_date) AS date
FROM
    civicrm_contact
WHERE
    DATE(created_date) >= "2015-09-01";


-- select * from kpidates; 




SELECT 
    kpidate AS date,
    SUM(active) AS total_active_3m,
    SUM(IF(language = 'de_DE', active, 0)) AS de_DE,
    SUM(IF(language = 'en_GB', active, 0)) AS en_GB,
    SUM(IF(language = 'es_ES', active, 0)) AS es_ES,
    SUM(IF(language = 'fr_FR', active, 0)) AS fr_FR,
    SUM(IF(language = 'it_IT', active, 0)) AS it_IT,
    SUM(IF(language = 'en_US', active, 0)) AS en_US
FROM
    (SELECT 
        kpidate, language, COUNT(t.contact_id) AS active
    FROM
        (SELECT 
        gc.contact_id,
            kpidates.date AS kpidate,
            c.preferred_language AS language
    FROM
        civicrm_contact c
    JOIN civicrm_group_contact gc ON c.id = gc.contact_id
    JOIN civicrm_activity_contact ac1 ON gc.contact_id = ac1.contact_id
    JOIN civicrm_activity a1 ON ac1.activity_id = a1.id
    JOIN kpidates
    WHERE
        c.is_opt_out = 0 AND gc.group_id = 42
            AND gc.status = 'Added'
            AND a1.activity_type_id IN (6 , 28, 32)
            AND a1.activity_date_time >= DATE_ADD(kpidates.date, INTERVAL - 3 MONTH)
            AND DATE(a1.activity_date_time) <= kpidates.date
            AND a1.activity_date_time >= DATE_ADD(c.created_date, INTERVAL 1 DAY)
    GROUP BY gc.contact_id , kpidates.date
    HAVING COUNT(ac1.id) >= 1) t
    join civicrm_email email on email.contact_id=t.contact_id
      and email.is_primary IS true  
	and email.on_hold = 0  
 
    GROUP BY kpidate , language) AS active_members
GROUP BY kpidate
ORDER BY kpidate DESC;


SELECT 
    kpidate AS date,
    SUM(active) AS total_active_1m,
    SUM(IF(language = 'de_DE', active, 0)) AS de_DE,
    SUM(IF(language = 'en_GB', active, 0)) AS en_GB,
    SUM(IF(language = 'es_ES', active, 0)) AS es_ES,
    SUM(IF(language = 'fr_FR', active, 0)) AS fr_FR,
    SUM(IF(language = 'it_IT', active, 0)) AS it_IT,
    SUM(IF(language = 'en_US', active, 0)) AS en_US
FROM
    (SELECT 
        kpidate, language, COUNT(t.contact_id) AS active
    FROM
        (SELECT 
        gc.contact_id,
            kpidates.date AS kpidate,
            c.preferred_language AS language
    FROM
        civicrm_contact c
    JOIN civicrm_group_contact gc ON c.id = gc.contact_id
    JOIN civicrm_activity_contact ac1 ON gc.contact_id = ac1.contact_id
    JOIN civicrm_activity a1 ON ac1.activity_id = a1.id
    JOIN kpidates
    WHERE
        c.is_opt_out = 0 AND gc.group_id = 42
            AND gc.status = 'Added'
            AND a1.activity_type_id IN (6 , 28, 32)
            AND a1.activity_date_time >= DATE_ADD(kpidates.date, INTERVAL - 1 MONTH)
            AND DATE(a1.activity_date_time) <= kpidates.date
            AND a1.activity_date_time >= DATE_ADD(c.created_date, INTERVAL 1 DAY)
    GROUP BY gc.contact_id , kpidates.date
    HAVING COUNT(ac1.id) >= 1) t
    join civicrm_email email on email.contact_id=t.contact_id
      and email.is_primary IS true  
	and email.on_hold = 0  
 
    GROUP BY kpidate , language) AS active_members
GROUP BY kpidate
ORDER BY kpidate DESC;


