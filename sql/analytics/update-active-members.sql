

SET @yesterday=DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY);

INSERT IGNORE INTO analytics_active_3m (kpidate, language, country_id, active)
  SELECT 
      @yesterday, language, IF(ISNULL(country_id), 0, country_id), COUNT(t.contact_id) AS active
  FROM
      (SELECT 
        gc.contact_id,
        c.preferred_language AS language
      FROM
          civicrm_contact c
      JOIN civicrm_group_contact gc ON c.id = gc.contact_id
      JOIN civicrm_email email ON email.contact_id = c.id
      JOIN civicrm_activity_contact ac1 ON gc.contact_id = ac1.contact_id
      JOIN civicrm_activity a1 ON ac1.activity_id = a1.id
      WHERE
          c.is_opt_out = 0 
          AND c.preferred_language IS NOT NULL
          AND gc.group_id = 42
          AND gc.status = 'Added'
          AND email.is_primary IS TRUE
          AND email.on_hold = 0
          AND a1.activity_type_id IN (6, 28, 32)
          AND a1.activity_date_time >= DATE_ADD(@yesterday, INTERVAL - 3 MONTH)
          AND a1.activity_date_time <= @yesterday
          AND a1.activity_date_time >= DATE_ADD(c.created_date, INTERVAL 1 DAY)
      GROUP BY gc.contact_id
      ) t
  LEFT JOIN civicrm_address address 
      ON address.contact_id = t.contact_id
      AND address.is_primary = 1
  GROUP BY language, country_id
;

INSERT IGNORE INTO analytics_active_1m (kpidate, language, country_id, active)
  SELECT 
      @yesterday, language, IF(ISNULL(country_id), 0, country_id), COUNT(t.contact_id) AS active
  FROM
      (SELECT 
        gc.contact_id,
        c.preferred_language AS language
      FROM
          civicrm_contact c
      JOIN civicrm_group_contact gc ON c.id = gc.contact_id
      JOIN civicrm_email email ON email.contact_id = c.id
      JOIN civicrm_activity_contact ac1 ON gc.contact_id = ac1.contact_id
      JOIN civicrm_activity a1 ON ac1.activity_id = a1.id
      WHERE
          c.is_opt_out = 0 
          AND c.preferred_language IS NOT NULL
          AND gc.group_id = 42
          AND gc.status = 'Added'
          AND email.is_primary IS TRUE
          AND email.on_hold = 0
          AND a1.activity_type_id IN (6, 28, 32)
          AND a1.activity_date_time >= DATE_ADD(@yesterday, INTERVAL - 1 MONTH)
          AND a1.activity_date_time <= @yesterday
          AND a1.activity_date_time >= DATE_ADD(c.created_date, INTERVAL 1 DAY)
      GROUP BY gc.contact_id
      ) t
  LEFT JOIN civicrm_address address 
      ON address.contact_id = t.contact_id
      AND address.is_primary = 1
  GROUP BY language, country_id
;

SET @fourmonthsago = DATE_ADD(@yesterday, INTERVAL - 4 MONTH);
SET @twomonths = DATEDIFF(@yesterday, @fourmonthsago) / 2;

INSERT IGNORE INTO analytics_active_2m_decay_4m (kpidate, language, country_id, active)
  SELECT 
      @yesterday, language, IF(ISNULL(country_id), 0, country_id), SUM(t.active_value) AS active
  FROM
      (SELECT 
        gc.contact_id,
        c.preferred_language AS language,
        LEAST(
          1, 
          2 - (DATEDIFF(@yesterday, MAX(a1.activity_date_time)) / @twomonths)
        ) AS active_value
      FROM
          civicrm_contact c
      JOIN civicrm_group_contact gc ON c.id = gc.contact_id
      JOIN civicrm_email email ON email.contact_id = c.id
      JOIN civicrm_activity_contact ac1 ON gc.contact_id = ac1.contact_id
      JOIN civicrm_activity a1 ON ac1.activity_id = a1.id
      WHERE
          c.is_opt_out = 0 
          AND c.preferred_language IS NOT NULL
          AND gc.group_id = 42
          AND gc.status = 'Added'
          AND email.is_primary IS TRUE
          AND email.on_hold = 0
          AND a1.activity_type_id IN (6, 28, 32)
          AND a1.activity_date_time >= @fourmonthsago
          AND a1.activity_date_time <= @yesterday
          AND a1.activity_date_time >= DATE_ADD(c.created_date, INTERVAL 1 DAY)
      GROUP BY gc.contact_id
      ) t
  LEFT JOIN civicrm_address address 
      ON address.contact_id = t.contact_id
      AND address.is_primary = 1
  GROUP BY language, country_id
;
