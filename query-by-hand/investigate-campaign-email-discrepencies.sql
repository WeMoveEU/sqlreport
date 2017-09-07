DROP TABLE IF EXISTS tmp_incorrect_campaign_in_mailings;
CREATE TABLE `tmp_incorrect_campaign_in_mailings` (
  `mailing_campaign_id` int(10) unsigned DEFAULT NULL COMMENT 'The campaign for which this mailing has been initiated.',
  `activity_campaign_id` int(10) unsigned DEFAULT NULL COMMENT 'The campaign for which this activity has been triggered.',
  `activity_campaign_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Name of the Campaign.',
  `source_27` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `signatures` bigint(21) NOT NULL DEFAULT 0 COMMENT 'Count of signatures',
  `mailing_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Mailing Name.',
  `mailing_id` int(10) unsigned NOT NULL COMMENT 'Mailing ID',
  KEY tmp_incorrect_campaign_in_mailings_mailing_campaign_id (mailing_campaign_id),
  KEY tmp_incorrect_campaign_in_mailings_activity_campaign_id (activity_campaign_id),
  KEY tmp_incorrect_campaign_in_mailings_mailing_id (mailing_id)
);

INSERT INTO tmp_incorrect_campaign_in_mailings
  SELECT
    m.campaign_id mailing_campaign_id, t.campaign_id activity_campaign_id, c.name activity_campaign_name,
    t.source_27, t.signatures, m.name mailing_name, m.id mailing_id
  FROM (SELECT
    a.campaign_id, v.source_27, count(a.id) signatures
  FROM civicrm_value_action_source_4 v
    JOIN civicrm_activity a ON a.id = v.entity_id
  WHERE v.source_27 LIKE 'civimail-%'
  GROUP BY a.campaign_id, v.source_27) t
    JOIN civicrm_mailing m ON concat('civimail-', m.id) = t.source_27
    JOIN civicrm_campaign c ON c.id = t.campaign_id;

-- list of incorrect campaign in mailings
SELECT
  signatures s, mailing_campaign_id AS mcamp, activity_campaign_id AS acamp, m.name AS sent_for, a.name AS signed_for,
  mailing_name
FROM tmp_incorrect_campaign_in_mailings
  LEFT JOIN civicrm_campaign m ON mailing_campaign_id = m.id
  JOIN civicrm_campaign a ON activity_campaign_id = a.id
WHERE (mailing_campaign_id != activity_campaign_id OR mailing_campaign_id IS NULL) AND signatures > 100
ORDER BY signatures DESC;

-- (to run on master)
-- generate list of update queries
SELECT CONCAT('UPDATE civicrm_mailing SET campaign_id = ', activity_campaign_id, ' WHERE id = ',
              replace(source_27, 'civimail-', ''), ';') qr
FROM tmp_incorrect_campaign_in_mailings
WHERE (mailing_campaign_id != activity_campaign_id OR mailing_campaign_id IS NULL) AND signatures > 100;

-- (to run on replica): update query
UPDATE civicrm_mailing m
  JOIN (SELECT * FROM tmp_incorrect_campaign_in_mailings
  WHERE (mailing_campaign_id != activity_campaign_id OR mailing_campaign_id IS NULL) AND signatures > 100) t
    ON t.mailing_id = m.id
SET campaign_id = t.activity_campaign_id;
