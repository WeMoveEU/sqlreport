select receive_date as date,
SUM(if (recur=0 and instrument='1' and status=1,total,0)) as €_card,
SUM(if (recur=0 and instrument='5' and status=1,total,0)) as €_wire,
SUM(if (recur=0 and instrument in (6,7,8) and status in (1),total,0)) as €_sepa,
SUM(if (recur=1 and instrument='1' and status=1,total,0)) as €_recur_card,
/*SUM(if (recur=1 and instrument='5' and status=1,total,0)) as €_recur_wire,*/
SUM(if (recur=1 and instrument in (6,7,8) and status in (1),total,0)) as €_recur_sepa,

SUM(if (recur=0 and instrument in (6,7,8) and status in (2,5),total,0)) as €_pending_sepa,
SUM(if (recur=1 and instrument in (6,7,8) and status in (2,5),total,0)) as €_pending_recur_sepa,

SUM(if (recur=0 and status in (1,2,5),count,0)) as qty_single,
SUM(if (recur=1 and instrument in (1,7) and status in (1),count,1)) as qty_recur,
SUM(if (recur=1 and instrument in (6) and status in (1),count,1)) as qty_first,
SUM(if (recur=1 and status not in (1,2,5),count,1)) as qty_failed,
SUM(if (status in (2,5),count,1)) as qty_pending


from (
SELECT 
(if (contribution_recur_id is null,0,1)) recur,
payment_instrument_id as instrument,
contribution_status_id as status,
contribution_status_id,COUNT(*) as count,DATE_FORMAT(receive_date, '%Y-%m') as receive_date, SUM(total_amount) as total 
from civicrm_contribution c
WHERE receive_date is not null AND ( c.is_test = 0 OR c.is_test = NULL) AND receive_date <> '0000-00-00' 
AND financial_type_id in (1,3)
group by YEAR(receive_date),MONTH(receive_date),payment_instrument_id,contribution_status_id 
,(case when contribution_recur_id is null then 0 else 1 end)
order by receive_date desc
) as contrib
group by receive_date order by receive_date desc;
/*

select name,value from civicrm_option_value where option_group_id=10;
+-------------+-------+
| name        | value |
+-------------+-------+
| Credit Card | 1     |
| Debit Card  | 2     |
| Cash        | 3     |
| Check       | 4     |
| EFT         | 5     |
| FRST        | 6     |
| RCUR        | 7     |
| OOFF        | 8     |
+-------------+-------+

seli ect name,value from civicrm_option_value where option_group_id = 11;
+----------------+-------+
| name           | value |
+----------------+-------+
| Completed      | 1     |
| Pending        | 2     |
| Cancelled      | 3     |
| Failed         | 4     |
| In Progress    | 5     |
| Overdue        | 6     |
| Refunded       | 7     |
| Partially paid | 8     |
| Pending refund | 9     |
+----------------+-------+
*/

