

-- update renormalized ab mailings tables
INSERT IGNORE INTO data_mailing_ab (id, mailing_type, mailing_abtest_id, mailing_abtest_type)
  SELECT
    ab.mailing_id_a, m.mailing_type, ab.id, 'a'
  FROM civicrm_mailing_abtest ab JOIN civicrm_mailing m ON m.id = ab.mailing_id_a;

INSERT IGNORE INTO data_mailing_ab (id, mailing_type, mailing_abtest_id, mailing_abtest_type)
  SELECT
    ab.mailing_id_b, m.mailing_type, ab.id, 'b'
  FROM civicrm_mailing_abtest ab JOIN civicrm_mailing m ON m.id = ab.mailing_id_b;

INSERT IGNORE INTO data_mailing_ab (id, mailing_type, mailing_abtest_id, mailing_abtest_type)
  SELECT
    ab.mailing_id_c, m.mailing_type, ab.id, 'c'
  FROM civicrm_mailing_abtest ab JOIN civicrm_mailing m ON m.id = ab.mailing_id_c;


