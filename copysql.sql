----copy 
 ---copy data from csv files into db
 ---copy table_name from 'loc' delimiter ',' csv header;

copy emp(empno,empname,hourpay,sal,commission,numsales,dno,dep_id) from '/home/sachinv/test.csv' delimiter ',' csv header;	
 
 ----if the csv contains all columns then column names are not reqiured 
copy emp from '/home/sachinv/test.csv' delimiter ',' csv header;


----export data to a csv file 
 ---change the folder permissions 
copy emp to '/home/sachinv/data/newtest.csv' with(format csv,header);



----Using copy to get only few columns to csv or to load only few columns into the table 

copy emp(empno,empname,hourpay,sal) to '/home/sachinv/data/newtest.csv' with(format csv,header);

                      

---save table rows with few cols into .csv file

copy temp(empno,empname,hourpay,sal) from '/home/sachinv/data/newtest.csv' delimiter ',' csv header;


test=# select * from temp;

 empno | empname | hourpay |   sal    | commission | numsales | dno | dep_id 
-------+---------+---------+----------+------------+----------+-----+--------
   766 | smit    |         |  8000.00 |            |          |     |       
   784 | alen    |         |  1600.00 |            |          |     |       
   791 | ward    |   40.00 |  1250.00 |            |          |     |       
   100 | Steve   |   30.00 | 24000.00 |            |          |     |       
   101 | Neena   |         | 10000.00 |            |          |     |       
   102 | lex     |   30.00 | 12000.00 |            |          |     |       
   104 | bruce   |         | 28000.00 |            |          |     |       
   200 | wern    |   14.00 | 30000.00 |            |          |     |       
   201 | edi     |   14.00 | 36000.00 |            |          |     |       
   202 | den     |   14.00 | 29000.00 |            |          |     |       
   203 | mark    |   23.00 | 31000.00 |            |          |     |       
    63 | ertun   |   23.00 | 23000.00 |            |          |     |       
   732 | kane    |   20.00 | 10000.00 |            |          |     |       
   163 | jack    |   22.00 | 28000.00 |            |          |     |       
   210 | ryan    |   35.00 | 29000.00 |            |          |     |       
   230 | jimmy   |   25.00 | 39000.00 |            |          |     |       
(16 rows)


---save table with new data from csv file with few columns





