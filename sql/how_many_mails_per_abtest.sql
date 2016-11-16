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
