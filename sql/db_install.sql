DROP TABLE IF EXISTS `analytics_active_1m`;
CREATE TABLE `analytics_active_1m` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kpidate` date DEFAULT NULL,
  `language` varchar(5) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  `stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `analytics_active_3m`;
CREATE TABLE `analytics_active_3m` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kpidate` date DEFAULT NULL,
  `language` varchar(5) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  `stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `analytics_calculation_times`;
CREATE TABLE `analytics_calculation_times` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `calculation` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `analytics_delta_t_h`;
CREATE TABLE `analytics_delta_t_h` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `period` varchar(255) DEFAULT NULL,
  `hours_from` float DEFAULT NULL,
  `hours_to` float DEFAULT NULL,
  PRIMARY KEY (`id`)
);
INSERT INTO analytics_delta_t_h VALUES
  (1, 'last six hours', 6, 0),
  (2, 'last 24 hours', 24, 0),
  (3, '24 h before that', 48, 24),
  (4, 'last week (168h)', 168, 0),
  (5, 'week before that', 336, 168),
  (6, 'last 30 days', 720, 0),
  (7, 'month before that', 1440, 720),
  (8, '2nd month before', 2160, 1440);

DROP TABLE IF EXISTS `analytics_kpidates`;
CREATE TABLE `analytics_kpidates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `analytics_mailing_activity`;
CREATE TABLE `analytics_mailing_activity` (
  `mailing_id` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  KEY `mailing_id` (`mailing_id`),
  CONSTRAINT `analytics_mailing_activity_ibfk_1` FOREIGN KEY (`mailing_id`) REFERENCES `civicrm_mailing` (`id`)
);

DROP TABLE IF EXISTS `analytics_mailing_counter`;
CREATE TABLE `analytics_mailing_counter` (
  `mailing_id` int(10) unsigned NOT NULL,
  `counter` varchar(32) NOT NULL,
  `timebox` int(10) unsigned NOT NULL,
  `value` int(10) unsigned NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`mailing_id`,`counter`,`timebox`),
  CONSTRAINT `analytics_mailing_counter_ibfk_1` FOREIGN KEY (`mailing_id`) REFERENCES `civicrm_mailing` (`id`)
);

DROP TABLE IF EXISTS `analytics_member_metrics`;
CREATE TABLE `analytics_member_metrics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `added_date` date DEFAULT NULL,
  `language` varchar(5) DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `number_added` int(11) DEFAULT NULL,
  `number_removed` int(11) DEFAULT NULL,
  `stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `analytics_member_metrics_dt`;
CREATE TABLE `analytics_member_metrics_dt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `delta_t_h_id` int(11) DEFAULT NULL,
  `language` varchar(5) DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `number_added` int(11) DEFAULT NULL,
  `number_removed` int(11) DEFAULT NULL,
  `stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `analytics_members_country_language`;
CREATE TABLE `analytics_members_country_language` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `language` varchar(5) DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `members` int(11) DEFAULT NULL,
  `stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `analytics_petitions_1week`;
CREATE TABLE `analytics_petitions_1week` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `speakout_id` int(11) DEFAULT NULL,
  `civicrm_camp_id` int(11) DEFAULT NULL,
  `speakout_name` varchar(255) DEFAULT NULL,
  `speakout_title` varchar(255) DEFAULT NULL,
  `language` varchar(5) DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `npeople` int(11) DEFAULT NULL,
  `activity_type_id` int(11) DEFAULT NULL,
  `status_id` int(11) DEFAULT NULL,
  `is_opt_out` tinyint(4) DEFAULT NULL,
  `stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `analytics_petitions_48h`;
CREATE TABLE `analytics_petitions_48h` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `speakout_id` int(11) DEFAULT NULL,
  `civicrm_camp_id` int(11) DEFAULT NULL,
  `speakout_name` varchar(255) DEFAULT NULL,
  `speakout_title` varchar(255) DEFAULT NULL,
  `language` varchar(5) DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `npeople` int(11) DEFAULT NULL,
  `activity_type_id` int(11) DEFAULT NULL,
  `status_id` int(11) DEFAULT NULL,
  `is_opt_out` tinyint(4) DEFAULT NULL,
  `stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `analytics_petitions_total`;
CREATE TABLE `analytics_petitions_total` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `speakout_id` int(11) DEFAULT NULL,
  `civicrm_camp_id` int(11) DEFAULT NULL,
  `speakout_name` varchar(255) DEFAULT NULL,
  `speakout_title` varchar(255) DEFAULT NULL,
  `language` varchar(5) DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `npeople` int(11) DEFAULT NULL,
  `activity_type_id` int(11) DEFAULT NULL,
  `status_id` int(11) DEFAULT NULL,
  `is_opt_out` tinyint(4) DEFAULT NULL,
  `stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `analytics_timeboxes`;
CREATE TABLE `analytics_timeboxes` (
  `box` int(10) unsigned NOT NULL,
  PRIMARY KEY (`box`)
);
INSERT INTO `analytics_timeboxes` VALUES (300), (720), (1440), (2880), (144000);

DROP TABLE IF EXISTS `data_mailing_counter`;
CREATE TABLE `data_mailing_counter` (
  `mailing_id` int(10) unsigned NOT NULL DEFAULT '0',
  `counter` varchar(32) NOT NULL DEFAULT '',
  `timebox` int(10) unsigned NOT NULL DEFAULT '0',
  `value` int(10) unsigned DEFAULT NULL,
  `last_updated` datetime NOT NULL,
  PRIMARY KEY (`mailing_id`,`counter`,`timebox`),
  CONSTRAINT `data_mailing_counter_ibfk_1` FOREIGN KEY (`mailing_id`) REFERENCES `civicrm_mailing` (`id`)
);

DROP TABLE IF EXISTS `data_timeboxes`;
CREATE TABLE `data_timeboxes` (
  `box` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`box`)
);
INSERT INTO `data_timeboxes` VALUES (120), (300), (720), (1440), (2880), (144000);
