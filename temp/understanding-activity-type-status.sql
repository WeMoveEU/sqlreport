select * from civicrm_option_group; 

select * from civicrm_option_value;


select v.id, v.label, v.name from civicrm_option_value v 
join civicrm_option_group g on v.option_group_id = g.id and g.name="activity_type" 
where v.value in (32,54,56,57);

select v.id, v.label, v.name from civicrm_option_value v 
join civicrm_option_group g on v.option_group_id = g.id and g.name="activity_status" 
where v.value in (1,2,4,9);




