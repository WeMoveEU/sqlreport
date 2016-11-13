-- goal: DE, FR, ... recurring, + DE, FR, etc. one-off, grouped by month. 
-- or better by list?  or by preferred language!
-- 

-- select preferred_language from civicrm_contact;


select date, 
sum(if (preferred_language="en_GB" and country_id != 1226, €_recur_sepa + €_recur_card + €_pending_recur_sepa, 0)) as int_EN_recur,
sum(if (preferred_language="de_DE" , €_recur_sepa + €_recur_card + €_pending_recur_sepa, 0)) as de_DE_recur,
sum(if (preferred_language="en_GB" and country_id = 1226, €_recur_sepa + €_recur_card + €_pending_recur_sepa, 0)) as UK_recur,
sum(if (preferred_language="es_ES", €_recur_sepa + €_recur_card + €_pending_recur_sepa, 0)) as es_ES_recur,
sum(if (preferred_language="fr_FR", €_recur_sepa + €_recur_card + €_pending_recur_sepa, 0)) as fr_FR_recur,
sum(if (preferred_language="it_IT", €_recur_sepa + €_recur_card + €_pending_recur_sepa, 0)) as it_IT_recur,
sum(if (preferred_language="pl_PL", €_recur_sepa + €_recur_card + €_pending_recur_sepa, 0)) as pl_PL_recur,
sum(if (preferred_language not in ("en_GB", "de_DE", "es_ES", "fr_FR", "it_IT", "pl_PL"), €_recur_sepa + €_recur_card + €_pending_recur_sepa, 0)) as other_recur,

sum(if (preferred_language="en_GB" and country_id != 1226, €_sepa + €_card + €_wire + €_pending_sepa, 0)) as int_EN_ooff,
sum(if (preferred_language="de_DE" , €_sepa + €_card + €_wire + €_pending_sepa, 0)) as de_DE_ooff ,
sum(if (preferred_language="en_GB" and country_id = 1226, 
€_sepa + €_card + €_wire + €_pending_sepa, 0)) as UK_ooff,
sum(if (preferred_language="es_ES", €_sepa + €_card + €_wire + €_pending_sepa, 0)) as es_ES_ooff,
sum(if (preferred_language="fr_FR", €_sepa + €_card + €_wire + €_pending_sepa, 0)) as fr_FR_ooff,
sum(if (preferred_language="it_IT", €_sepa + €_card + €_wire + €_pending_sepa, 0)) as it_IT_ooff,
sum(if (preferred_language="pl_PL", €_sepa + €_card + €_wire + €_pending_sepa, 0)) as pl_PL_ooff,
sum(if (preferred_language not in ("en_GB", "de_DE", "es_ES", "fr_FR", "it_IT", "pl_PL"), 
€_sepa + €_card + €_wire + €_pending_sepa, 0)) as other_ooff




from (
SELECT 
    receive_date AS date,
    preferred_language,
    country_id,
    SUM(IF(recur = 0 AND instrument = '1'
            AND status = 1,
        total,
        0)) AS €_card,
    SUM(IF(recur = 0 AND instrument = '5'
            AND status = 1,
        total,
        0)) AS €_wire,
    SUM(IF(recur = 0 AND instrument IN (6 , 7, 8)
            AND status IN (1),
        total,
        0)) AS €_sepa,
    SUM(IF(recur = 1 AND instrument = '1'
            AND status = 1,
        total,
        0)) AS €_recur_card,
    SUM(IF(recur = 1 AND instrument IN (6 , 7, 8)
            AND status IN (1),
        total,
        0)) AS €_recur_sepa,
    SUM(IF(recur = 0 AND instrument IN (6 , 7, 8)
            AND status IN (2 , 5),
        total,
        0)) AS €_pending_sepa,
    SUM(IF(recur = 1 AND instrument IN (6 , 7, 8)
            AND status IN (2 , 5),
        total,
        0)) AS €_pending_recur_sepa,
    SUM(IF(recur = 0 AND status IN (1 , 2, 5),
        count,
        0)) AS qty_single,
    SUM(IF(recur = 1 AND instrument IN (1 , 7)
            AND status IN (1),
        count,
        1)) AS qty_recur,
    SUM(IF(recur = 1 AND instrument IN (6)
            AND status IN (1),
        count,
        1)) AS qty_first,
    SUM(IF(recur = 1 AND status NOT IN (1 , 2, 5),
        count,
        1)) AS qty_failed,
    SUM(IF(status IN (2 , 5), count, 1)) AS qty_pending
FROM
    (SELECT 
        (IF(contribution_recur_id IS NULL, 0, 1)) recur,
            payment_instrument_id AS instrument,
            contribution_status_id AS status,
            contribution_status_id,
            COUNT(*) AS count,
            DATE_FORMAT(receive_date, '%Y-%m') AS receive_date,
            SUM(total_amount) AS total,
            contact.preferred_language AS preferred_language,
            address.country_id as country_id
    FROM
        civicrm_contribution c
    JOIN civicrm_contact contact ON c.contact_id = contact.id
    join civicrm_address address ON address.contact_id = contact.id
        AND address.is_primary = 1
	WHERE
        receive_date IS NOT NULL
            AND (c.is_test = 0 OR c.is_test = NULL)
            AND receive_date <> '0000-00-00'
            AND financial_type_id IN (1 , 3)
    GROUP BY YEAR(receive_date) , MONTH(receive_date) , payment_instrument_id , contribution_status_id , (CASE
        WHEN contribution_recur_id IS NULL THEN 0
        ELSE 1
    END), preferred_language, country_id
    ORDER BY receive_date DESC) AS contrib
GROUP BY receive_date, preferred_language, country_id
ORDER BY receive_date DESC) as monthly_contrib
group by date
ORDER BY date DESC
;


/*

select * from civicrm_country
where name in ("Germany", "United kingdom", "France", "Italy", "Spain") ;

1076	France
1082	Germany
1107	Italy
1198	Spain
1226	United Kingdom

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

