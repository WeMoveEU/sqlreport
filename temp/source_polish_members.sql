SELECT 
    source, COUNT(*) AS members
FROM
    civicrm_contact contact
        JOIN
    civicrm_group_contact gc ON gc.contact_id = contact.id
        AND gc.group_id = 42
        AND gc.status = 'Added'
        JOIN
    civicrm_address address ON address.contact_id = contact.id
        JOIN
    civicrm_country country ON address.country_id = country.id
    and country.name ="Poland"
GROUP BY source
ORDER BY members DESC
;
