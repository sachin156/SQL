----Reference:https://www.citusdata.com/blog/2018/05/15/fun-with-sql-recursive-ctes/
----Common Table Expressions( CTEs)
 ---very useful for allowing your large sql queries to be readable
 ---Are similar to view that is materialized while that query is running and wont work outside of the query.
 ---allows to create some very complex queries by using recursive queries 
 ---simplify complex joins and subqueries 
 
 ---example of cte on emp table
with emp_grade as (
select empno,empname,(case when sal<5000 then 'a1'
when sal>=5000 and sal<10000 then 'a2' when sal>=10000 then 'a3' end) sal_grade from emp) 
select empno,empname,sal_grade from emp_grade where sal_grade='a3' order by empname;
/*
 empno | empname | sal_grade 
-------+---------+-----------`
   104 | bruce   | a3
   102 | lex     | a3
   101 | Neena   | a3
   100 | Steve   | a3
*/

 ---cte can be used to join with the other tables in db.
 with emp_join as (
select id from rental group by staff_id 
)
select s.id,name,empno from staff s inner join emp_join using(id);
 
 

----Recursive ctes 
 ---makes possible to express recurssion in sql.
 ---works with the concept of working table(which is temporary table to store results)
/* general query template for recursive ctes

with recursive name (columns) as(
 <initial query>
union all
<recursive query>
)
<query>
*/
 ---generate series from 10 to 100
with recursive tens(n) as(
 select 10
union all
select n+10 from tens where n+10<100
)
select * from tens;
 ---after select 10 the recursive query is ran on the working table 
 ---the recursive query returns a single row with 20 and it becomes new working table and it repeats until it becomes the only row with value 100.
 select * from employees;
/*
 id |  name   | manager_id 
----+---------+------------
  1 | Umur    |           
  2 | Craig   |          1
  3 | Daniel  |          2
  4 | Claire  |          1
  5 | Lindsay |          2
  6 | Will    |          2
  7 | Burak   |          2
  8 | Eren    |          2
  9 | Katie   |          3
 10 | Teresa  |          4
(10 rows)
*/ 
 ---we want who are all reporting to craig and we can see that katie is reporting to someone who reports to craig.(recursion is required)
  
with recursive temp as (
test(# select id,name,manager_id from employees where id =2 union all select e.id,e.name,e.manager_id from employees e inner join on temp.id=e.id)select * from managertemp;

/*
all the people reporting to id 2
id |  name   | manager_id
----+---------+------------
  2 | Craig   |          1
  3 | Daniel  |          2
  5 | Lindsay |          2
  6 | Will    |          2
  7 | Burak   |          2
  8 | Eren    |          2
  9 | Katie   |          3
*/

-----list total slots booked per facility..
select facid,extract(month from starttime) as month,count(slots) as totalslots from booking where starttime>='2012-01-01' and starttime<='2012-12-21' group by rollup(facid,month) order by facid;

/*
 facid | month | totalslots 
-------+-------+------------
     0 |     1 |          1
     0 |     2 |          4
     0 |     3 |          1
     0 |       |          6
     1 |     2 |          1
     1 |     3 |          1
     1 |       |          2
       |       |          8
*/


with slots_cte as (select facid,extract(month from starttime) as month,sum(slots) as slots from booking where starttime>='2012-01-01' and starttime<='2012-12-21' group by facid,month)
select facid,month,slots from slots_cte 
union 
select facid,null,sum(slots) from booking where starttime>='2012-01-01' and starttime<='2012-12-21' group by facid order by facid,month;

/*
 facid | month | slots 
-------+-------+-------
     0 |     1 |     2
     0 |     2 |     8
     0 |     3 |     2
     0 |       |    12
     1 |     2 |     2
     1 |     3 |     2
     1 |       |     4
     2 |     2 |     2
     2 |     3 |     2
     2 |       |     4

*/


select fks.faceid,fks.name,round(sum(bks.slots)/2.0,2) as "Total hours" from booking bks inner join facilites fks on fks.faceid=bks.facid group by fks.faceid,fks.name order by fks.faceid;

/*
 faceid |      name       | Total hours 
--------+-----------------+-------------
      0 | Tennis Court1   |        6.00
      1 | Tennis Court2   |        3.00
      2 | Badminton Court |        2.00
      3 | Table Tennis    |        1.00
      6 | Squash Court    |        1.00
      7 | Snooker Table   |        2.50
*/


