select substring(iban,1,2) as country, count(*) as total from civicrm_sdd_mandate group by country order by country; 
