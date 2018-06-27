update civicrm_contribution c left join civicrm_value_utm_5 on entity_id=c.id and campaign_id is null join civicrm_mailing m on utm_source_30 like "civimail-%" and m.id = substring(utm_source_30,10) set c.campaign_id=m.campaign_id;

update civicrm_contribution c left join civicrm_value_utm_5 on entity_id=c.id join civicrm_campaign camp on camp.id=c.campaign_id   join civicrm_mailing m on utm_source_30 like "civimail-%" and m.id = substring(utm_source_30,10) and m.campaign_id is not null set c.campaign_id = m.campaign_id where camp.parent_id=1363;
