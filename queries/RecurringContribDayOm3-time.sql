SELECT 

    utm_campaign_33 AS camp,
em.email as email,
create_date AS date_time,
    R.currency,
    pp.name,
    status.name AS status_contrib,
    M.status,
    frequency_unit AS frequency,
    COUNT(*) AS nb,
amount

FROM
    civicrm_contribution_recur AS R
        JOIN
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
   left join civicrm_email em on c.contact_id=em.contact_id and em.is_primary=1
WHERE R.is_test=0 AND c.is_test=0
GROUP BY utm_campaign_33 ,  email, R.contribution_status_id , pp.id , status , currency , frequency_unit, amount
ORDER BY date_time DESC; 
