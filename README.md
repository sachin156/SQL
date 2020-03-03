# SQL
constraint types

operators
joins
aggregations ,having,group by 
Sub queries
case ,coalesce
distinct ,distinct on 
copy to load datasets
temporary tables
views,materialized views
CTE's
window functions 
full text search
transaction isolation levels
Manual locking
indexes -partial/functional, explain, analyze
Triggers

## Logical operators

Types of operators:  
+ Union
+ Union All
+ Intersect
+ And 
+ Or

**UNION**       
Union operator fetches all the unique rows from the two select queries.Combines the results of two or more statments result.
```sql
select fruit from basket_a union select fruit from basket_b;
   fruit    
------------
 Cucumber
 Watermelon
 Apple
 Pear
 Banana
 Orange
```
**UNION ALL**       
fetches all the rows which includes duplicates. In Union operator it wont consider the duplicate values (only unique values) but union all fetches all the values including duplicates.

```sql
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
```
**INTERSECT**       
Matches the two tables which only displays the matched row value with the other query.
```sql
select fruit from basket_a intersect select fruit from basket_b;
 fruit  
--------
 Apple
 Orange
(2 rows)
```

**EXCEPT**      
fetches all the rows except the ones matched or present on the other side.
```sql
select fruit from basket_a except select fruit from basket_b;
  fruit   
----------
 Cucumber
 Banana
(2 rows)
```

**AND**     
Select all the rows which matches both the conditions(both conditions have to be true)
```sql
select * from emp where emp.sal>=8000 and emp.sal<20000;

 empno | empname | hourpay |   sal    | commission | numsales | dno | dep_id 
-------+---------+---------+----------+------------+----------+-----+--------
   766 | smit    |         |  8000.00 |            |    20.00 |   2 |     40
   101 | Neena   |         | 10000.00 |            |          |   2 |    110
   102 | lex     |   30.00 | 12000.00 |            |          |   1 |    100
   732 | kane    |   20.00 | 10000.00 |    2000.00 |    12.00 |   1 |     40

```

**OR**          
Selects all the rows which matches the either of the conditions when or is used it checks if any one of the condition is met.
```sql
select * from emp where emp.sal>=8000 or  emp.commission<=3000;

 empno | empname | hourpay |   sal    | commission | numsales | dno | dep_id 
-------+---------+---------+----------+------------+----------+-----+--------
   766 | smit    |         |  8000.00 |            |    20.00 |   2 |     40
   784 | alen    |         |  1600.00 |    3000.00 |     4.00 |   3 |     40
   100 | Steve   |   30.00 | 24000.00 |            |          |   1 |     90
   101 | Neena   |         | 10000.00 |            |          |   2 |    110
   102 | lex     |   30.00 | 12000.00 |            |          |   1 |    100
   104 | bruce   |         | 28000.00 |            |          |   2 |    120

```
**And with OR**         
Using And, Or operator 
```sql
select * from emp where (emp.sal>=8000 and emp.sal<20000) or (emp.sal>1000 and emp.sal<2500);

 empno | empname | hourpay |   sal    | commission | numsales | dno | dep_id 
-------+---------+---------+----------+------------+----------+-----+--------
   766 | smit    |         |  8000.00 |            |    20.00 |   2 |     40
   784 | alen    |         |  1600.00 |    3000.00 |     4.00 |   3 |     40
   791 | ward    |   40.00 |  1250.00 |    5000.00 |    10.00 |   3 |     40
   101 | Neena   |         | 10000.00 |            |          |   2 |    110
   102 | lex     |   30.00 | 12000.00 |            |          |   1 |    100
   732 | kane    |   20.00 | 10000.00 |    2000.00 |    12.00 |   1 |     40

```
**LIKE**        
like operator is allowed to match with string of any length or charcters.
Sql query to find empnames starting with s (empname words)
```sql 

select * from emp where empname like '%s%';

 empno | empname | hourpay |   sal   | commission | numsales | dno | dep_id 
-------+---------+---------+---------+------------+----------+-----+--------
   766 | smit    |         | 8000.00 |            |    20.00 |   2 |     4

---word with second letter as a
select * from emp where empname like '_a%';

 empno | empname | hourpay |   sal    | commission | numsales | dno | dep_id 
-------+---------+---------+----------+------------+----------+-----+--------
   791 | ward    |   40.00 |  1250.00 |    5000.00 |    10.00 |   3 |     40
   203 | mark    |   23.00 | 31000.00 |    4000.00 |    21.00 |   3 |     90
   732 | kane    |   20.00 | 10000.00 |    2000.00 |    12.00 |   1 |     40

---words ending with a..
select * from emp where empname like '%a';

 empno | empname | hourpay |   sal    | commission | numsales | dno | dep_id 
-------+---------+---------+----------+------------+----------+-----+--------
   101 | Neena   |         | 10000.00 |            |          |   2 |    110
```

