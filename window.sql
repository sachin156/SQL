----Window functions
 ---performs a calculation across a set of table rows which are related to current row..
 ---comparable as of aggregate function but the rows retain their identities 
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

*/


----getting the rows where sal is greater than the avg sal within in the department..
with dep_avg as(select empno,avg(sal) over(partition by dep_id)from  emp)
select empno,empname,sal from emp where emp.sal>=(select avg from dep_avg where dep_avg.empno=emp.empno); 
/*
 empno | empname |   sal    
-------+---------+----------
   766 | smit    |  8000.00
   200 | wern    | 30000.00
   201 | edi     | 36000.00
   202 | den     | 29000.00
   203 | mark    | 31000.00

*/


----row number in window function 
 ---gives row number 
select empno,empname,dep_id,row_number() over(partition by dep_id) from emp;
/* 
empno | empname | dep_id | row_number 
-------+---------+--------+------------
   784 | alen    |     40 |          1
   766 | smit    |     40 |          2
   791 | ward    |     40 |          3
    63 | ertun   |     90 |          1
   100 | Steve   |     90 |          2
   203 | mark    |     90 |          3

*/

select empno,empname,dep_id,row_number() over(partition by dep_id order by empno) from emp;


/*
 empno | empname | dep_id | row_number 
-------+---------+--------+------------
   766 | smit    |     40 |          1
   784 | alen    |     40 |          2
   791 | ward    |     40 |          3
*/


----rank() and dense rank() 
 ----rank which is slightly different from row number if two rows ordered by a column has same value then the rank to the rows will be same but it will be different with row number..
 ----then the next row will be given different (1,2,2,4) ----if two rows are same 
 ----the same table with dense rank gives(1,2,2,3)

select empno,empname,dep_id,rank() over(partition by dep_id order by sal) from emp;
/*
 empno | empname | dep_id | rank 
-------+---------+--------+------
   791 | ward    |     40 |    1
   784 | alen    |     40 |    2
   766 | smit    |     40 |    3
   732 | kane    |     40 |    4
    63 | ertun   |     90 |    1
   100 | Steve   |     90 |    2
   203 | mark    |     90 |    3
*/




----NTILE
 ---allows you to divide the ordered rows in the partition into a specified number of ranked groups 
 ---Assigns a number strating from one , for each row in group the bucket number is assigned.
select empno,empname,ntile(2) over(partition by dep_id) from emp;

/*

 empno | empname | ntile 
-------+---------+-------
   766 | smit    |     1
   784 | alen    |     1
   791 | ward    |     2
   732 | kane    |     2
   203 | mark    |     1
   100 | Steve   |     1
    63 | ertun   |     2
   202 | den     |     1
   102 | lex     |     2
   101 | Neena   |     1
   200 | wern    |     2
   201 | edi     |     1
   104 | bruce   |     2

*/


----lag and lead function 
 ---lag to access the row which comes before the current row...
 ---lag(expression,number berfore the current row)
select empno,empname,lag(numsales,1) over(partition by dep_id order by empno) from emp;

/*
empno | empname |  lag  
-------+---------+-------
   732 | kane    |      
   766 | smit    | 12.00
   784 | alen    | 20.00
   791 | ward    |  4.00
    63 | ertun   |      
   100 | Steve   | 21.00
*/

select id,price,abstract,lag(price,1) over(order by price) as prev_price,price-lag(price,1) over(order by price) as compared_price from price;
/*
 id | price |                      abstract                      | prev_price | compared_price 
----+-------+----------------------------------------------------+------------+----------------
  2 |   100 |                                                    |            |               
  2 |   200 |                                                    |        100 |            100
  3 |   300 |                                                    |        200 |            100
  4 |   400 | Price of these vegetables are very high            |        300 |            100
  1 |   500 | Price of the new vegetables                        |        400 |            100
  5 |   600 | He is famous in both the series for honking sounds |        500 |            100
*/



---lead to access the row which comes after the current row or row after 
 ---lead(expression,number after the current row)


select empno,empname,lead(numsales,1) over(partition by dep_id order by empno) from emp;
/*
 empno | empname | lead  
-------+---------+-------
   732 | kane    | 20.00
   766 | smit    |  4.00
   784 | alen    | 10.00
   791 | ward    |   
*/

----Nth value 
 ---value from nth row in an ordered partitio of a result set.

with nth_cte as(
select empno,empname,sal,nth_value(empname,1) over(partition by dep_id order by empno) from emp)
select nth_cte.*,emp.sal from nth_cte inner join emp on emp.empname=nth_cte.nth_value;

/*
 empno | empname |   sal    | nth_value |   sal    
-------+---------+----------+-----------+----------
   200 | wern    | 30000.00 | Neena     | 10000.00
   101 | Neena   | 10000.00 | Neena     | 10000.00
   202 | den     | 29000.00 | lex       | 12000.00
   102 | lex     | 12000.00 | lex       | 12000.00
   201 | edi     | 36000.00 | bruce     | 28000.00
   104 | bruce   | 28000.00 | bruce     | 28000.00
   203 | mark    | 31000.00 | ertun     | 23000.00
   100 | Steve   | 24000.00 | ertun     | 23000.00
    63 | ertun   | 23000.00 | ertun     | 23000.00

*/

----First_value,last_value
--gets the first value in the group
--first_value(price) 


select empno,empname,dep_id,first_value(sal) over(partition by dep_id order by sal) from emp;

/*
 empno | empname | dep_id | first_value 
-------+---------+--------+-------------
   791 | ward    |     40 |     1250.00
   784 | alen    |     40 |     1250.00
   766 | smit    |     40 |     1250.00
   732 | kane    |     40 |     1250.00
    63 | ertun   |     90 |    23000.00
   100 | Steve   |     90 |    23000.00
   203 | mark    |     90 |    23000.00
*/





