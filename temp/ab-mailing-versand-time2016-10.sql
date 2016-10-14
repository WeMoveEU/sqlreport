use civi_wemove;

set @versionA := 3552;
set @versionB := 3551;



SELECT 
    deltime,
    SUM(IF(mailing_id = @versionA, mails, 0)) AS A,
    SUM(IF(mailing_id = @versionB, mails, 0)) AS B
FROM
    (SELECT 
        mailing_id,
            DATE_FORMAT(time_stamp, '%Y-%m-%d %H:%i') AS deltime,
            COUNT(*) AS mails
    FROM
        civicrm_mailing_event_queue queue
    JOIN civicrm_mailing_event_delivered del ON del.event_queue_id = queue.id
    JOIN civicrm_mailing_job job ON job.id = queue.job_id
    WHERE
        job.mailing_id IN (@versionB, @versionA)
    GROUP BY mailing_id , deltime) abtest
GROUP BY deltime
;



select * from civicrm_mailing_job; 

-- 1144, 1145


select * from civicrm_mailing_event_delivered del;

select * from civicrm_mailing_event_queue queue;

select job_id,count(*) from civicrm_mailing_event_queue queue 
where job_id in (1144,1145)
group by job_id;

select * from civicrm_mailing;

select max(job_id) from civicrm_mailing_event_queue; 







from 

civicrm_mailing_event_queue queue
    JOIN civicrm_mailing_event_delivered del ON del.event_queue_id = queue.id
        AND del.time_stamp > DATE_ADD(NOW(), INTERVAL - 10 DAY)) ON c.id = queue.contact_id
    GROUP BY c.id
    