## Subqueries

A subquery is a query within a query.The main query that contains the subquery is  called the OUTER QUERY.A subquery is also called an INNER QUERY.The inner query executes first before its parent query so that the results of an inner query can be passed to the outer query.

 + A subquery must be enclosed in parentheses. 
 + A subquery must be placed on the right side of the       comparison operator. 
+ Subqueries cannot manipulate their results internally, therefore ORDER BY clause cannot be added into a subquery.
+ Use single-row operators(<,>,=,!=,>=,<=) with single-row subqueries. 
+ If a subquery returns a null value to the outer query, the outer query will not return any rows when using certain comparison operators in a WHERE clause.
+ Subqueries can also be nested

A subquery may occur in :
  + A SELECT clause
  + A FROM clause
   + A WHERE clause


###	Types of Subquery:

**Single row subquery** :    
Returns zero or one row.(Single row comparison operators are used in where clause i.e =,>,<,>=,<=,!=)

Display the employees whose salary is higher than the average salary throughout the company.
```sql
select * from cmr_employee where sal>=(select coalesce(avg(sal),0) from cmr_employee);
	 eid  | ename |    sal    | dept | mgr_id 
	------+-------+-----------+------+--------
	 1002 | tom   |  65000.00 | pr   |       
	 1005 | peter |  85000.00 | pr   |   1002
	 1008 | ravi  | 125000.00 | hr   |   1004
	(3 rows)
```
**Multiple row subquery** :       
Returns one or more rows.(multiple row comparison operators like IN, ANY, ALL are used)

When all is used it should match with everything in inner query.Any is used when atleast one of them should be matched.

Display the employee who are managers
```sql	
select ename from cmr_employee where eid in(select distinct mgr_id from cmr_employee );
	   ename    
	------------
	 ram
	 tom
	 sai kumar
	 rana singh
	(4 rows)

Display the employee details who earns max sal in each dept
	
select * from cmr_employee where sal in(select max(sal) from cmr_employee group by dept);

	 eid  | ename |    sal    | dept | mgr_id 
	------+-------+-----------+------+--------
	 1005 | peter |  85000.00 | pr   |   1002
	 1008 | ravi  | 125000.00 | hr   |   1004
	(2 rows)

select empno,empname from emp where dep_id=ANY (select dep_id from department where loc_id=1700)

select dep_id,avg(sal) from emp group by dep_id having avg(sal)>=all(select avg(sal) from emp group by dep_id);

```         
**Multiple column subqueries** :          
Returns one or more columns. 

Display the employee details who earns min sal in each dept. 
```sql	
select * from cmr_employee where (dept,sal) in (select dept,min(sal) from cmr_employee group by dept);
	 eid  |   ename   |   sal    | dept | mgr_id 
	------+-----------+----------+------+--------
	 1003 | sai kumar | 35000.00 | hr   |   1001
	 1006 | balu      | 43000.00 | pr   |   1002
	 1007 | anand     | 35000.00 | hr   |   1003
	(3 rows)

```       
**Correlated subqueries** :          
Reference one or more columns in the outer SQL statement.The subquery is known as a correlated subquery because the subquery is related to the outer SQL statement.

