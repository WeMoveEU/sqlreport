select DATE(created_date) as date, count(*) as total from civicrm_contact group by date order by date desc limit 10;
