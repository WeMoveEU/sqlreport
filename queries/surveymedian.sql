select entity_id,mail.scheduled_date from website.field_data_field_mailing_id join civicrm_mailing_abtest on id=field_mailing_id_value join civicrm_mailing mail on mail.id=mailing_id_a
join 
(SELECT nid,avg(t1.completed) as median_completed FROM (
SELECT @rownum:=@rownum+1 as `rownumber`, d.completed
  FROM webform_submissions d,  (SELECT @rownum:=0) r
  -- put some where clause here
  where nid=353
  ORDER BY d.completed
) as t1, 
(
  SELECT count(*) as total_rows
  FROM webform_submissions d
  WHERE nid=353
  -- put same where clause here
) as t2
WHERE 1
AND t1.rownumber in ( floor((total_rows+1)/2), floor((total_rows+2)/2) )) as median
on entity_id=nid;
