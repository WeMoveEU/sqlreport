/* https://trello.com/c/iShmxcGL/925-how-to-export-all-eci-contacts-for-main-partner */

SELECT 
  ac.contact_id,
  c.display_name,
  e.email,
  cntry.name AS country,
  a.activity_date_time AS signature_date,
  IF(gdpr.consent_version_57 IS NULL OR gdpr.consent_version_57='', 'no', 'yes') AS wemove_member,
  camp.name AS campaign
FROM civicrm_activity a 
JOIN civicrm_activity_contact ac ON a.id=ac.activity_id
JOIN civicrm_campaign camp ON camp.id=a.campaign_id
JOIN civicrm_contact c ON c.id=ac.contact_id
JOIN civicrm_email e ON e.contact_id=c.id AND e.is_primary=1
JOIN civicrm_address addr ON addr.contact_id=c.id AND addr.is_primary=1
JOIN civicrm_country cntry ON cntry.id=addr.country_id
JOIN civicrm_activity_contact acdpa ON acdpa.contact_id=c.id
JOIN civicrm_activity dpa ON dpa.id=acdpa.activity_id AND dpa.activity_type_id=68 AND dpa.campaign_id=camp.id
LEFT JOIN civicrm_value_gdpr_temporary_9 gdpr ON gdpr.entity_id=c.id
WHERE camp.name LIKE 'mig_%' AND campaign_type_id=9
  AND a.activity_type_id=32 AND a.status_id=9
  AND dpa.subject LIKE '%.mig.%'
;
