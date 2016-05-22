select from_unixtime(1438924713);

select * from webform_submissions ;

select * from webform_submitted_data;

select * from webform_submitted_data where nid=155;

select * from node;


SELECT 
    node.nid, title, data, COUNT(*)
FROM
    node
        JOIN
    webform_submitted_data data ON node.nid = data.nid
        AND data.data LIKE 'CS_'
GROUP BY node.nid , data
;

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



select * from webform;
-- nid = node id. 


select * from node
