update civicrm_mailing m join civicrm_value_speakout_integration_2 c on entity_id=m.campaign_id set  language= language_4 where language is NULL;
update civicrm_mailing  set language="en_UK" where language="en_GB" and (name like "%UK-EN" or  name like "%UK-EN)");
