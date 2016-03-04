/* 
This creates all the tables needed for WeMove sql report suite.





*/


drop table if exists analytics_member_metrics;

create table analytics_member_metrics
(
id int not null auto_increment,
added_date date,
language varchar(5),
number_added int, /* +100 = 100  subscribed , -1 =  1 opted out*/
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
country varchar(255),
npeople int,
activity varchar(255), /* petition signature, share etc. */
status varchar(255), /* completed, scheduled etc. */
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
country varchar(255),
npeople int,
activity varchar(255), /* petition signature, share etc. */
status varchar(255), /* completed, scheduled etc. */
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
country varchar(255),
npeople int,
activity varchar(255), /* petition signature, share etc. */
status varchar(255), /* completed, scheduled etc. */
is_opt_out tinyint(4), 
stamp timestamp,
primary key(id)
);

