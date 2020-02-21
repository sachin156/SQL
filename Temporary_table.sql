----temporary table
 ---creates temporary table that is dropped at the end of a session or current transaction
create temp table mytemp(temp1 int,temp2 text);
 ---can share same name as permanent table (cannot acces until the per table until temp table is droped)
 ---indexing is also possible on the temp tables
 ---created under the temp schema pg_temp_nn
select * from companyde;
/* temp table 
 temp1 | tempw 
-------+-------
*/
drop table companyde; --drop temp table 
select * from companyde;
/*
 title | gender | customername |     company     
-------+--------+--------------+-----------------
 Mr    | Male   | Thomas Hardy | Around the Horn
 Miss  | Female | Neha         | sp
 Mrs   | Female | hanna        | qualc
 Ms    | Male   | christina    | Bon App
*/
/*
call the permanent table is taken into account when called with schema.
*/

select * from public.companyde


--------------------------------------

----Views 
 ---another way to present data in the database tables.
 ---based on one or more tables known as base tables 
 ---create query and assign it a name (wrapping a commonly used complex query)
 ---views are definitions built on top of other tables
 ---if any table changes then it will be reflected in the view 
 ---Views are read only ,wont allow insert,delete or update on a view.
/*  create view*/

create view part_view as select * from part where partname='Part:400000';

select * from part_view;
/*
   id   |   partno   |  partname  sele | partdescr | machine_id 
--------+------------+-------------+-----------+------------
 400000 | Pno:400000 | Part:400000 |           |          0
*/

 ---the definition of view can be changed without having to drop it
create or replace view part_view as select * from part where id between 10 and 30;
 ---any change in the tables will effect the view also.
 ---alter view statement changes the definition of an existing view..

----Materialized Views 
 ---to store the result of the complex queries,results are in table form
 ---materialized views are directly not updated because it is a storage,view is not materialized becuase the query is run every time the view is referenced in a query.
 ---simple view are bit inefficient when it comes to time.

create materialized view mymatview as select * from part where id between 10 and 20;
select * from mymatview 
 
 ---to load into materialized view (cannot query data against it)
Refresh materialized view mymatview;
 ---to avoid locking on the table 
Refresh materialized view concurrently mymatview;


















