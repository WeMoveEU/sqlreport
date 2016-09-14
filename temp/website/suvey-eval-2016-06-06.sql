use website;

SELECT 
    nid,
    internal_name,
   name as ab_test_name,
    mailing_a_date,
    recipients,
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
                INTERVAL 24 HOUR)) AS h24_pos,
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
                INTERVAL 48 HOUR))  AS h48_pos,
                 now() 

FROM
    (SELECT 
        node.nid AS nid,
            title,
            field_mailing_id_value AS mailing_id,
            field_internal_name_value AS internal_name,
            data,
            COUNT(*) AS votes,
            abtest.name AS name,
            mailing_a.scheduled_date AS mailing_a_date,
            analytics_ab.recipients as recipients
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
    join analytics.ab_mailings analytics_ab on analytics_ab.abtest_id = abtest.id
    where node.nid not in(181, 157, 165, 166, 164, 167, 174)
    GROUP BY node.nid , data) AS results
GROUP BY internal_name
ORDER BY 
mailing_a_date desc,
RIGHT(internal_name, 2) , IF(RIGHT(internal_name, 6) = 'INT-EN', 0,1) , internal_name 
INTO OUTFILE '/tmp/survey_data.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
;





