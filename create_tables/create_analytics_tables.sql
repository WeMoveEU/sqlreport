
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