

---Refrences 
--https://pgdash.io/blog/postgres-transactions.html
--http://shiroyasha.io/transaction-isolation-levels-in-postgresql.html

----isolation levels for transactions
 ----serializable which guarantees that concurrent transactions run sequentially one by one in order

 ---Read Repeatable allows phantom reads to happen in the transaction ,the set of rows returned by the two consecutive select queries can differ and this can happen if another transaction is adding or removing the rows 

 ---Read commited allows two consecutive select statements in a transactoin can return different data this level not only allows to return different rows but the data the rows contain.

 ---Read Uncommitted ,non committed changes from other transactions can effect a transaction.


----Every transction has isolation level set to one of these.By default it is read committed.



---if we want avoid changing any rows in between this begin and commit 
 BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;


----In process A 

 ----solves the problem of non-repeatable reads 
begin transaction isolation level repeatable read;
--BEGIN
 select sum(price) from newtest;
/*
 sum 
-----
 115
(1 row)
*/


---In process B
begin;
UPDATE newtest set price=21 where id=1;
commit;
--------


---after making changes and commit to the same table from another process.


---IN process A
select sum(price) from newtest;
/*
 sum 
-----
 115
(1 row)
*/
commit;
----After commit in process a the sum value is updated.
select sum(price) from newtest;

/*
 sum 
-----
 136
*/


----use repeatable read when we want see the same reads even though any other transaction is effecting the table.
---until the current transaction is committed the other transaction changes will not be effected.




----------------------------------


---Using serializable it will lock the update and no process will be able to 
 ---problem of lost updates (where updates performed in one transaction will be lost)
 ---if serializable isolation is used then lock the update and it will roll back the other update from second process

begin transaction isolation level serializable;
select sum(price) from newtest;
/*
 sum 
-----
 218
(1 row)
*/
insert into newtest(id,name,msg,price) values(10,null,'e2',19);


---In process B
begin transaction isolation level serializable;
select sum(price) from newtest;
/*
 sum 
-----
 218
(1 row)
*/

insert into newtest(id,name,msg,price) values(11,null,'e2',19);
commit;



----In process A
commit;

---when srerilizable isolation is used the insertion in not taking place after committed in the other process.
/*
ERROR:  could not serialize access due to read/write dependencies among transactions
DETAIL:  Reason code: Canceled on identification as a pivot, during commit attempt.
HINT:  The transaction might succeed if retried
*/


--------------------------------------

---Read committed
---if one transaction is able to see the rows inserted by another transaction then that is dirty ready because first transaction would roll back and the second transaction would have phantom rows that never existed.
---In process A
create table t(a int,b int);
begin;
insert into t values(3,3);

---In process B
select * from t;

---Empty table...

--In process A
commit
---In process B
select * from t;
/*
 a | b 
---+---
 3 | 3
*/


