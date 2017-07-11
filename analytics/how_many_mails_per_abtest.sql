TRUNCATE TABLE ab_mailings;

INSERT INTO ab_mailings (abtest_id, recipients, scheduled_date_a)
  SELECT
    abtest.id AS abtest_id,
    (SELECT COUNT(r.id)
    FROM civicrm_mailing_recipients AS r
    WHERE r.mailing_id = mailing_a.id)
      +
    (SELECT COUNT(r.id)
    FROM civicrm_mailing_recipients AS r
    WHERE r.mailing_id = mailing_b.id) AS recipients,
    mailing_a.scheduled_date scheduled_date_a
  FROM
    civicrm_mailing_abtest abtest
    JOIN civicrm_mailing mailing_a ON abtest.mailing_id_a = mailing_a.id
    JOIN civicrm_mailing mailing_b ON abtest.mailing_id_b = mailing_b.id;
