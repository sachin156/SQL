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


---drop trigger
  drop trigger price_trigger on price;


