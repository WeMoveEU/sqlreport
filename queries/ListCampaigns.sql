select start_date, c.id, title, language_4 as lang, url_campaign_8 as url, parent_id, external_identifier as speakout_id  from civicrm_campaign c join civicrm_value_speakout_integration_2 on entity_id=c.id order by parent_id desc, lang