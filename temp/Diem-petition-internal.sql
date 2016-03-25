set @petition_signature:= 32;

SELECT 
    activity_type_id, COUNT(*)
FROM
    civicrm_activity activity
WHERE
    activity.subject LIKE 'diem25%'
GROUP BY activity_type_id; 

-- double counting, but that's OK. 

SELECT 
    activity.subject , COUNT(contact.id) AS signatures
    FROM
        civicrm_contact contact
    JOIN civicrm_activity_contact ac ON ac.contact_id = contact.id
    JOIN civicrm_activity activity ON ac.activity_id = activity.id
    WHERE
        activity.subject LIKE 'diem25%'
        and activity.activity_type_id = @petition_signature
        
GROUP BY subject
ORDER BY signatures DESC;

SELECT 
    asource.campaign_26 AS campaign,
    COUNT(contact.id) AS signatures
FROM
    civicrm_contact contact
        JOIN
    civicrm_activity_contact ac ON ac.contact_id = contact.id
        JOIN
    civicrm_activity activity ON ac.activity_id = activity.id
        AND activity.subject LIKE 'diem25%'
        AND activity.activity_type_id = @petition_signature
        LEFT JOIN
    civicrm_value_action_source_4 asource ON asource.entity_id = activity.id
GROUP BY campaign
ORDER BY signatures DESC;


SELECT 
    activity.subject as subject, asource.campaign_26 AS campaign,
    COUNT(contact.id) AS signatures
FROM
    civicrm_contact contact
        JOIN
    civicrm_activity_contact ac ON ac.contact_id = contact.id
        JOIN
    civicrm_activity activity ON ac.activity_id = activity.id
        AND activity.subject LIKE 'diem25%'
        AND activity.activity_type_id = @petition_signature
        LEFT JOIN
    civicrm_value_action_source_4 asource ON asource.entity_id = activity.id
GROUP BY campaign, subject
ORDER BY signatures DESC;


SELECT 
 asource.campaign_26 AS campaign,
    COUNT(contact.id) AS signatures
FROM
    civicrm_contact contact
        JOIN
    civicrm_activity_contact ac ON ac.contact_id = contact.id
        JOIN
    civicrm_activity activity ON ac.activity_id = activity.id
        AND activity.subject LIKE 'diem25%'
        AND activity.activity_type_id = @petition_signature
        LEFT JOIN
    civicrm_value_action_source_4 asource ON asource.entity_id = activity.id
GROUP BY campaign
ORDER BY signatures DESC;


SELECT 
    asource.source_27 as source, asource.campaign_26 as campaign, count(contact.id) AS signatures
FROM
    civicrm_contact contact
        JOIN
    civicrm_activity_contact ac ON ac.contact_id = contact.id
        JOIN
    civicrm_activity activity ON ac.activity_id = activity.id
        AND activity.subject LIKE 'diem25%'
        AND activity.activity_type_id = @petition_signature
		left join civicrm_value_action_source_4 asource on asource.entity_id=activity.id and asource.source_27='diem25volunteers'
GROUP BY  campaign
ORDER BY signatures DESC;



SELECT 
    subject, COUNT(cid) AS signatures
FROM
    (SELECT DISTINCT
        activity.subject as subject, preferred_language, contact.id as cid
    FROM
        civicrm_contact contact
    JOIN civicrm_activity_contact ac ON ac.contact_id = contact.id
    JOIN civicrm_activity activity ON ac.activity_id = activity.id
    WHERE
        activity.subject LIKE 'diem25%'
        and activity.activity_type_id = @petition_signature
        ) AS diem_activities
left join   civicrm_value_action_source_4 asource on asource.entity_id= activity.id    
GROUP BY subject
ORDER BY signatures DESC;




SELECT 
    subject, COUNT(cid) AS signatures
FROM
    (SELECT DISTINCT
        activity.subject as subject, preferred_language, contact.id as cid
    FROM
        civicrm_contact contact
    JOIN civicrm_activity_contact ac ON ac.contact_id = contact.id
    JOIN civicrm_activity activity ON ac.activity_id = activity.id
    WHERE
        activity.subject LIKE 'diem25%'
        and activity.activity_type_id = @petition_signature
        ) AS diem_activities
        
GROUP BY subject
ORDER BY signatures DESC;



 