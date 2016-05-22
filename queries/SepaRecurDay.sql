select status, date(M.date) as date, count(*) as qty, sum(amount) total, avg(amount) avg from civicrm_contribution_recur as R join civicrm_sdd_mandate M on R.id=M.entity_id and M.entity_table="civicrm_contribution_recur"  group by contribution_status_id, date(create_date) order by date desc, status desc;