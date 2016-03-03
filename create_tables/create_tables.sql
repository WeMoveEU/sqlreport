/* 
This creates all the tables needed for WeMove sql report suite.





*/



create table analytics_member_metrics
(
id int not null auto_increment,
added_date date,
language varchar(5),
number_added int, /* +100 = 100  subscribed , -1 =  1 opted out*/
number_removed int,
primary key(id)
);

