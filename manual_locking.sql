----locks 
 ---to prevent situations where mutliple users want to update same data at same time.locks are used to control this situation 
 ---postgres locks -> write locks or exclusive locks which prevents users from changing a row or an entire table
 ---when rows are changed by delete or update the will be locked until the transaction is commited or  rollback ,which puts a restriction on the other users from performing the changes.
 ---comes into play when users are modifying the same rows , if modifying different rows then wait is not required.

 ---locks are automatically released at the end of a transaction.
 ---only access exclusive locks blocks a select statement without for update/share
----using access exclusive locks 


--------------Access Share 
----lock table {nam} in {lock mode name} mode;
---In process A  

begin;
lock table t in access exclusive mode;
update t set b=1 where a=3;
select * from t;

---In process B
select * from t;

--No output


---In process A after commit the output will appear.
commit

---In process B

select * from t;

/*
 a | b 
---+---
 1 | 2
 2 | 3
 3 | 1
*/


----ROw locks 
 ---share,exclusive
 ---every row is protected with lock 
 ---many transactions hold share lock concurrently ,but only one transaction hold a exclusive lock.
 ---select for update or select for share will block the 



----------------row share
---In process A
insert into t values(3,5);
begin;
select * from t where a=3 for update;


----In process B
select * from t;

/*
 a | b  | c 
---+----+---
 2 |  3 |  
 1 | 10 |  
 3 | 10 |  
 3 | 10 |  
*/

update t set b=5 where a=3;
----as the rows containing a=3 are under lock they will are not able t update now.
/* unitl the trans is committed in process A the value will not be update to the table*/

---In process A
commit

---In process B
update 2


---------------------
---row exclusive
--this lock mode will be acquired by any command that modifies data in table..

----share update exculsive
---protect against concurrent schema changes and vacuum runs

---share
---this mode protect table against concurrent data changes..
	
---share row exclusive,
--protects table against concurrent data changes and only one session can hold it at a time

---exclusive
--only reads from the table can go in parallel with a transaction holding this lock mode


-----------------------


---deaadlocks
--deadlock when one transaction want the resource which is with other transaction and second transaction wants the resource of the first transaction

---In process A
begin;
update t set a=1 where b=3;

---In process B
begin;
update t set a=4 where b=10;
---try to update the same row which is on lock..
update t set a=6 where b=3;

---In process A
--update the row which is on lock from the second transaction
update t set a=5 where b=10;
/*
ERROR:  deadlock detected
DETAIL:  Process 30374 waits for ShareLock on transaction 940; blocked by process 23013.
Process 23013 waits for ShareLock on transaction 939; blocked by process 30374.
HINT:  See server log for query details.
CONTEXT:  while updating tuple (0,10) in relation "t"
*/




---Advisory locks
---locks which are database stored 