Display the employees whose salary is  more than the average salary in each department.

```sql
select * from cmr_employee c where sal>=(select coalesce(avg(sal),0) from cmr_employee e where e.dept=c.dept);
	
    eid  | ename |    sal    | dept | mgr_id 
	------+-------+-----------+------+--------
	 1002 | tom   |  65000.00 | pr   |       
	 1005 | peter |  85000.00 | pr   |   1002
	 1008 | ravi  | 125000.00 | hr   |   1004
	(3 rows)

Display employees with their manager names

select e.ename "employee",(select m.ename from cmr_employee m  where e. mgr_id=m.eid) as manager from cmr_employee e;

	  employee  |  manager   
	------------+------------
	 ram        | 
	 tom        | 
	 sai kumar  | ram
	 rana singh | ram
	 peter      | tom
	 balu       | tom
	 anand      | sai kumar
	 ravi       | rana singh
	(8 rows)
   ```

The subquery can be nested inside a SELECT, INSERT, UPDATE, or DELETE statement or inside another subquery

```sql
insert into employee_temp select *  from employee where emp_id in(select emp_id from employee );
	INSERT 0 11

update employee_temp set emp_sal=emp_sal*1.10 where emp_id in (select emp_id from employee_temp where emp_dept='pr');
	UPDATE 4
	
   select * from cmr_employee ;
	
    eid  |   ename    |    sal    | dept | mgr_id 
	------+------------+-----------+------+--------
	 1001 | ram        |  55000.00 | hr   |       
	 1002 | tom        |  65000.00 | pr   |       
	 1003 | sai kumar  |  35000.00 | hr   |   1001
	 1004 | rana singh |  45000.00 | hr   |   1001
	 1005 | peter      |  85000.00 | pr   |   1002
	 1006 | balu       |  43000.00 | pr   |   1002
	 1007 | anand      |  35000.00 | hr   |   1003
	 1008 | ravi       | 125000.00 | hr   |   1004
	(8 rows)
```

### Distinct and Distinct On:

Distinct is applicable to an entire tuple, after the result the distinct removes all the duplicates rows.Must follow select command.

```sql
select * from colors;
 id | bcolor | fcolor 
----+--------+--------
  1 | red    | red
  2 | red    | red
  3 | red    | 
  4 |        | red
  5 | red    | green
  6 | red    | blue
  7 | green  | red
  8 | green  | blue
  9 | green  | green
 10 | blue   | red
 11 | blue   | green
 12 | blue   | blue
 13 | blue   | blue
(13 rows)

select distinct bcolor from colors;

 bcolor 
--------
 
 blue
 green
 red
 ```
 If you specify multiple columns, the DISTINCT clause will evaluate the duplicate based on the combination of values of these columns.All the column values will be considered as tuple and treat it 

 ```sql
select distinct * from colors order by bcolor,fcolor;

 bcolor | fcolor 
--------+--------
 blue   | blue
 blue   | green
 blue   | red
 green  | blue
 green  | green
 green  | red
 red    | blue
 red    | green
 red    | red
 red    | 
        | red
```


**Distinct On**:

PostgreSQL also provides the DISTINCT ON (expression) to keep the “first” row of each group of duplicates using the following 

syntax:                          

```sql
SELECT
   DISTINCT ON (column_1) column_alias,
   column_2
FROM
   table_name
ORDER BY
   column_1,
   column_2;
```

The order of rows returned from the SELECT statement is unpredictable therefore the “first” row of each group of the duplicate is also unpredictable.   

It is good practice to always use the ORDER BY clause with the DISTINCT ON(expression) to make the result set obvious.Notice that the DISTINCT ON expression must match the leftmost expression in the ORDER BY clause.

testdb=# select distinct on(bcolor) bcolor,fcolor from colors order by bcolor,fcolor;
 bcolor | fcolor 
--------+--------
 blue   | blue
 green  | blue
 red    | blue
        | red
(4 rows)

For each unique bcolor value,it would return only the first unique bcolor it encounters based on ORDER BY clause along with fcolor value
