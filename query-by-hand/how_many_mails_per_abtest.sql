use civi_wemove;

truncate table analytics.ab_mailings; 


insert into analytics.ab_mailings
(abtest_id,
/* mails_delivered,
mails_opened,*/
recipients,
scheduled_date_a) 
SELECT 
abtest.id as abtest_id,
(SELECT 
            COUNT(r.id)
        FROM
            civicrm_mailing_recipients AS r
        WHERE
            r.mailing_id = mailing_a.id)
            + 
(SELECT 
            COUNT(r.id)
        FROM
            civicrm_mailing_recipients AS r
        WHERE
            r.mailing_id = mailing_b.id)
					AS recipients,
	mailing_a.scheduled_date scheduled_date_a

from 
 civi_wemove.civicrm_mailing_abtest abtest 
 JOIN civi_wemove.civicrm_mailing mailing_a ON abtest.mailing_id_a = mailing_a.id
 JOIN civi_wemove.civicrm_mailing mailing_b ON abtest.mailing_id_b = mailing_b.id
;

/*
select * from analytics.ab_mailings;

*/

/*
SELECT 
    m.id,
    m.name,
    subject,
    scheduled_date AS date,
    m.created_id AS owner_id,
    campaign_id,
    camp.name AS campaign,
    camp.external_identifier,
    campaign_type_id,
    createdContact.first_name AS owner,
    (SELECT 
            COUNT(r.id)
        FROM
            civicrm_mailing_recipients AS r
        WHERE
            r.mailing_id = m.id) AS recipients,
    open,
    click
FROM
    civicrm_mailing AS m
        LEFT JOIN
    civicrm_campaign AS camp ON m.campaign_id = camp.id
        LEFT JOIN
    civicrm_contact createdContact ON (m.created_id = createdContact.id)
        LEFT JOIN
    (SELECT 
        COUNT(*) AS open, id
    FROM
        (SELECT 
        civicrm_mailing.id,
            COUNT(civicrm_mailing_event_opened.id) AS opened
    FROM
        civicrm_mailing_event_opened
    JOIN civicrm_mailing_event_queue ON civicrm_mailing_event_opened.event_queue_id = civicrm_mailing_event_queue.id
    JOIN civicrm_mailing_job ON civicrm_mailing_event_queue.job_id = civicrm_mailing_job.id
    JOIN civicrm_mailing ON civicrm_mailing_job.mailing_id = civicrm_mailing.id
        AND civicrm_mailing_job.is_test = 0
        AND civicrm_mailing.is_completed = TRUE
    GROUP BY civicrm_mailing_event_queue.id , civicrm_mailing.id) AS dist
    GROUP BY id) AS opened ON opened.id = m.id
        LEFT JOIN
    (SELECT 
        COUNT(*) AS click, id
    FROM
        (SELECT 
        civicrm_mailing.id,
            COUNT(civicrm_mailing_event_trackable_url_open.id) AS clicked
    FROM
        civicrm_mailing_event_trackable_url_open
    JOIN civicrm_mailing_event_queue ON civicrm_mailing_event_trackable_url_open.event_queue_id = civicrm_mailing_event_queue.id
    JOIN civicrm_mailing_job ON civicrm_mailing_event_queue.job_id = civicrm_mailing_job.id
    JOIN civicrm_mailing ON civicrm_mailing_job.mailing_id = civicrm_mailing.id
        AND civicrm_mailing_job.is_test = 0
        AND civicrm_mailing.is_completed = TRUE
    GROUP BY civicrm_mailing_event_queue.id , civicrm_mailing.id) AS dist
    GROUP BY id) AS clicked ON clicked.id = m.id
WHERE
    is_completed = TRUE;
*/