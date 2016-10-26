select 
date, 
SUM(if (type='OOFF' and status!='INVALID',total,0)) as €_ooff, 
SUM(if (type="RCUR" and status !="COMPLETE",total,0)) as €_rcur,

SUM(if (type="OOFF" and status!="INVALID",qty,0)) as ooff_mandate, 
SUM(if (type="RCUR" and status !="COMPLETE",qty,0)) as rcur_mandate, 

SUM(if (type="OOFF" and status="INVALID",total,0)) as €_invalid_ooff,
SUM(if (type="RCUR" and status ="COMPLETE",total,0)) as €_invalid_rcur,
SUM(if (type="OOFF" and status="INVALID",qty,0)) as invalid_ooff_mandates, 

SUM(if (type="RCUR" and status ="COMPLETE",qty,0)) as invalid_rcur_mandates

,SUM(if (status not in("COMPLETE","INVALID"), qty, 0)) as mandates
,SUM(if (status not in("COMPLETE","INVALID"), if (type="RCUR",total*18,total), 0)) as total

from
(
(select type, DATE_FORMAT(M.date, '%Y-%m') as date, M.status, "" as frequency, count(*) as qty, SUM(total_amount) total, avg(total_amount) avg from civicrm_contribution as C join civicrm_sdd_mandate M on C.id=M.entity_id and M.entity_table="civicrm_contribution"  
group by status, YEAR(M.date), MONTH(M.date), status order by date desc)
UNION
(select type,  DATE_FORMAT(M.date, '%Y-%m') as date, M.status, frequency_unit as frequency, count(*) as qty, SUM(amount) SUM, avg(amount) avg 
from civicrm_contribution_recur  as R join civicrm_sdd_mandate M on R.id=M.entity_id and M.entity_table="civicrm_contribution_recur"  
group by YEAR(create_date), MONTH(create_date), status order by date desc)
) as a
group by date
order by date desc;
