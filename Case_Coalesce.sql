-- Case, NULLIf ,Coalesce
-- Coalesce is to handle null values, function evaluates the arugments in order and always returns first non null value from argument list..
  ---the arguments in the coalesce must be of same data type.
  ---Checks for an integer first in the sequence
  ---multiple expressions can be used for single coalesce function 



---Example to replace null state by using coalecse
insert into pets(id,name,age,animal) values(8,'perthy',3,'dog'),(9,'sno',2,null)
select coalesce(null,null,null,100,20);
/* select * from pets;
id |  name   | age | animal 
----+---------+-----+--------
  1 | bonkers | 1   | Rabbit
  2 | Moon    | 9   | Dog
  3 | Ripley  | 7   | Cat
  4 | Tom     | 1   | Cat
  5 | Maisie  | 9   | Dog
  6 | sara    | 7   | Dog
  7 | miley   | 1   | 
  8 | perthy  | 3   | dog
  9 | sno     | 2   | 
 10 |         | 1   | Cat

*/

select name || ''|| coalesce(animal,'') as animalname from pets;

/* output 

  animalname   
---------------
 bonkersRabbit
 MoonDog
 RipleyCat
 TomCat
 MaisieDog
 saraDog
 miley
 perthydog
 sno
*/

--want to pick any of name or animal, if both are in null state then NA will be assigned..
select id,age, coalesce(name,animal,'NA') animalname from pets;


/* get  output

 id | age | animalname 
----+-----+------------
  1 | 1   | bonkers
  2 | 9   | Moon
  3 | 7   | Ripley
  4 | 1   | Tom
  5 | 9   | Maisie
  6 | 7   | sara
  7 | 1   | miley
  8 | 3   | perthy
  9 | 2   | sno
 10 | 1   | Cat
 11 | 1   | NA

*/

---alter the data based on the condition more of if else condition statement 
   ---generally used as (when ,then)as key word to alter the data
 
select id,age case when animal not null then animal
when name is not null then name 
else 'NA'
animalname
from pets;

/* get  output

 id | age | animalname 
----+-----+------------
  1 | 1   | bonkers
  2 | 9   | Moon
  3 | 7   | Ripley
  4 | 1   | Tom
  5 | 9   | Maisie
  6 | 7   | sara
  7 | 1   | miley
  8 | 3   | perthy
  9 | 2   | sno
 10 | 1   | Cat
 11 | 1   | NA

*/

---NULLIF, returns the null value if two parameter are equal otherwise the first expression 
 ---NULLIF(1,2) is same as CASE WHEN exp1=exp2 then null else exp1 end
select nullif(1,1) /* NULL*/
select nullif('a','b') /* a*/

 


