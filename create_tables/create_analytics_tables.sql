
use analytics;


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

/* 

create table analytics_surveys 
(
id int not null auto_increment,
nid int,
internal_name varchar(255),
scheduled_date datetime,
abtest_id int, 
mails_received int,
-- ++, + , - , -- ,?
total_pp int, 
total_p int,
total_m int,
total_mm int,
total_q int, 
h2_pos int,
h5_pos int,
h24_pos int,
h48_pos int,
stamp timestamp,
primary key(id)
);

*/


-- goals per periods
DROP TABLE IF EXISTS analytics_goals_period;
CREATE TABLE IF NOT EXISTS analytics_goals_period (
  `id` INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `scope` VARCHAR(12) NOT NULL DEFAULT 'organization' COMMENT 'organization or one of language like en_GB, de_DE, pl_PL...',
  `factor` VARCHAR(45) NOT NULL COMMENT 'active_members, donations_count, donations_amount...',
  `year` INT NOT NULL COMMENT 'YYYY',
  `quarter` INT NULL COMMENT '1..4',
  `month` INT NULL COMMENT '1..12',
  `goal` INT NOT NULL,
  UNIQUE INDEX `analytics_goals_period_unique` USING BTREE (`scope` ASC, `factor` ASC, `year` ASC, `quarter` ASC, `month` ASC))
  ENGINE = InnoDB
  COMMENT = 'Goals for organization or for languages (of members) per period';

-- how to use:
INSERT INTO analytics_goals_period (scope, factor, year, goal) VALUES
  ('organization', 'new_active_members', 2017, 250000),
  ('en_GB', 'new_active_members', 2017, 100000),
  ('de_DE', 'new_active_members', 2017, 80000),
  ('it_IT', 'new_active_members', 2017, 40000),
  ('fr_FR', 'new_active_members', 2017, 20000),
  ('es_ES', 'new_active_members', 2017, 10000);

INSERT INTO analytics_goals_period (scope, factor, year, quarter, goal) VALUES
  ('organization', 'new_active_members', 2017, 1, 40000),
  ('organization', 'new_active_members', 2017, 2, 60000),
  ('organization', 'new_active_members', 2017, 3, 110000),
  ('organization', 'new_active_members', 2017, 4, 40000);

-- goals per dates, more flexibles
DROP TABLE IF EXISTS analytics_goals_dates;
CREATE TABLE IF NOT EXISTS analytics_goals_dates (
  `id` INT(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `scope` VARCHAR(12) NOT NULL DEFAULT 'organization' COMMENT 'organization or one of language like en_GB, de_DE, pl_PL...',
  `factor` VARCHAR(45) NOT NULL COMMENT 'active_members, donations_count, donations_amount...',
  `begin` DATE NULL,
  `end` DATE NOT NULL COMMENT 'The goal should be filled out at this end date.',
  `goal` INT NOT NULL,
  UNIQUE INDEX `analytics_goals_dates_unique` USING BTREE (`scope` ASC, `factor` ASC, `begin` ASC, `end` ASC))
  ENGINE = InnoDB
  COMMENT = 'Goals for organization or for languages (of members) per dates';

-- how to use
INSERT INTO analytics_goals_dates (scope, factor, begin, end, goal) VALUES
  ('organization', 'new_active_members', '2017-01-01', '2017-12-31', 250000),
  ('en_GB', 'new_active_members', '2017-01-01', '2017-12-31', 100000),
  ('de_DE', 'new_active_members', '2017-01-01', '2017-12-31', 80000),
  ('it_IT', 'new_active_members', '2017-01-01', '2017-12-31', 40000),
  ('fr_FR', 'new_active_members', '2017-01-01', '2017-12-31', 20000),
  ('es_ES', 'new_active_members', '2017-01-01', '2017-12-31', 10000);

INSERT INTO analytics_goals_dates (scope, factor, begin, end, goal) VALUES
  ('organization', 'new_active_members', '2017-01-01', '2017-03-31', 40000),
  ('organization', 'new_active_members', '2017-04-01', '2017-06-30', 60000),
  ('organization', 'new_active_members', '2017-07-01', '2017-09-30', 110000),
  ('organization', 'new_active_members', '2017-10-01', '2017-12-31', 40000);
