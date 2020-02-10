----Constraints
 ---NOT NULL,UNIQUE,CHECK,PRIMARY Key,Foriegn Key...
 
---NOT NULL
 --Column constraint which ensures that column in the table cannot take any null value
 --no name can be required to define a null constraint..
create table newtest(id integer primary key,name varchar(56) NOT NULL,msg text);

/* Not accepting the command if we are trying to insert a null value into the column name...
test=# */
insert into newtest values(1,null,'');
/*
ERROR:  null value in column "name" violates not-null constraint
DETAIL:  Failing row contains (1, null, )
*/

---UNIQUE 
 --this enusres that no duplicate value will be allowed into column or field, (column contain only unique values)
 --can have null values with mutiple rows 
 --can be applied to different fields
 --alter column name to unique value.
alter table newtest add constraint unique_name unique(name);
insert into newtest values(1,'sid','s'),(2,'sid','s2');
/*
ERROR:  duplicate key value violates unique constraint "unique_name"
DETAIL:  Key (name)=(sid) already exists.
*/

---CHECK Constraint 
 --check constraint matches with constraint (boolean expression) and wont allow values which wont match the expression.
alter table newtest add constraint check_name check(price>10);
insert into newtest values(1,'sid','s',1),(2,'sid','s2',1);
/*
ERROR:  new row for relation "newtest" violates check constraint "check_name"
*/

---Primary key
 --unique identifier of the record and null is not accepted..
 --only one in the entire table 
insert into newtest values(1,null,'w2',11);
insert into newtest values(1,null,'w2',11);
/*
ERROR:  duplicate key value violates unique constraint "newtest_pkey"
*/
---Foreign key
 -- the unique value in the field or columns matches with actual value of primary key in the other table.
create table orders(order_id integer primary key,produc_no integer references newtest(id),quantity integer);
insert into orders values(1,4,1);
/*
ERROR:  insert or update on table "orders" violates foreign key constraint "orders_produc_no_fkey"
DETAIL:  Key (produc_no)=(4) is not present in table "newtest"
*/
insert into orders values(1,3,1);
 ---A table can contain multiple foreign keys which is used to implement many to many relationships betweeen tables 
 ---restrict prevents deletion of a reference rows.
 ---cascading is when a referecned row is deleted, rows referencing it should be automatically deleted.
create table order_items(product_no integer references id on delete restrict,
order_id integer references orders on delete cascade,msg text,primary key(product_no,order_id));
 ---deleting the rows of newtest will give error as it is restricting the reference id..
 ---But the deletion can be done when when order_id row is deleted (as it is cascaded)



