use civi_wemove;

SELECT 
    campaign_21 AS camp,
    source_22 AS source,
    media_23 AS media,
    COUNT(*) AS c
FROM
    civicrm_value_a2_1 utm
        JOIN
    civicrm_group_contact g ON utm.contact_id = g.contact_id
        AND g.group_id = 42
WHERE
    media_23 IN ('mail' , 'email')
GROUP BY media_23 , source_22 , campaign_21
ORDER BY c;

select campaign_21 as camp, source_22 as source, media_23 as media, count(*) as c from civicrm_value_a2_1 group by media_23, source_22, campaign_21;

SELECT 
    campaign_21 AS camp,
    source_22 AS source,
    media_23 AS media,
    COUNT(*) AS c
FROM
    civicrm_value_a2_1
        JOIN
    civicrm_group_contact g ON entity_id = g.contact_id
        AND g.group_id = 42
        AND status = 'Added'
WHERE

campaign_21="en_UK_20160913"
--    media_23 IN ('mail' , 'email')
GROUP BY media_23 , source_22 , campaign_21
ORDER BY c;

select * from civicrm_value_a2_1;

-- first signature of a contact is the field. 
-- it is also in petition 
-- and in petition signature. 