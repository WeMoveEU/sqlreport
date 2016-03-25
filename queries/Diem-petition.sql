SELECT 
  asource.campaign_26 as local_group, count(contact.id) AS signatures
FROM
    civicrm_contact contact
        JOIN
    civicrm_activity_contact ac ON ac.contact_id = contact.id
        JOIN
    civicrm_activity activity ON ac.activity_id = activity.id
        AND activity.subject LIKE 'diem25%'
        AND activity.activity_type_id = 32
	 join civicrm_value_action_source_4 asource on asource.entity_id=activity.id and asource.source_27='diem25volunteers'
GROUP BY  local_group
ORDER BY signatures DESC;


 