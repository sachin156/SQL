---Reference 
 ---https://severalnines.com/blog/postgresql-database-indexing-overview
 ---https://www.citusdata.com/blog/2017/10/17/tour-of-postgres-index-types/
---Index types..
--- different index types B-tree,GiST,SP-GIST,GIN and BRIN
---which index type to use depends on data type
/* 
B Trees can handle equality and range queries on data.using postgres whenever an index column is invovled in a comparison (<,>,<=,>=,=), creates a tree which is balanced and even.Valid on most of data types (text,numbers).
if the column is unique then by default b-tree will be assgined to column 
           
		Table "public.department"
  Column  |          Type          | Modifiers 
----------+------------------------+-----------
 dep_id   | integer                | 
 dep_name | character varying(255) | 
 mang_id  | integer                | 
 loc_id   | integer                | 
Indexes:
    "depid_unique" UNIQUE CONSTRAINT, btree (dep_id)

As B-Tree index entries are sorted they are used to retrieve table rows in order

Using B-Tree.....

Using select on columns with and without indexs
*/

select * from deaprtment where dep_id='Pno:100000';
 
/*  dep_id   |   dep_name   |  mang_id   | partdescr  
--------+------------+-------------+-----------
 100000 | deno:100000 | dart:100000 |      0
(1 row)
Time: .389 ms
*/

select * from deaprtment where dep_name='deno:100000';
/*  dep_id   |   dep_name   |  mang_id   | partdescr  
--------+------------+-------------+-----------
 100000 | deno:100000 | dart:100000 |      0
(1 row)
Time: 89.389 ms
*/

create index depname on department(dep_name);
CREATE INDEX
select * from deaprtment where dep_name='deno:100000';
/*After applying default inedx on dep name the time reduced significantly.
  dep_id   |   dep_name   |  mang_id   | partdescr  
--------+------------+-------------+-----------
 100000 | deno:100000 | dart:100000 |      0
(1 row)
Time: 1.119 ms
*/

/* B-tree index also helps with queries involving operators (<,>,<=,>=,=).*/


-------------------------------------------------------


----GIN indexes (generalized inverted indexes)
 ---Useful when you have data types that contain multiple values in s single column
 ---items could be documents and the queries could be search for documents containing specific words.(searching words in the documents ,text search)..
 ---

update part set partdescr ='the cooling systen' where id=500000;

/*UPDATE 1
Time: 834.049 ms
test=# select * from part where partdescr @@ 'cooling';
   id   |   partno   |  partname   |             partdescr             | machine_id 
--------+------------+-------------+-----------------------------------+------------
 500000 | Pno:500000 | Part:500000 | thermostat for the cooling systen |          0
(1 row)

Time: 1841.417 ms*/

create index partdesc on part using gin(to_tsvector('english',partdescr));
/*CREATE INDEX
Time: 600.957 ms
*/
select * from part where partdescr @@ 'cooling';
/*
   id   |   partno   |  partname   |             partdescr             | machine_id 
--------+------------+-------------+-----------------------------------+------------
 500000 | Pno:500000 | Part:500000 | thermostat for the cooling systen |          0
(1 row)

Time: 1643.412 ms
*/
select * from part where to_tsvector('english',partdescr) @@ to_tsquery('thermostat');
/*After using gin index to search text on partdescr..

   id   |   partno   |  partname   |             partdescr             | machine_id 
--------+------------+-------------+-----------------	------------------+------------
 500000 | Pno:500000 | Part:500000 | thermostat for the cooling systen |          0
(1 row)

Time: 8.150 ms
*/

---------------------------------------------------------

---GiST Indexes (generalized search tree) 
 ---When you have data that can in some way overlap with the value from same coloumn and another row.
 ---used when it is geometric and full text search 

create table machine_type (
    id SERIAL PRIMARY KEY, 
    mtname varchar(50) not null, 
    mtvar varchar(20) not null, 
    start_date date not null, 
    end_date date, 
    CONSTRAINT machine_type_uk UNIQUE (mtname,mtvar)
);

/* mtname and mtvar are more of key value pair which is unique..*/

alter table machine_type ADD CONSTRAINT machine_type_per EXCLUDE USING GIST (mtname WITH =,daterange(start_date,end_date) WITH &&);
---to make non overlapping rows with a constraint..
---mtname,mtvar and start_date and end_date are unique when combined (no other version in same start and end date time) 

insert into machine_type values(1,'subaru','sh','2008-01-10','2013-01-01');

insert into machine_type values(2,'subaru','sh','2008-01-10','2013-01-01');
/*ERROR:  duplicate key value violates unique constraint "machine_type_uk"
DETAIL:  Key (mtname, mtvar)=(subaru, sh) already exists.
*/
insert into machine_type values(2,'subaru','st','2008-01-10','2013-01-01');
/*ERROR:  conflicting key value violates exclusion constraint "machine_type_per"
DETAIL:  Key (mtname, daterange(start_date, end_date))=(subaru, [2008-01-10,2013-01-01)) conflicts with existing key (mtname, daterange(start_date, end_date))=(subaru, [2008-01-10,2013-01-01)).
*/
insert into machine_type values(2,'subaru','st','2014-01-10','2015-01-01');
--insert 0 1

---------------------------------------------------
----SP-Gist(Space Partitioned GiST)
 ---Im memory use,development for many non balanced disk based structures.
 ---sp-Gist can be used in exclusion constraints

------------------------------------------------------
----BRIN indexes (blocked range index)
 ---group of pages adjacent to each other where summary of all the pages are stored in index.
 ---mostly to reduce the storage size of the index

CREATE TABLE testtab (id int NOT NULL PRIMARY KEY,date TIMESTAMP NOT NULL, level INTEGER, msg TEXT);

/* by default the index is b tree for id or date so by using b-tree occupies 17mb is required  for 800k rows indexing but brin
 ---uses only 48kb as index size (which decreases the ratio of index to table size) which might effect efficiency
*/
create index testtab_date on testtab(data);
di+ testtab_date;
/*                         
 List of relations
 Schema |     Name     | Type  | Owner |  Table  | Size  | Description 
--------+--------------+-------+-------+---------+-------+-------------
 public | testtab_date | index | test  | testtab | 17 MB | 
*/
create index testtabdata_brin on testtab using brin(date);

\di+ testtabdata_brin;
/*
                             List of relations
 Schema |       Name       | Type  | Owner |  Table  | Size  | Description 
--------+------------------+-------+-------+---------+-------+-------------
 public | testtabdata_britn | index | test  | testtab | 48 kB | 

Not efficient as fully cached b Tree index, there will be performance improvement with fewer resources..
*/

---Comparing btree and brin on select query the execution time is less for b tree.... on the above table.




