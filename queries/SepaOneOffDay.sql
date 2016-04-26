select status, date(creation_date) as date, count(*) as qty, sum(total_amount) as total, avg(total_amount) avg from civicrm_contribution C join civicrm_sdd_mandate M on C.id=M.entity_id and M.entity_table="civicrm_contribution" group by status desc,date(creation_date) desc;

