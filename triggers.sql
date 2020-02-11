----Triggers
 ---function which is invoked whenever an event associated with table occurs (automatically invoked)
 ---create a triger (which is user defined function) and bind this to table
 ---row and statement level triggers 
 ---useful if the database is accessed by various applications and for cross functionality 
 ---use to maintain complex data integrity rules

---new table
create table price(id serial ,price integer);

---when we insert new row in price then log the details into price_audit
create table price_audit(
book_id int not null,
entry_date text not null);


create function myfunc() returns trigger as  $my_table$
 begin
 insert into price_audit(book_id,entry_date) values(new.ID,current_timestamp);
 return new
 ;
 end;
 $my_table$ language plpgsql;

---bind trigger with the table
create trigger price_trigger after insert on price for each execute procedure myfunc();

insert into price values(2,200);

select * from price_audit;

/*
 book_id |            entry_date            
---------+----------------------------------
       2 | 2020-02-10 16:55:39.631168+05:30
*/



---create trigger to check the condition 
create function price_check() returns trigger as $$ 
begin
if (new.price)<100 then 
raise exception 'Price should be greater than equal to 100';
end if;
return new;
end;
$$ language plpgsql;


create trigger price_check_trigger before insert or update on price for each row execute procedure price_check();


insert into price values(4,30);
/*
 Error: Price should be greater than equal to 100
*/
---drop trigger
  drop trigger price_trigger on price;

---update the trigger function using replace...

create or replace function myfunc() returns trigger as $my_table$
begin 
insert into price_audit(book_id,entry_date,operation) values(new.ID,current_timestamp,TG_OP);
return new;
end;
$my_table$ language plpgsql;


insert into price values(2,100);
select * from price_audit;

/*
 book_id |            entry_date            | operation 
---------+----------------------------------+-----------
       2 | 2020-02-10 16:55:39.631168+05:30 | 
       4 | 2020-02-11 10:38:11.310957+05:30 | 
       2 | 2020-02-11 11:31:42.558251+05:30 | DELETE
       2 | 2020-02-11 11:34:55.709291+05:30 | INSERT
*/


---Trigers can be used to derive values to the table based on the insert into the table 

alter table price add column abstract text;
alter table price add column ts_abstract tsvector;
alter table price_audit add column abstract text;


create or replace function person_bit() returns trigger as $$
begin
if (new.price)<100 then 
raise exception 'Price should be greater than 100';
end if 
;
insert into price_audit (book_id,entry_date,operation,abstract) values(new.id,current_timestamp,TG_OP,new.abstract);
select to_tsvector(new.abstract) into new.ts_abstract;
return new;
end;
$$ language plpgsql;

----here the trigger function is used to check the price (to be less than 100) and also to derive the values of the abstract (converts into vector using tsvector)

update price set abstract='Price of these vegetables are very high' where id=4;
select * from price;

/*

the trigger derives the values for ts_abstract, so if trying to insert into the ts_abstract will be discarded and replaced with the value derived from the trigger
 id | price |                abstract                 |         ts_abstract          
----+-------+-----------------------------------------+------------------------------
  2 |   200 |                                         | 
  3 |   300 |                                         | 
  2 |   100 |                                         | 
  4 |   400 | Price of these vegetables are very high | 'high':7 'price':1 'veget':4

*/

create view abridged_price as select id,price,abstract from price;
insert into abridged_price values (5,600,'He is famous in both the series for honking sounds');
select id,ts_abstract from price where id=5;
/*

 id |               ts_abstract               
----+-----------------------------------------
  5 | 'famous':3 'honk':9 'seri':7 'sound':10

*/
