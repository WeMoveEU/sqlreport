

SELECT 
    internal_name,
    SUM(IF(data = 'CS1', votes, 0)) AS '++',
    SUM(IF(data = 'CS2', votes, 0)) AS '+',
    SUM(IF(data = 'CS3', votes, 0)) AS '-',
    SUM(IF(data = 'CS4', votes, 0)) AS '--',
    SUM(IF(data = 'CS5', votes, 0)) AS '?'
FROM
    (SELECT 
        node.nid,
            title,
            field_mailing_id_value AS mailing_id,
            field_internal_name_value AS internal_name,
            data,
            COUNT(*) AS votes
    FROM
        node
    JOIN webform_submitted_data data ON node.nid = data.nid
        AND data.data LIKE 'CS_'
    JOIN webform_submissions subm ON subm.sid = data.sid
    LEFT JOIN field_data_field_mailing_id mailing ON mailing.entity_id = node.nid
    LEFT JOIN field_data_field_internal_name internal ON internal.entity_id = node.nid

--  where from_unixtime(subm.submitted) > "2016-05-22 12:05" or from_unixtime(subm.submitted) < "2016-05-21 14:08"
    GROUP BY node.nid , data) AS results
    
GROUP BY internal_name
ORDER BY RIGHT(internal_name, 2) , if(right(internal_name,6)='INT-EN',0,1) , internal_name
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