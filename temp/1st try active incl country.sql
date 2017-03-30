use wemove_47;
SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));


SELECT 
    kpidate, language, COUNT(t.contact_id) AS active, country_id
FROM
    (SELECT 
        gc.contact_id as contact_id,
            analytics_kpidates.date AS kpidate,
            c.preferred_language AS language
    FROM
        civicrm_contact c
    JOIN civicrm_group_contact gc ON c.id = gc.contact_id
    JOIN civicrm_activity_contact ac1 ON gc.contact_id = ac1.contact_id
    JOIN civicrm_activity a1 ON ac1.activity_id = a1.id
    JOIN analytics_kpidates
    WHERE
        c.is_opt_out = 0 AND gc.group_id = 42
            AND gc.status = 'Added'
            AND a1.activity_type_id IN (6 , 28, 32)
            AND a1.activity_date_time >= DATE_ADD(analytics_kpidates.date, INTERVAL - 3 MONTH)
            AND DATE(a1.activity_date_time) <= analytics_kpidates.date
            AND a1.activity_date_time >= DATE_ADD(c.created_date, INTERVAL 1 DAY)
    GROUP BY gc.contact_id , analytics_kpidates.date
    HAVING COUNT(ac1.id) >= 1) t
        JOIN
    civicrm_email email ON email.contact_id = t.contact_id
        AND email.is_primary IS TRUE
        AND email.on_hold = 0
	LEFT JOIN
    civicrm_address address ON address.contact_id = t.contact_id
        AND address.is_primary = 1
        	
GROUP BY kpidate , language, country_id; 
