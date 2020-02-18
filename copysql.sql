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

---save table with new data from csv file with few columns





