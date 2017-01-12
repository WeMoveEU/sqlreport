select civicrm_country.iso_code as country,
  currency,
  avg(total_amount) as amount,
  count(*) as nb

INTO OUTFILE '/tmp/avg-oneoff.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n'

from civicrm_contribution cont 
  join civicrm_contact c on c.id=cont.contact_id 
  left join civicrm_address a on a.contact_id=c.id and a.is_primary=1 
  join civicrm_country on a.country_id=civicrm_country.id 
where financial_type_id=1  /* and payment_instrument_id in ('1', '8') */
  and total_amount<1000
  and contribution_recur_id is NULL
group by country, currency;
