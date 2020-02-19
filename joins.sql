----joins
 ---joins are used to retrieve data (combine columns from one or more tables based on the values of the common columns between tables)
 ---inner join,left join,right join,full join

---innner join
---fetches the rows when the two column row values matched (only gets values where both the columns are matched)

select * from basket_a; 
/*
id |  fruit   
----+----------
  1 | Apple
  2 | Orange
  3 | Banana
  4 | Cucumber

*/

select * from basket_b;

/*
 id |   fruit    
----+------------
  1 | Orange
  2 | Apple
  3 | Watermelon
*/


----inner join
select a.id a_id,a.fruit a_fruit,b.id b_id,b.fruit b_fruit from basket_a a inner join basket_b b on a.fruit=b.fruit;

/*
 a_id | a_fruit | b_id | b_fruit 
------+---------+------+---------
    1 | Apple   |    2 | Apple
    2 | Orange  |    1 | Orange
*/
-----------------------------------------
---left join
---returns all the values from the left table (here it is table a) and only returns matched values from table b if there are no matching values then it will return null values.
select a.id a_id,a.fruit a_fruit,b.id b_id,b.fruit b_fruit from basket_a a left join basket_b b on a.fruit=b.fruit;


/*
 a_id | a_fruit  | b_id | b_fruit 
------+----------+------+---------
    1 | Apple    |    2 | Apple
    2 | Orange   |    1 | Orange
    3 | Banana   |      | 
    4 | Cucumber |      | 
*/

-----------------------------------------
---right join
---reverse of left join, it returns all values from the table b and only return the matched values from table a and if nothing is matched then it returns all null values from table a. 

select a.id a_id,a.fruit a_fruit,b.id b_id,b.fruit b_fruit from basket_a a right join basket_b b on a.fruit=b.fruit;

/*
 a_id | a_fruit | b_id |  b_fruit   
------+---------+------+------------
    1 | Apple   |    2 | Apple
    2 | Orange  |    1 | Orange
      |         |    3 | Watermelon
      |         |    4 | Pear
*/


------------------------------------------
---full outer join
--this join returns all rows from the left and right table with null values when the condition is not met.
select a.id a_id,a.fruit a_fruit,b.id b_id,b.fruit b_fruit from basket_a a full outer join basket_b b on a.fruit=b.fruit;

/*
 a_id | a_fruit  | b_id |  b_fruit   
------+----------+------+------------
    1 | Apple    |    2 | Apple
    2 | Orange   |    1 | Orange
    3 | Banana   |      | 
    4 | Cucumber |      | 
      |          |    3 | Watermelon
      |          |    4 | Pear
*/

