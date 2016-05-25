use website; 

SELECT 
    COUNT(*)
FROM
    webform_submitted_data data2
WHERE
    170 = data2.nid
        AND data2.data IN ('CS1' , 'CS2');
            

SELECT 
    nid,
    internal_name,
    name,
    mailing_a_date,
    SUM(IF(data = 'CS1', votes, 0)) AS '++',
    SUM(IF(data = 'CS2', votes, 0)) AS '+',
    SUM(IF(data = 'CS3', votes, 0)) AS '-',
    SUM(IF(data = 'CS4', votes, 0)) AS '--',
    SUM(IF(data = 'CS5', votes, 0)) AS '?',
    (SELECT 
            COUNT(*)
        FROM
            webform_submitted_data data
                JOIN
            webform_submissions subm ON subm.sid = data.sid
        WHERE
            data.nid = results.nid
                AND data.data IN ('CS1' , 'CS2')
                AND FROM_UNIXTIME(subm.submitted) < DATE_ADD(results.mailing_a_date,
                INTERVAL 2 HOUR)) AS h2_pos, 
                                 (SELECT 
            COUNT(*)
        FROM
            webform_submitted_data data
                JOIN
            webform_submissions subm ON subm.sid = data.sid
        WHERE
            data.nid = results.nid
                AND data.data IN ('CS1' , 'CS2')
                AND FROM_UNIXTIME(subm.submitted) < DATE_ADD(results.mailing_a_date,
                INTERVAL 5 HOUR)) AS h5_pos,
                 (SELECT 
            COUNT(*)
        FROM
            webform_submitted_data data
                JOIN
            webform_submissions subm ON subm.sid = data.sid
        WHERE
            data.nid = results.nid
                AND data.data IN ('CS1' , 'CS2')
                AND FROM_UNIXTIME(subm.submitted) < DATE_ADD(results.mailing_a_date,
                INTERVAL 24 HOUR)) AS h24_pos
FROM
    (SELECT 
        node.nid AS nid,
            title,
            field_mailing_id_value AS mailing_id,
            field_internal_name_value AS internal_name,
            data,
            COUNT(*) AS votes,
            abtest.name AS name,
            mailing_a.scheduled_date AS mailing_a_date
    FROM
        node
    JOIN webform_submitted_data data ON node.nid = data.nid
        AND data.data LIKE 'CS_'
    JOIN webform_submissions subm ON subm.sid = data.sid
    JOIN field_data_field_mailing_id mailing ON mailing.entity_id = node.nid
    JOIN field_data_field_internal_name internal ON internal.entity_id = node.nid
    JOIN civi_wemove.civicrm_mailing_abtest abtest ON field_mailing_id_value = abtest.id
    JOIN civi_wemove.civicrm_mailing mailing_a ON abtest.mailing_id_a = mailing_a.id
    JOIN civi_wemove.civicrm_mailing mailing_b ON abtest.mailing_id_b = mailing_b.id
    GROUP BY node.nid , data) AS results
GROUP BY internal_name
ORDER BY RIGHT(internal_name, 2) , IF(RIGHT(internal_name, 6) = 'INT-EN',
    0,
    1) , internal_name
;
 








drop table if exists analytics_surveyy;


create temporary table analytics_surveys 
(
id int not null auto_increment,
nid int,
internal_name varchar(255),
scheduled_date datetime,
abtest_id int, 
mails_received int,
/* ++, + , - , -- ,?*/
total_pp int, 
total_p int,
total_m int,
total_mm int,
total_q int, 
h2_pos int,
h5_pos int,
h24_pos int,
h48_pos int,
stamp timestamp,
primary key(id)
);

insert into analytics_active_3m
(nid, internal_name, scheduled_date, abtest_id, total_pp, total_p, total_m, total_mm, total_q)
SELECT 
    nid
    internal_name,
    name,
    mailing_a_date,
    SUM(IF(data = 'CS1', votes, 0)) AS '++',
    SUM(IF(data = 'CS2', votes, 0)) AS '+',
    SUM(IF(data = 'CS3', votes, 0)) AS '-',
    SUM(IF(data = 'CS4', votes, 0)) AS '--',
    SUM(IF(data = 'CS5', votes, 0)) AS '?'
FROM
    (SELECT 
        node.nid as nid,
            title,
            field_mailing_id_value AS mailing_id,
            field_internal_name_value AS internal_name,
            data,
            COUNT(*) AS votes,
            abtest.name AS name,
            mailing_a.scheduled_date AS mailing_a_date
	FROM
        node
    JOIN webform_submitted_data data ON node.nid = data.nid
        AND data.data LIKE 'CS_'
    JOIN webform_submissions subm ON subm.sid = data.sid
    JOIN field_data_field_mailing_id mailing ON mailing.entity_id = node.nid
    JOIN field_data_field_internal_name internal ON internal.entity_id = node.nid
    JOIN civi_wemove.civicrm_mailing_abtest abtest ON field_mailing_id_value = abtest.id
    JOIN civi_wemove.civicrm_mailing mailing_a ON abtest.mailing_id_a = mailing_a.id
    JOIN civi_wemove.civicrm_mailing mailing_b ON abtest.mailing_id_b = mailing_b.id
    GROUP BY node.nid , data) AS results
GROUP BY internal_name
ORDER BY RIGHT(internal_name, 2) , IF(RIGHT(internal_name, 6) = 'INT-EN',
    0,
    1) , internal_name
;
 
 
 select * from analytics_surveys;





SELECT 
    nid
    internal_name,
    name,
    mailing_a_date,
    recipients,
    SUM(IF(data = 'CS1', votes, 0)) AS '++',
    SUM(IF(data = 'CS2', votes, 0)) AS '+',
    SUM(IF(data = 'CS3', votes, 0)) AS '-',
    SUM(IF(data = 'CS4', votes, 0)) AS '--',
    SUM(IF(data = 'CS5', votes, 0)) AS '?'
FROM
    (SELECT 
        node.nid as nid,
            title,
            field_mailing_id_value AS mailing_id,
            field_internal_name_value AS internal_name,
            data,
            COUNT(*) AS votes,
            abtest.name AS name,
            mailing_a.scheduled_date AS mailing_a_date
	FROM
        node
    JOIN webform_submitted_data data ON node.nid = data.nid
        AND data.data LIKE 'CS_'
    JOIN webform_submissions subm ON subm.sid = data.sid
    JOIN field_data_field_mailing_id mailing ON mailing.entity_id = node.nid
    JOIN field_data_field_internal_name internal ON internal.entity_id = node.nid
    JOIN civi_wemove.civicrm_mailing_abtest abtest ON field_mailing_id_value = abtest.id
    JOIN civi_wemove.civicrm_mailing mailing_a ON abtest.mailing_id_a = mailing_a.id
    JOIN civi_wemove.civicrm_mailing mailing_b ON abtest.mailing_id_b = mailing_b.id
    GROUP BY node.nid , data) AS results
GROUP BY internal_name
ORDER BY RIGHT(internal_name, 2) , IF(RIGHT(internal_name, 6) = 'INT-EN',
    0,
    1) , internal_name
;
 

/*
   where from_unixtime(subm.submitted) > "2016-05-22 12:05" or from_unixtime(subm.submitted) < "2016-05-21 14:08"


*/





/*
SELECT 
    node.nid, title, from_unixtime(subm.submitted),data, COUNT(*)
FROM
    node
        JOIN
    webform_submitted_data data ON node.nid = data.nid
        AND data.data LIKE 'CS_'
        join webform_submissions subm on subm.sid=data.sid
GROUP BY node.nid , data
;

*/