update civicrm_campaign c join (select id as p_id,name, SUBSTRING(name, 1, CHAR_LENGTH(name) - 3) AS parent from civicrm_campaign where name like "%_EN") p on c.name like concat(parent,"%") and c.parent_id is null set c.parent_id=p_id;

update civicrm_campaign c join (select id as p_id,name, SUBSTRING(name, 1, CHAR_LENGTH(name) - 3) AS parent from civicrm_campaign where name like "%-EN") p on c.name like concat(parent,"%") and c.parent_id is null set c.parent_id=p_id;

update civicrm_campaign c join (select id as p_id,name, SUBSTRING(name, 1, CHAR_LENGTH(name) - 6) AS parent from civicrm_campaign where name like "%INT-EN") p on c.name like concat(parent,"%") and c.parent_id is null set c.parent_id=p_id;

#update civicrm_campaign c join (select id as p_id,name, SUBSTRING(name, 1, CHAR_LENGTH(name) - 6) AS parent, name as p_name from civicrm_campaign where name like "%INT-EN") p on c.name like concat(parent,"%")  and (c.parent_id is null or c.parent_id=c.id)  set c.parent_id=p_id where c.name like "%UK-EN";

