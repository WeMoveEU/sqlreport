SELECT 
    utm_campaign_33 AS camp,
--    DATE(create_date) AS date,
    R.currency,
    pp.name,
    status.name AS status_contrib,
    M.status,
    frequency_unit AS frequency,
    COUNT(*) AS nb,
amount

FROM
    civicrm_contribution_recur AS R
        LEFT JOIN
    civicrm_payment_processor pp ON payment_processor_id = pp.id
        LEFT JOIN
    civicrm_option_value status ON option_group_id = 11
        AND contribution_status_id = status.value
        LEFT JOIN
    civicrm_sdd_mandate M ON R.id = M.entity_id
        AND M.entity_table = 'civicrm_contribution_recur'
        JOIN
    civicrm_contribution c ON contribution_recur_id = R.id
        LEFT JOIN
    civicrm_value_utm_5 utm ON c.id = utm.entity_id
GROUP BY utm_campaign_33 ,  R.contribution_status_id , pp.id , status , currency , frequency_unit, amount
ORDER BY camp DESC; 

#select date(create_date) as date, currency, pp.name, status.name as status_contrib, M.status, frequency_unit as frequency, count(*) as nb, sum(amount) sum, avg(amount) avg from civicrm_contribution_recur  as R join civicrm_payment_processor pp on payment_processor_id=pp.id left join civicrm_option_value status on option_group_id=11 and contribution_status_id=status.value left join civicrm_sdd_mandate M on R.id=M.entity_id and M.entity_table="civicrm_contribution_recur" join  civicrm_contribution c on contribution_recur_id=R.id left join civicrm_value_utm_5 utm on c.id=entity_id limit 10 group by utm_campaign_30, date(create_date), contribution_status_id,pp.id,status, currency, frequency_unit order by date desc;
