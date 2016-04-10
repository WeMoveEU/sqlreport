/*

Activity type
37              Petition Signature      Petition
813             share   share
8185    Leave   Leave
8186    Join    Join


Activity status
Scheduled       Scheduled
Completed       Completed
Opt-out optout
Completed New Member    optin


activity_type_id
32  Petition

*/
-- UK different subject on the join
select
  campaign_id as civi_camp_id, DATE_FORMAT(activity_date_time, '%Y-%m-%d %H-%i') as date, count(*) as qty, c.title as name, custom.language_4 as lang,
        sum(case when activity_type_id=32 then 1 end) as signatures,
    sum(case when activity_type_id=32 and a.status_id in (1,9,4) then 1 end) new_people_signing,
--  sum(case when a.status_id=2 and activity_type_id=32 then 1 end) as completed_existing_member,
  sum(case when a.status_id=9 and activity_type_id=32 then 1 end) as people_came_in,
  sum(case when a.status_id=1 and activity_type_id=32 then 1 end) as pending,
  sum(case when a.status_id=4 and activity_type_id=32 then 1 end) as optout,
  sum(case when activity_type_id=54 then 1 end) as share
--  ,sum(case when activity_type_id=57 then 1 end) as member_join,
--  sum(case when activity_type_id=56 then 1 end) as member_leave
from civicrm_activity a join civicrm_campaign c on campaign_id=c.id
join civicrm_value_speakout_integration_2 custom on entity_id=c.id
where activity_type_id in (32,54,56,57) and is_test=0
  and activity_date_time > DATE_ADD(now(), INTERVAL - 24 hour)
group by campaign_id, date
order by signatures desc, lang desc;

-- Having count(*) >1
-- DATE_ADD(now(), INTERVAL - 24 hour);
