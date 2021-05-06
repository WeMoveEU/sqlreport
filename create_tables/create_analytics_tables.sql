
drop table ab_mailings; 

create table ab_mailings
(
id int not null auto_increment,
abtest_id int,
recipients int, 
mails_delivered int,
mails_opened int,
/* start zeiten mailing a, mailing b */
scheduled_date_a datetime, 
stamp timestamp,
primary key(id)
);

-- goals per dates
DROP TABLE IF EXISTS analytics_goals_dates;
CREATE TABLE IF NOT EXISTS analytics_goals_dates (
  `id` INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `scope` VARCHAR(12) NOT NULL DEFAULT 'organization' COMMENT 'organization or one of language like en_GB, de_DE, pl_PL...',
  `metric` VARCHAR(45) NOT NULL COMMENT 'active_members, donations_count, donations_amount...',
  `begin` DATE NULL,
  `end` DATE NOT NULL COMMENT 'The goal should be filled out at this end date.',
  `goal` FLOAT NOT NULL,
  `actual` FLOAT NULL COMMENT 'Actual value of the metric at the end date',
  UNIQUE INDEX `analytics_goals_dates_unique` USING BTREE (`scope` ASC, `metric` ASC, `begin` ASC, `end` ASC))
  ENGINE = InnoDB
  COMMENT = 'Goals for organization or for languages (of members) per dates';

-- how to use
INSERT INTO analytics_goals_dates (scope, metric, `begin`, `end`, goal) VALUES
  ('organization', 'new_active_members', '2017-01-01', '2017-12-31', 250000),
  ('en_GB', 'new_active_members', '2017-01-01', '2017-12-31', 100000),
  ('de_DE', 'new_active_members', '2017-01-01', '2017-12-31', 80000),
  ('it_IT', 'new_active_members', '2017-01-01', '2017-12-31', 40000),
  ('fr_FR', 'new_active_members', '2017-01-01', '2017-12-31', 20000),
  ('es_ES', 'new_active_members', '2017-01-01', '2017-12-31', 10000);

INSERT INTO analytics_goals_dates (scope, metric, `begin`, `end`, goal) VALUES
  ('organization', 'new_active_members', '2017-01-01', '2017-03-31', 40000),
  ('organization', 'new_active_members', '2017-04-01', '2017-06-30', 60000),
  ('organization', 'new_active_members', '2017-07-01', '2017-09-30', 110000),
  ('organization', 'new_active_members', '2017-10-01', '2017-12-31', 40000);


-- Surveys that should be excluded from analytics
CREATE TABLE analytics_excluded_surveys (nid INT UNSIGNED NOT NULL PRIMARY KEY);

-- Denormalize ab mailings
CREATE TABLE `data_mailing_ab` (
  `id` int(10) unsigned NOT NULL COMMENT 'Id of mailing',
  `mailing_type` varchar(32) DEFAULT NULL COMMENT 'standalone, experiment or winner',
  `mailing_abtest_id` int(10) unsigned DEFAULT NULL COMMENT 'Id of mailing_abtest',
  `mailing_abtest_type` char(1) DEFAULT NULL COMMENT 'a, b or c',
  `category` varchar(32) DEFAULT NULL COMMENT 'launch,reminder,kicker,fundraiser,report_back...',
  PRIMARY KEY (`id`),
  KEY `data_mailing_ab_mailing_abtest_id_inx` (`mailing_abtest_id`)
);

-- Petition metrics
DROP TABLE IF EXISTS analytics_petition_metrics;
CREATE TABLE analytics_petition_metrics
(
  id INT NOT NULL AUTO_INCREMENT,
  speakout_id INT,
  campaign_id INT,
  speakout_name VARCHAR(255), /* TODO: join on campaign instead */
  speakout_title VARCHAR (255), /* TODO: join on campaign instead */
  language VARCHAR(5), /* TODO: join on campaign instead */
  country VARCHAR(255),
  npeople INT,
  activity VARCHAR(255), /* petition signature, share etc. */
  status VARCHAR(255), /* completed, scheduled etc. */
  is_opt_out TINYINT(4),
  parent_id INT,
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  need_refresh TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY(id)
);

