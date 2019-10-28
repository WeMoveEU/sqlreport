INSERT INTO analytics_calculation_times ( calculation ) VALUES ("before member calculation 1");

TRUNCATE TABLE analytics_member_metrics;

INSERT INTO analytics_member_metrics
  (number_added, number_removed, added_date, language, country_id)
  SELECT
    COUNT(*),
    0,
    DATE(hist.date) AS added_date,
    preferred_language,
    country_id

  FROM civicrm_contact AS contact
  JOIN civicrm_subscription_history hist
    ON hist.contact_id = contact.id AND hist.group_id = 42 AND hist.status = 'Added'
  LEFT JOIN civicrm_address address
    ON address.contact_id = contact.id AND address.is_primary

  GROUP BY added_date, preferred_language, country_id
;

INSERT INTO analytics_calculation_times ( calculation ) VALUES ("after member calculation 1");

INSERT INTO analytics_member_metrics
(number_added, number_removed, added_date, language, country_id)
  SELECT
    0,
    COUNT(*),
    DATE(hist.date) AS added_date,
    preferred_language,
    country_id

  FROM civicrm_contact contact
  JOIN civicrm_subscription_history hist
    ON contact.id = hist.contact_id AND hist.group_id = 42 AND hist.status = 'Removed'
	LEFT JOIN civicrm_address address
    ON address.contact_id = contact.id AND address.is_primary
  GROUP BY added_date, preferred_language, country_id;

INSERT INTO analytics_calculation_times ( calculation ) VALUES ("after member calculation 2");

