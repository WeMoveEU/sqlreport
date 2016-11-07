select date,
SUM(if (name='direct debit' and status!=1,total,0)) as €_sepa,
SUM(if (name='Credit Card' and status in(2,5),total,0)) as €_credit_card,
SUM(if (name='Paypal' and status in(2),total,0)) as €_paypal,

SUM(if (name='direct debit' and status!=1,qty,0)) as qty_sepa,
SUM(if (name='Credit Card' and status in(2,5),qty,0)) as qty_credit_card,
SUM(if (name='Paypal' and status in(2),qty,0)) as qty_paypal,

SUM(if (status in(2,5),qty,0)) as qty_ok,
SUM(if (status in(2,5),18*total,0)) as €_ok,

SUM(if (status not in(2,5),qty,0)) as qty_nok,
SUM(if (status not in(2,5),total,0)) as €_nok



from (
select  pp.name, contribution_status_id as status, count(*) as qty,sum(amount) as total, DATE_FORMAT(create_date, '%Y-%m') as date from civicrm_contribution_recur join civicrm_payment_processor pp on pp.id=payment_processor_id group by YEAR(create_date),MONTH(create_date), payment_processor_id ,payment_instrument_id,contribution_status_id order by date desc
) as rcur group by date order by date desc;


/*
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



