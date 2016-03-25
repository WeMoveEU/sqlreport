SELECT 
date_format(activity.activity_date_time,'%Y-%m-%d %H:00') as dtime, count(contact.id) AS signatures
FROM
    civicrm_contact contact
        JOIN
    civicrm_activity_contact ac ON ac.contact_id = contact.id
        JOIN
    civicrm_activity activity ON ac.activity_id = activity.id
        AND activity.subject LIKE 'diem25%'
        AND activity.activity_type_id = 32
where activity.activity_date_time>"2016-03-23 22:00"
GROUP BY dtime
ORDER BY dtime DESC;


 