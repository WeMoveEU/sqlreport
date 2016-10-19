-- new people by campaign and source_media_etc.

-- new_member, new_uk_member, new_it_member, new_fr_member: share e-mail
-- mail_share = 

SELECT 
    c.name AS campaign_name,
    CONVERT( c.external_identifier , SIGNED) AS speakout_id,
    custom.language_4 AS language,
    campaign_26 AS utm_campaign,
    SUM(CASE
        WHEN activity_type_id = 32 THEN 1
    END) AS total_signatures,
    SUM(CASE
        WHEN
            a.status_id = 9
                AND activity_type_id = 32
        THEN
            1
    END) AS new_member
FROM
    civicrm_activity a
        JOIN
    civicrm_campaign c ON campaign_id = c.id
        JOIN
    civicrm_value_speakout_integration_2 custom ON entity_id = c.id
        LEFT JOIN
    civicrm_value_action_source_4 utm ON a.id = utm.entity_id
WHERE
    activity_type_id IN (32) AND is_test = 0
        AND activity_date_time > '2016-06-01'
        AND (media_28 = 'post' OR media_28 = 'ad')
        AND source_27 = 'facebook'
GROUP BY campaign_id , campaign_26 , source_27 , media_28
ORDER BY speakout_id DESC , new_member DESC;

