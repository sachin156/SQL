----distinct, distinct on & group by 
 
 ---distinct is applicable to an entire tuple, after the result the distinct removes all the duplicates row tuples 


/* table is 

 a | b 
---+---
 1 | a
 2 | b
 3 | c
 3 | d
 2 | e
 1 | a

*/

select distinct * from r;  ---(unique row tuples)

---which is similar as 
select distinct a,b from r;

---distinct must follow select

---select distinct on (attributes) query;
 ---distinct on which is similar to the group by not identical.
 ---distinct is applicable to multiple columns distinct on (a,b) gets all the unique combined value of a,b.
 ---fetch the first entire unique row which matches 

select distinct on (a) * from r;

/*
 a | b 
---+---
 1 | a
 2 | b
 3 | c
*/


---both are useful disitinct rows from the table but distinct fetches single column whereas the distinct on



