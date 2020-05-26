SELECT
    number_of_mails ,
    SUM(number_of_members) as total,
    SUM(IF(language = 'de_DE',
        number_of_members,
        0)) AS de_DE,
    SUM(IF(language = 'en_GB',
        number_of_members,
        0)) AS en_GB,
    SUM(IF(language = 'es_ES',
        number_of_members,
        0)) AS es_ES,
    SUM(IF(language = 'fr_FR',
        number_of_members,
        0)) AS fr_FR,
    SUM(IF(language = 'it_IT',
        number_of_members,
        0)) AS it_IT,
    SUM(IF(language = 'en_US',
        number_of_members,
        0)) AS en_US,
        SUM(IF(language NOT in ('en_US', "en_GB", "fr_FR", "de_DE", "it_IT", "es_ES"),
        number_of_members,
        0)) AS other

FROM
    (SELECT
        membermails.number_of_mails AS number_of_mails,
            membermails.preferred_language as language,
            COUNT(*) AS number_of_members
    FROM
        (SELECT
        c.id AS id,
            c.preferred_language AS preferred_language,
            SUM(IF(queue.contact_id IS NULL, 0, 1)) AS number_of_mails
    FROM
        civicrm_contact c
    JOIN civicrm_group_contact g ON g.contact_id = c.id AND g.group_id = 42
    AND c.is_deleted = 0
        AND c.is_opt_out = 0
        AND g.status = 'Added'
    JOIN civicrm_email e ON e.contact_id = c.id
        AND e.is_primary IS TRUE
        AND e.on_hold = 0
    LEFT JOIN (civicrm_mailing_event_queue queue
    JOIN civicrm_mailing_event_delivered del ON del.event_queue_id = queue.id
        AND del.time_stamp > DATE_ADD(NOW(), INTERVAL - 10 DAY)) ON c.id = queue.contact_id
    GROUP BY c.id
    ORDER BY number_of_mails DESC) AS membermails
    GROUP BY number_of_mails , membermails.preferred_language
    ORDER BY number_of_mails , number_of_members DESC) AS mails_sent
GROUP BY number_of_mails
ORDER BY number_of_mails
;
