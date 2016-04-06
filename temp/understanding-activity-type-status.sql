
set @share:= 54;
set @signature:=32;
set @created_pet:=55;
set @leave:=56;
set @join:=57;

set @scheduled=1;
set @completed=2;
set @optout=4;
set @completed_new=9; 
-- aka "optin"



select v.id, v.value, v.label, v.name from civicrm_option_value v 
join civicrm_option_group g on v.option_group_id = g.id and g.name="activity_type" 
-- where v.value in (32,54,55,56,57)
;

select v.id, v.value, v.label, v.name from civicrm_option_value v 
join civicrm_option_group g on v.option_group_id = g.id and g.name="activity_type" 
where v.value in (32,54,55,56,57)
;



select * from civicrm_option_group; 

select * from civicrm_option_value;


select v.id, v.value, v.label, v.name from civicrm_option_value v 
join civicrm_option_group g on v.option_group_id = g.id and g.name="activity_type" 
where v.value in (32,54,56,57);
 

select v.id, v.value, v.label, v.name from civicrm_option_value v 
join civicrm_option_group g on v.option_group_id = g.id and g.name="activity_type" and v.name="Join"
;


