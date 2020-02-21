-----Refrence from https://w3resource.com/PostgreSQL/postgresql-subqueries.php
----Aggregate fuctions,group by, having Subqueries...
---Aggregate functions perfroms calculations on set of rows and returns a single row..
--- Group by divides the result set into group of rows and can be used to perform operations
----Subqueries (in,all,any,exsists,

/* avg() ---  avg of the entire column.
   count() --- Number of rows in the table
   max() --- max value in the column ,
   min() --- min value in the column ,
   sum() */

select avg(dno) from emp; 
select min(dno) from emp;
select max(dno) from emp;
select sum(dno) from emp;
select count(*) from emp; --number of rows

----using where clause with agg function by a sub query...
select empno,empname from emp where dno=(select max(dno) from emp) order by empname;


----Using groupby and aggreggate functions..
/* id |  name   | age | animal 
----+---------+-----+--------
  1 | bonkers |   1 | Rabbit
  2 | Moon    |   9 | Dog
  3 | Ripley  |   7 | Cat
  4 | Tom     |   1 | Cat
  5 | Maisie  |   9 | Dog
  6 | sara    |   7 | Dog
  7 | miley   |   1 | 
  8 | perthy  |   3 | dog
  9 | sno     |   2 | 
 10 |         |   1 | Cat
 11 |         |   1 | 
(11 rows)

*/

select animal,max(age) from pets group by animal;
select name,animal,count(*) from pets group by animal,name;
  --picks max value of age for each animal category..
----Using groupby and having in the query
select animal, max(age) from pets group by animal having max(age) < 8;

---where and having ,where selects the rows before aggregates are computed thus it controls which rows go into the aggregate computation.
 ---having select the rows after aggregated are computed,, which always contains the aggregate functions always used with group by clause..

--Subqueries on emp and department table...	
select empno,empname from emp where dep_id=ANY 
 (select dep_id from department where loc_id=1700);
---any is used because each emp consists only id for department , in key word works the same in place of any.
--- not in is to get values other than those matching with the values.
select empno,empname from emp where dep_id=All
 (select dep_id from department where loc_id=1700);
---all is used to match the everything in the sub query, dep_id should match everything in the sub query..
select dep_id,avg(sal) from emp group by dep_id having avg(sal)>=all
(select avg(sal) from emp group by dep_id);
---the left side matches with every value in the paranthesized values to the right side...

/* Result of right side sub query 
         avg           
------------------------
     28000.000000000000
 10000.0000000000000000
  3616.6666666666666667
     24000.000000000000
 12000.0000000000000000
*/

select empno,empname,dno,dep_id from emp e where exists (select * from employees where man_id=e.empno);

--- Row constructor 



