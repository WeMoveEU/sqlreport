UPDATE civicrm_mailing m
  JOIN civicrm_value_speakout_integration_2 c ON entity_id=m.campaign_id
  LEFT JOIN civicrm_mailing_component optout ON optout.name = CONCAT('OptOut-', SUBSTRING(language_4, 1, 2))
  SET language = language_4,
      optout_id = COALESCE(optout.id, 7)
  WHERE language is NULL
;
update civicrm_mailing  set language="en_UK" where language="en_GB" and (name like "%UK-EN" or  name like "%UK-EN)");
