CREATE TABLE tmp_contact_share (
  id INTEGER UNSIGNED PRIMARY KEY,
  share_activities INTEGER UNSIGNED NOT NULL DEFAULT 0,
  shared_campaigns INTEGER UNSIGNED NOT NULL DEFAULT 0,
  brought_signs INTEGER UNSIGNED NOT NULL DEFAULT 0,
  brought_members INTEGER UNSIGNED NOT NULL DEFAULT 0,
  brought_shares INTEGER UNSIGNED NOT NULL DEFAULT 0,
  signed_shares INTEGER UNSIGNED NOT NULL DEFAULT 0,
  growthy_shares INTEGER UNSIGNED NOT NULL DEFAULT 0,
  viral_shares INTEGER UNSIGNED NOT NULL DEFAULT 0,
  effective_shares INTEGER UNSIGNED NOT NULL DEFAULT 0,
  effective_campaigns INTEGER UNSIGNED NOT NULL DEFAULT 0
);

INSERT INTO tmp_contact_share (id) SELECT id FROM civicrm_contact;

UPDATE tmp_contact_share tcs 
JOIN (
  SELECT 
    contact_id, 
    COUNT(ac.activity_id) AS share_activities, 
    COUNT(DISTINCT campaign_id) AS shared_campaigns,
    IFNULL(SUM(signatures_46), 0) AS brought_signs, 
    IFNULL(SUM(signatures_46 > 0), 0) AS signed_shares,
    IFNULL(SUM(new_members_48), 0) AS brought_members, 
    IFNULL(SUM(new_members_48 > 0), 0) AS growthy_shares,
    IFNULL(SUM(shares_47), 0) AS brought_shares, 
    IFNULL(SUM(shares_47 > 0), 0) AS viral_shares
  FROM civicrm_value_share_params_6 sh 
  JOIN civicrm_activity_contact ac ON ac.activity_id=sh.entity_id AND record_type_id=2
  JOIN civicrm_activity a ON a.id=sh.entity_id
  GROUP BY contact_id
) d ON d.contact_id=tcs.id
SET 
  tcs.share_activities=d.share_activities,
  tcs.shared_campaigns=d.shared_campaigns,
  tcs.brought_signs=d.brought_signs,
  tcs.brought_members=d.brought_members,
  tcs.brought_shares=d.brought_shares,
  tcs.signed_shares=d.signed_shares,
  tcs.growthy_shares=d.growthy_shares,
  tcs.viral_shares=d.viral_shares
;

UPDATE tmp_contact_share tcs 
JOIN (
  SELECT 
    contact_id, 
    COUNT(ac.activity_id) AS effective_shares, 
    COUNT(DISTINCT campaign_id) AS effective_campaigns
  FROM civicrm_value_share_params_6 sh 
  JOIN civicrm_activity_contact ac ON ac.activity_id=sh.entity_id AND record_type_id=2
  JOIN civicrm_activity a ON a.id=sh.entity_id
  WHERE signatures_46 > 0 OR new_members_48 > 0 OR shares_47 > 0
  GROUP BY contact_id
) d ON d.contact_id=tcs.id
SET
  tcs.effective_shares=d.effective_shares,
  tcs.effective_campaigns=d.effective_campaigns
;