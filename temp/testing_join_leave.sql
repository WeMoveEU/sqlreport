select * from analytics_delta_t_h ;

select * from analytics_member_metrics_dt; 


select count(*) from 
civicrm_activity a 
  join civicrm_activity_contact ac on a.id = ac.activity_id
    join civicrm_contact c on c.id = ac.contact_id and source != "change.org" 
where a.activity_type_id = @join
    and 
    a.is_test=0;
    
select min(activity_date_time) from 
civicrm_activity a 
where a.activity_type_id = @join
    and 
    a.is_test=0;   
   
	select @leave; 

		select count(*) from 
	civicrm_activity a 
	  where a.activity_type_id = @leave
		and 
		a.is_test=0;

select min(activity_date_time) from 
civicrm_activity a 
where a.activity_type_id = @leave
    and 
    a.is_test=0;


    