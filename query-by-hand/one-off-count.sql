select nb_donations, count(id) as nb_donors
from (
  select c.id, count(c.id) as nb_donations
  from civicrm_contact c join civicrm_contribution d
  on c.id=d.contact_id
  where financial_type_id=1 
    and total_amount<1000
    and contribution_recur_id is NULL
  group by c.id
) as t
group by nb_donations;
