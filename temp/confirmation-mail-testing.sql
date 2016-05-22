SELECT 
    mailing_id, sum(contacts) as recipients, sum(if(status='Added',contacts,0)) as members_now, sum(if(status='Added',contacts,0))/sum(contacts) as percentage_members
FROM
    (SELECT 
        mailing_id, gc.status AS status, COUNT(*) AS contacts
    FROM
        civicrm_mailing_event_queue queue
    JOIN civicrm_mailing_event_delivered del ON del.event_queue_id = queue.id
    JOIN civicrm_mailing_job job ON job.id = queue.job_id
        AND job.mailing_id IN (1314 , 1319, 1318, 1317, 1315, 1316)
    JOIN civicrm_contact contact ON contact.id = queue.contact_id
    LEFT JOIN civicrm_group_contact gc ON gc.contact_id = contact.id
        AND gc.group_id = 42
        AND gc.status = 'Added'
    GROUP BY mailing_id , status) abtest
    group by mailing_id
    order by mailing_id; 
    
