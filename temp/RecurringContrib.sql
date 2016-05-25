SELECT 
    DATE(create_date) AS date,
    M.status,
    frequency_unit AS frequency,
    COUNT(*) AS nb,
    SUM(amount) sum,
    AVG(amount) avg
FROM
    civicrm_contribution_recur AS R
        JOIN
    civicrm_sdd_mandate M ON R.id = M.entity_id
        AND M.entity_table = 'civicrm_contribution_recur'
GROUP BY DATE(create_date) , status , frequency_unit
ORDER BY date DESC;
