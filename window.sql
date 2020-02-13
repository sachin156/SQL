----Window functions
 ---performs a calculation across a set of table rows which are related to current row..
 ---comparable as of aggregate functino but the rows retain their identities 
 ---the window function is able to access more than just the current row..
select dep_id,empno,empname,avg(sal) over (partition by dep_id) from emp;
 --- same as aggreg function over causes the query to behave as window function
 ---always contain an over clause which  distinguishes it from aggregate function
select dep_id,empname,avg(sal) from emp group by dep_id; --error
 ---by using order by the frame consists of rows from starting to the current row in the frame
 ---window function are allowed on select and order by

select sal,sum(sal) over(order by sal) from emp;
/*
   sal    |    sum    
----------+-----------
  1250.00 |   1250.00
  1600.00 |   2850.00
  8000.00 |  10850.00
 10000.00 |  20850.00
 12000.00 |  32850.00
 24000.00 |  56850.00
 28000.00 |  84850.00
 29000.00 | 113850.00
 30000.00 | 143850.00
 31000.00 | 174850.00
 36000.00 | 210850.00
*/

 ---filter or group rows after the window calcuations are performed by using sub-select.


select empno,dep_id,empname,sal,avg(sal) over(partition by dep_id order by empno) as sal_avg from emp where sal<30000;

---query groups and orders the query by dep_id and then within each value of dep_id it is ordered by  empno

/*
 empno | dep_id | empname |   sal    |        sal_avg         
-------+--------+---------+----------+------------------------
    82 |     40 | wood    | 29000.00 |     29000.000000000000
   766 |     40 | smit    |  8000.00 |     18500.000000000000
   784 |     40 | alen    |  1600.00 | 12866.6666666666666667
   791 |     40 | ward    |  1250.00 |  9962.5000000000000000
   100 |     90 | Steve   | 24000.00 |     24000.000000000000
   102 |    100 | lex     | 12000.00 | 12000.0000000000000000
   202 |    100 | den     | 29000.00 |     20500.000000000000
   101 |    110 | Neena   | 10000.00 | 10000.0000000000000000
   104 |    120 | bruce   | 28000.00 |     28000.000000000000
*/


select empno,dep_id,empname,sal,avg(sal) over(partition by dep_id) as sal_avg from emp where sal<30000;
/*
 empno | dep_id | empname |   sal    |        sal_avg         
-------+--------+---------+----------+------------------------
   766 |     40 | smit    |  8000.00 |  9962.5000000000000000
   784 |     40 | alen    |  1600.00 |  9962.5000000000000000
   791 |     40 | ward    |  1250.00 |  9962.5000000000000000
    82 |     40 | wood    | 29000.00 |  9962.5000000000000000
   100 |     90 | Steve   | 24000.00 |     24000.000000000000
   102 |    100 | lex     | 12000.00 |     20500.000000000000
   202 |    100 | den     | 29000.00 |     20500.000000000000
   101 |    110 | Neena   | 10000.00 | 10000.0000000000000000
   104 |    120 | bruce   | 28000.00 |     28000.000000000000
(9 rows)
*/



select empno,numsales,dep_id,sum(numsales) over(partition by dep_id) as salessum,avg(numsales) over(partition by dep_id) as avgsales from emp;

/*
 empno | numsales | dep_id | salessum |      avgsales       
-------+----------+--------+----------+---------------------
   766 |    20.00 |     40 |    46.00 | 11.5000000000000000
    82 |    12.00 |     40 |    46.00 | 11.5000000000000000
   791 |    10.00 |     40 |    46.00 | 11.5000000000000000
   784 |     4.00 |     40 |    46.00 | 11.5000000000000000
    63 |    21.00 |     90 |    42.00 | 21.0000000000000000
   100 |          |     90 |    42.00 | 21.0000000000000000
   203 |    21.00 |     90 |    42.00 | 21.0000000000000000
   202 |    43.00 |    100 |    43.00 | 43.0000000000000000
   102 |          |    100 |    43.00 | 43.0000000000000000
   200 |    15.00 |    110 |    15.00 | 15.0000000000000000
   101 |          |    110 |    15.00 | 15.0000000000000000
   201 |    29.00 |    120 |    29.00 | 29.0000000000000000
   104 |          |    120 |    29.00 | 29.0000000000000000

*/



