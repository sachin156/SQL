---tables 
---facilites
---members
---booking

---to get the list of member who have used tennis court..
select mems.first_name||''||mems.surname as member,facs.name as facility from members mems inner join booking bks on bks.memid=mems.memid inner join facilites facs on bks.facid=facs.faceid where bks.facid in (0,1);

---select start time of bookings from tennis courts
select bks.starttime as starttime,fcs.name as facility from facilites fcs inner join booking bks on fcs.faceid=bks.bookid where fcs.faceid in (0,1);

---select members and their recommender..
select distinct mems.first_name||' '||mems.surname as member,(select recs.first_name||' '||recs.surname as recommender from members recs where recs.memid=mems.recommendedby) from members mems;
/*

     member     | recommender  
----------------+--------------
 alex charle    | 
 rayes Guny     | meghan charl
 bolardo gemuse | 
*/


---select starttime for booking with given name 
select starttime from booking bks inner join members mems on bks.memid=mems.memid where mems.surname='qwe';

/*
      starttime      
---------------------
 2012-02-23 11:00:00

*/



---list of members who recommended others and (recommendedto and recommendedby)

select distinct mems.surname||' '||mems.first_name as name,memself.surname||' '||memself.first_name as recommendedto from members mems inner join members memself on mems.memid=memself.recommendedby;

/*
     name     | recommendedto 
--------------+---------------
 charl meghan | Guny rayes
 charle alex  | v sachin
 charl meghan | qwe bastos

*/


update facilites set membercost=(select membercost*1.1 from facilites where name='Tennis Court1'), guestcost=(select guestcost*1.1 from facilites where name='Tennis Court1') where name ='Tennis Court2'



---delete members who have not made any bookings till now...	
delete from members where memid not in (select distinct memid from booking);



---facility that has the high number of slots booked.

select distinct facid,sum(slots) over(partition by facid) as slotsum from booking order by slotsum desc limit 1;


---number of recommendations each recommender makes.

select recommendedby,count(*) from members where recommendedby is not null group by recommendedby;

/*
 recommendedby | count 
---------------+-------
             4 |     2
             2 |     1
*/


---list of total slots booked per facility

select facid,sum(slots) from booking group by facid;
select distinct facid,sum(slots) over(partition by facid) as totalslots from booking;

/*
 facid | totalslots 
-------+------------
     6 |          2
     2 |          2
     0 |          8
     1 |          4
     3 |          2
(5 rows)
*/


----total slots booked in month of februrary of year 2012..
select facid,sum(slots) from booking where starttime>='2020-02-01' and starttime<='2020-02-29' group by facid;

/*
 facid | sum 
-------+-----
     6 |   2
     2 |   2
     0 |   8
     3 |   2
*/


---total slots booked in each month and each facility in the year 2012..
select facid,extract(month from starttime) as month,sum(slots) as totalslots from booking where starttime>='2012-01-01' and starttime<='2012-12-31' group by facid,month order by facid;

/*
 facid | month | totalslots 
-------+-------+------------
     0 |     2 |          8
     1 |     2 |          2
     2 |     2 |          2
     3 |     2 |          2
     6 |     2 |          2
     7 |     1 |          4
*/


----count of members who have made atleast one booking..
select count(distinct memid) from booking;



----total revenue of each facility..
select fks.name,sum(case when bks.memid=0 then fks.guestcost else fks.membercost end) from booking bks inner join facilites fks on bks.facid=fks.faceid group by fks.name;


/*
      name       | sum  
-----------------+------
 Badminton Court | 22.5
 Squash Court    |    7
 Snooker Table   |   14
 Tennis Court1   |   32
 Table Tennis    |    7
 Tennis Court2   | 50.6
*/

the
---get the facility id that has the highest number of slots booked...
--without using limit command..
with maxslots as (select facid,sum(slots) as slotssum from booking group by facid)
select facid,slotssum from maxslots where slotssum=(select max(slotssum) from maxslots);



----get the list of total slots booked
select facid,extract(month from starttime) as month,count(slots) as totalslots from booking where starttime>='2012-01-01' and starttime<='2012-12-21' group by rollup(facid,month) order by facid;


with slots_cte as (select facid,extract(month from starttime) as month,slots from booking where starttime>='2012-01-01' and starttime<='2012-12-21')
select facid,month,slots from slots_cte 
union    
select facid,null,sum(slots) from booking group by facid order by facid,month;
/*
 facid | month | slots 
-------+-------+-------
     0 |     1 |     2
     0 |     2 |     2
     0 |     3 |     2
     0 |       |    12
     1 |     2 |     2
     1 |     3 |     2
     1 |       |     6
     2 |     2 |     2
     2 |     3 |     2
     2 |       |     4
*/


