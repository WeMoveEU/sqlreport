(select type, DATE_FORMAT(M.date, '%Y-%m-01') as date /*,date(M.date) as datei*/, civicrm_country.iso_code as country, M.status, "" as frequency_unit, count(*) as qty, sum(total_amount) total, avg(total_amount) avg from civicrm_contribution as C join civicrm_sdd_mandate M on C.id=M.entity_id and M.entity_table="civicrm_contribution"  
left join civicrm_address A on C.contact_id=A.contact_id and A.is_primary=1 left join civicrm_country on civicrm_country.id=A.country_id
group by status, YEAR(M.date), DATE(M.date), country_id order by status desc, date desc)
UNION
(select type,  DATE_FORMAT(M.date, '%Y-%m-01') as date,  civicrm_country.iso_code as country, M.status, frequency_unit as frequency, count(*) as qty, sum(amount) sum, avg(amount) avg 
from civicrm_contribution_recur  as R join civicrm_sdd_mandate M on R.id=M.entity_id and M.entity_table="civicrm_contribution_recur"  
left join civicrm_address A on R.contact_id=A.contact_id and A.is_primary=1 left join civicrm_country on civicrm_country.id=A.country_id
group by YEAR(create_date), DATE(create_date), status, frequency_unit, country_id order by date desc)
;
