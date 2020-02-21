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

