/* 
This creates all the tables needed for WeMove sqlreport suite.

*/


drop table if exists analytics_calculation_times;

create table analytics_calculation_times
(
id int not null auto_increment,
stamp timestamp,
primary key(id) ,
calculation varchar(255) 
);


drop table if exists analytics_kpidates;

create table analytics_kpidates
(
id int not null auto_increment,
date datetime,
primary key(id) 
);


drop table if exists analytics_delta_t_h;

create table analytics_delta_t_h 
 (
id int not null auto_increment,
period varchar(255),
hours_from float,
hours_to float,
primary key(id) 
);

insert into analytics_delta_t_h
(period, hours_from, hours_to) 
values 
("last six hours",6,0), 
("last 24 hours", 24,0), 
("24 h before that", 48,24),
("last week (168h)", 7*24,0), 
("week before that", 2*7*24,7*24),
("last 30 days", 30*24,0),
("month before that", 2*30*24,30*24),
("2nd month before", 3*30*24,2*30*24)
;


drop table if exists analytics_members_country_language;

create table analytics_members_country_language
(
id int not null auto_increment,
language varchar(5),
country_id int,
members int, 
stamp timestamp,
primary key(id)
);

drop table if exists analytics_member_metrics;

create table analytics_member_metrics
(
id int not null auto_increment,
added_date date,
language varchar(5),
country_id int,
number_added int, 
number_removed int,
stamp timestamp,
primary key(id)
);

drop table if exists analytics_member_metrics_dt;

create table analytics_member_metrics_dt
(
id int not null auto_increment,
delta_t_h_id int,
language varchar(5),
country_id int,
number_added int, 
number_removed int,
stamp timestamp,
primary key(id)
);


drop table if exists analytics_petitions_total;

drop table if exists analytics_petitions_1week;

drop table if exists analytics_petitions_48h;


create table analytics_petitions_total
(
id int not null auto_increment,
speakout_id int,
civicrm_camp_id int,
speakout_name varchar(255),
speakout_title varchar (255),
language varchar(5),
country_id int, 
npeople int,
activity_type_id int, /* petition signature, share etc. */
status_id int, /* completed, scheduled etc. */
is_opt_out tinyint(4), 
stamp timestamp,
primary key(id)
);




create table analytics_petitions_1week
(
id int not null auto_increment,
speakout_id int,
civicrm_camp_id int,
speakout_name varchar(255),
speakout_title varchar (255),
language varchar(5),
country_id int, 
npeople int,
activity_type_id int, /* petition signature, share etc. */
status_id int, /* completed, scheduled etc. */
is_opt_out tinyint(4), 
stamp timestamp,
primary key(id)
);


create table analytics_petitions_48h
(
id int not null auto_increment,
speakout_id int,
civicrm_camp_id int,
speakout_name varchar(255),
speakout_title varchar (255),
language varchar(5),
country_id int, 
npeople int,
activity_type_id int, /* petition signature, share etc. */
status_id int, /* completed, scheduled etc. */
is_opt_out tinyint(4), 
stamp timestamp,
primary key(id)
);

