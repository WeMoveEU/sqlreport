set @share:= 54;
set @signature:=32;
set @created_pet:=55;
set @leave:=56;
set @join:=57;

set @scheduled=1;
set @completed=2;
set @optout=4;
set @completed_new=9; 
set @member_group=42;

truncate table analytics_members_country_language; 

insert into analytics_members_country_language
(members, language, country_id) 
SELECT 
    COUNT(*), preferred_language, country_id
FROM
    civicrm_contact contact
        JOIN
    civicrm_group_contact gc ON contact.id = gc.contact_id
        AND gc.group_id = @member_group
        AND gc.status IN ('Added')
        LEFT JOIN
    civicrm_address address ON address.contact_id = contact.id
        AND address.is_primary = 1
        	where  is_deleted = 0 AND is_opt_out = 0
        group by preferred_language, country_id
;
  
 