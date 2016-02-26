# SQL report for civicrm

This extension rely on civisualize to provide an easier framework to make csv exports of sql queries

## how to create your own report?

Let's say you want to have an export of all the contacts created by day in the last 100 days

1. create a query/Contactbydate.sql file that contains your query
select DATE(created_date) as date, count(*) as total from civicrm_contact group by date order by date desc limit 100;

_ it's actually the last 100 days when a contact was created. Don't go all sql on me, it's just an example_

2. go to /civicrm/dataviz/csv/contactbydate

See the result, click on the download icon, and voila. you like sql, sql likes you.

## how to make more complicated aggregates that needs intermediate tables?
For security reasons, the query is limited to a single SELECT query. If you need more complex queries, eg if you want to insert aggregates into a table and run the update once per hour insead of everytime someone access the report (because it takes time)

1. create a new file
sql/xxx.sql

** TODO I need an example and clarify once the code is actually written **
xxx.sql can contain any sql command, including INSERT or UPDATE

It's a permanent table, so you can, for instance, run a new aggregate (like the number of active contacts and insert the ones for the day 
...

## extra parameter for simple filtering
eg only contacts belonging to a group id 42, with the group being a parameter
civicrm/dataviz/csv/contactbydate/42

** TODO **


