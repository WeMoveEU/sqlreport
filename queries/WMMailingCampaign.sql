select m.id, m.name, c.id campaign_id,c.parent_id, c.name campaign from civicrm_mailing m join civicrm_campaign c where c.id=m.campaign_id and m.name not like "%-Reminder-%CAMP-ID-%" order by m.id;
