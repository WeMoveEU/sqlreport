SELECT 
    status,
    DATE(M.date) AS date,
    COUNT(*) AS qty,
    SUM(amount) total,
    CAST(AVG(amount) AS DECIMAL (5 , 2 )) AS avg
FROM
    civicrm_contribution_recur AS R
        JOIN
    civicrm_sdd_mandate M ON R.id = M.entity_id
        AND M.entity_table = 'civicrm_contribution_recur'
GROUP BY contribution_status_id , DATE(create_date)
ORDER BY date DESC , status DESC;
