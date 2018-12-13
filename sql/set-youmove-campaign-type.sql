UPDATE civicrm_campaign 
  SET campaign_type_id=6 
  WHERE CAST(external_identifier AS UNSIGNED) > 10000 
    AND campaign_type_id=4;
