select * from civicrm_contact;

select * from civicrm_address;


select count(*) from civicrm_contact;

SELECT 
    COUNT(*), a.country_id
FROM
    civicrm_contact c
        left JOIN
    civicrm_address a ON a.contact_id = c.id
    and a.is_primary=1 
group by a.country_id;
