
truncate table analytics_kpidates;

insert into analytics_kpidates
(date) 
SELECT DISTINCT
    DATE(created_date) AS date
FROM
    civicrm_contact
WHERE
    DATE(created_date) >= "2015-09-01";
