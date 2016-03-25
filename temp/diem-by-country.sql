SELECT 
country_id, country.name, count(*) as signatures
FROM
    civicrm_contact contact
        JOIN
    civicrm_activity_contact ac ON ac.contact_id = contact.id
        JOIN
    civicrm_activity activity ON ac.activity_id = activity.id
        AND activity.subject LIKE 'diem25%'
        AND activity.activity_type_id = 32
left join civicrm_address a on a.contact_id = contact.id
  LEFT JOIN
    civicrm_country country ON country.id = a.country_id
GROUP BY country_id
ORDER BY signatures DESC;


 