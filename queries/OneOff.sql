select type, status, date(M.date) as date, count(*) as qty, sum(total_amount) total, avg(total_amount) avg from civicrm_contribution as C join civicrm_sdd_mandate M on C.id=M.entity_id and M.entity_table="civicrm_contribution"  group by status, date(creation_date) order by status desc, date desc;

