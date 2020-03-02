DROP TABLE IF EXISTS tmp_petition_metrics;
CREATE TABLE tmp_petition_metrics (
  campaign_id INT UNSIGNED,
  parent_id INT UNSIGNED,
  activity VARCHAR(255),
  status VARCHAR(255),
  speakout_id INT(11) NULL,
  speakout_name VARCHAR(255) NULL,
  speakout_title VARCHAR(255) NULL, -- empty, not used?
  language VARCHAR(5) NULL,
  country VARCHAR(255) NULL, -- empty, not used?
  npeople INT UNSIGNED NULL,
  is_opt_out TINYINT(4) NULL,
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  need_refresh TINYINT NOT NULL DEFAULT 1,
  KEY tmp_petition_metrics_campaign_id_key (campaign_id),
  KEY tmp_petition_metrics_parent_id_key (parent_id)
);
