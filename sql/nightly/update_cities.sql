UPDATE civicrm_address a
  JOIN geo.geonames g ON g.country_id = a.country_id AND g.postal_code = a.postal_code AND g.is_primary = 1
SET a.city = substr(g.city FROM 1 FOR 64), a.geo_code_1 = g.latitude, a.geo_code_2 = g.longitude
WHERE (a.city IS NULL OR a.city = '');