----total hours booked per named facility
select fks.faceid,fks.name,round(sum(bks.slots)/2.0,2) as "Total hours" from booking bks inner join 
facilites fks on fks.faceid=bks.facid group by fks.faceid,fks.name order by fks.faceid;

/*
 faceid |      name       | Total hours 
--------+-----------------+-------------
      0 | Tennis Court1   |        6.00
      1 | Tennis Court2   |        3.00
      2 | Badminton Court |        2.00
      3 | Table Tennis    |        1.00
      6 | Squash Court    |        1.00

*/


---get the list of members first booking(first booking only) after a given date...
select mems.first_name,mems.surname,mems.memid,min(bks.starttime) as starttime from members mems inner join booking bks on mems.memid=bks.memid where starttime>'2012-02-01' group by mems.first_name, mems.surname,mems.memid order by memid,starttime ;

/*
first_name | surname | memid |      starttime      
------------+---------+-------+---------------------
 guest      | guest   |     0 | 2012-03-14 09:30:00
 sachin     | v       |     1 | 2012-02-23 10:00:00
 alex       | charle  |     2 | 2012-02-23 08:00:00
 schon      | jimmy   |     3 | 2012-02-23 09:30:00

*/

---get the members count column with first name and last name..

select mems.first_name,mems.surname,(select count(memid) from members) from members mems order by 
mems.memid;
---window function..
select count(*) over(),first_name,surname from members order by joindate;

/*
 first_name | surname | count 
------------+---------+-------
 guest      | guest   |     8
 sachin     | v       |     8
 alex       | charle  |     8
 schon      | jimmy   |     8
*/


---produce a numbered list of members..
 select row_number() over(order by joindate),first_name,surname from members;
/*
 row_number | first_name | surname 
------------+------------+---------
          1 | bastos     | qwe
          2 | schon      | jimmy
          3 | meghan     | charl
          4 | sachin     | v
          5 | rayes      | Guny
          6 | alex       | charle

*/

----facility id that has the highest number of slots booked..
with maxslots as (select facid,sum(slots) as slotssum from booking group by facid)
select facid,slotssum from maxslots where slotssum=(select max(slotssum) from maxslots);

/*
 facid | slotssum 
-------+----------
     1 |       12
     0 |       12
*/

---rank members by hours used..

select mems.first_name,mems.surname,round(sum(bks.slots)/2.0,2) as hours,rank() over( order by round(sum(bks.slots)/2.0,2) desc) from members mems
inner join booking bks on mems.memid=bks.memid group by mems.first_name,mems.surname;

/*
 first_name | surname | hours | rank 
------------+---------+-------+------
 schon      | jimmy   |  8.00 |    1
 alex       | charle  |  3.50 |    2
 meghan     | charl   |  2.00 |    3
 guest      | guest   |  2.00 |    3
 sachin     | v       |  1.00 |    5
 bastos     | qwe     |  1.00 |    5

*/


---top three revenue generating facilites...

select fks.name,rank() over( order by sum(case when bks.memid=0 then fks.guestcost*bks.slots else fks.membercost*bks.slots end) desc ) from booking bks inner join facilites fks on bks.facid=fks.faceid group by fks.name limit 3;  

/*
      name       | rank 
-----------------+------
 Tennis Court2   |    1
 Tennis Court1   |    2
 Badminton Court |    3
*/


----calssify facilites by values(revenue)

with cte_sum as (select fks.name,sum(case when bks.memid=0 then fks.guestcost*bks.slots else fks.membercost*bks.slots end) from booking bks 
inner join facilites fks on bks.facid=fks.faceid group by fks.name) select name,(case when sum<50 then 'low' when sum>=50 and sum<100 then 'average' else 'high' end) from cte_sum order by sum desc;
/*
      name       |  case   
-----------------+---------
 Tennis Court2   | high
 Tennis Court1   | average
 Badminton Court | low
 Snooker Table   | low
 Squash Court    | low
 Table Tennis    | low
*/

---calculate the payback time for each facility..


---calculate the rolling average of total revenue date 
select distinct date(bks.starttime) as udate,sum(case when bks.memid=0 then fks.guestcost*bks.slots else fks.membercost*bks.slots end) from booking bks inner join facilites fks on bks.facid=fks.faceid group by udate order by udate;

/*
   udate    | sum  
------------+------
 2012-01-16 |   14
 2012-01-17 |   14
 2012-01-23 |   23
 2012-02-23 | 81.6
 2012-02-25 |   42
 2012-03-14 | 31.0
 2012-03-17 | 66.0
 2012-03-23 |   16
 2012-04-25 | 52.8
*/


/*
Dataware house a relational database that is designed for query analysis rather than transaction analysis


Dataware house components--
Subject Oriented
integrated
Non Voltalie
time oriented


enterprise data warehouse (centralized data warehouse)
federated architecture (stored in seperate physical databases)
multitiered data warehouse architecture




