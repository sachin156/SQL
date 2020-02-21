----Udemy Course...

---union
--which fetches all the unique rows from the two queries in union 
select fruit from basket_a union select fruit from basket_b;

/*
   fruit    
------------
 Cucumber
 Watermelon
 Apple
 Pear
 Banana
 Orange
*/

---union all,
---fetches all the rows which includes duplicates from the two tables matched..
select fruit from basket_a union all select fruit from basket_b;
/*
   fruit    
------------
 Apple
 Orange
 Banana
 Cucumber
 Orange
 Apple
 Watermelon
 Pear
*/
---intersect
--matches the two tables which only displays the matched row value with the other query
select fruit from basket_a intersect select fruit from basket_b;
 fruit  
--------
 Apple
 Orange
(2 rows)
---except
--fetches all the rows except the ones matched or present on the other side..
/*
select fruit from basket_a except select fruit from basket_b;
  fruit   
----------
 Cucumber
 Banana
(2 rows)
*/

---and
--selects all the rows which matches both the conditions(both conditions have to be true)
select * from emp where emp.sal>=8000 and emp.sal<20000;

/*
 empno | empname | hourpay |   sal    | commission | numsales | dno | dep_id 
-------+---------+---------+----------+------------+----------+-----+--------
   766 | smit    |         |  8000.00 |            |    20.00 |   2 |     40
   101 | Neena   |         | 10000.00 |            |          |   2 |    110
   102 | lex     |   30.00 | 12000.00 |            |          |   1 |    100
   732 | kane    |   20.00 | 10000.00 |    2000.00 |    12.00 |   1 |     40
*/

---or
--selects all the rows which matches the either of the conditions when or is used it checks if any one of the condition is met.
select * from emp where emp.sal>=8000 or  emp.commission<=3000;
/*
 empno | empname | hourpay |   sal    | commission | numsales | dno | dep_id 
-------+---------+---------+----------+------------+----------+-----+--------
   766 | smit    |         |  8000.00 |            |    20.00 |   2 |     40
   784 | alen    |         |  1600.00 |    3000.00 |     4.00 |   3 |     40
   100 | Steve   |   30.00 | 24000.00 |            |          |   1 |     90
   101 | Neena   |         | 10000.00 |            |          |   2 |    110
   102 | lex     |   30.00 | 12000.00 |            |          |   1 |    100
   104 | bruce   |         | 28000.00 |            |          |   2 |    120
*/
---using and with or
 select * from emp where (emp.sal>=8000 and emp.sal<20000) or (emp.sal>1000 and emp.sal<2500);
/*
 empno | empname | hourpay |   sal    | commission | numsales | dno | dep_id 
-------+---------+---------+----------+------------+----------+-----+--------
   766 | smit    |         |  8000.00 |            |    20.00 |   2 |     40
   784 | alen    |         |  1600.00 |    3000.00 |     4.00 |   3 |     40
   791 | ward    |   40.00 |  1250.00 |    5000.00 |    10.00 |   3 |     40
   101 | Neena   |         | 10000.00 |            |          |   2 |    110
   102 | lex     |   30.00 | 12000.00 |            |          |   1 |    100
   732 | kane    |   20.00 | 10000.00 |    2000.00 |    12.00 |   1 |     40
*/

---like operator
--starting with s (empname words)
select * from emp where empname like '%s%';

/*
 empno | empname | hourpay |   sal   | commission | numsales | dno | dep_id 
-------+---------+---------+---------+------------+----------+-----+--------
   766 | smit    |         | 8000.00 |            |    20.00 |   2 |     4
*/

---word with second letter as a
select * from emp where empname like '_a%';
/*
 empno | empname | hourpay |   sal    | commission | numsales | dno | dep_id 
-------+---------+---------+----------+------------+----------+-----+--------
   791 | ward    |   40.00 |  1250.00 |    5000.00 |    10.00 |   3 |     40
   203 | mark    |   23.00 | 31000.00 |    4000.00 |    21.00 |   3 |     90
   732 | kane    |   20.00 | 10000.00 |    2000.00 |    12.00 |   1 |     40
*/
---words ending with a..
select * from emp where empname like '%a';

/*
 empno | empname | hourpay |   sal    | commission | numsales | dno | dep_id 
-------+---------+---------+----------+------------+----------+-----+--------
   101 | Neena   |         | 10000.00 |            |          |   2 |    110
*/


-----------------
---joins
---inner join , left join, cross join, natural join 

---cross join
--- matches all the rows in one table with all rows in the second table (no common column is required to join two tables).
---two different tables can also be joined without any common column between the two.
select  * from a cross join b;
----Natural join
--This join does not required you to specify the join because it uses implicit join clause based on the common column
select * from basket_a natural join basket_b;
/*
 fruit  | id 
--------+----
 Apple  |  1
 Orange |  2
*/


-----------------
---Aggregate functions
---Avg,count,max,min,sum
----------------------




------------------
---Triggers using pg admin
--by specifying the code in trigger function
/*
begin 
if new.last_name<>old.last_name then 
insert into employee_audit(employee_id,last_name,changed_on)
values(old.id,old.last_name,now());
end if;
return new;
end;
*/

alter trigger last_name_changes on employees rename to log_last_name_changes

alter table employees disable trigger log_last_name_changes;

drop trigger log_last_name_changes on employees;

------------------
--Views,Materialized Views
--

-----------------
--window function
--first_value ,last_value

