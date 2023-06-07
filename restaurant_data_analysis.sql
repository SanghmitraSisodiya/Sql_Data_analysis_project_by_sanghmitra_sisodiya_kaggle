# **Swiggy Restaurant Data Analysis - Kaggle Set - Sanghmitra Sisodiya**

# 1 use database
use sql_project_mumbairest;

# 2 table name change
ALTER TABLE project6sqlmumbai_restaurants
RENAME TO restro_data;

# 3 print all
select*from restro_data;
                 -----------------------
# 4 describe dataset
describe restro_data;
select count(*) from restro_data;
                   -----------------------

# 5 Trim extra characters from Cost Column
Update restro_data set Cost = TRIM('â‚¹' FROM cost)
;
select * from restro_data ;

# 6 alter column name
#use ( `` ) for column names with spaces
ALTER TABLE restro_data
RENAME COLUMN `Delivery time` to delivery_time;
 
 describe restro_data;
 
# 7 rating daata type alter 
ALTER TABLE restro_data 
MODIFY COLUMN rating int;

# 8 print new data tye

select*from restro_data;
describe restro_data;

ALTER TABLE restro_data
MODIFY COLUMN cost int;
Update restro_data 
set delivery_time = TRIM(' MINS' FROM delivery_time)
;

ALTER TABLE restro_data
MODIFY COLUMN delivery_time int;
describe restro_data;


#how many total restaurants are there in the data?
Select count(name ) from restro_data;


#n 9 o. of restro each ctegry
select specials as category, count(distinct name) as total_restro from restro_data
group by specials
order by total_restro desc;

# 10 show details of restaurats with Indian speciality, sort cost lowest to highest
Select * from restro_data
where specials like "%indian%"
order by cost;

# 11 how many restaurants have indian as one of their speciality
with cte1 as (
    select specials as category, count(distinct name) as total_restro from restro_data
    where specials like "%indian%"
    group by specials
    order by total_restro desc)
    
select sum(total_restro)
from cte1; 

# 12 how many restaurants have only indian speciality
with cte1 as (
     select specials as category, count(distinct name) as total_restro from restro_data
     where specials in ("indian")
     group by specials
     order by total_restro desc)
     
select sum(total_restro)
from cte1; 

# 13 Special wise average rating
select specials, avg(rating) as avg_rating from restro_data
group by specials
order by avg_rating asc;

# 14 total How many restaurants are there by each rating type? No. of restro by rating?
select count(distinct name) from restro_data;
select rating, count(distinct name) as total_restro 
from restro_data
group by rating
order by rating desc;

select * from restro_data ;

# 15 list different types of coupons are available? 
select distinct(coupons) from restro_data;

# 16 coupon wise restaurants? # List the popularity of coupons being used by restaurants
select distinct(coupons) as Coupons, count(distinct name) as no_of_restro
from restro_data
group by Coupons
order by no_of_restro desc;

# 17 coupon wise avg rating
select Coupons, avg(rating)
from restro_data
group by coupons;

#  18                 PRINT 
select *from restro_data;

# 19 most expensive restro 1500 plus
with cte1 as(
  select *from restro_data where cost >1499
  order by cost)
  
select*, dense_rank () over (order by cost desc) from cte1
order by cost desc;

# 20 how many restro have 1500 plus cost?
with cte1 as(
  select *from restro_data where cost >1499
  order by cost)
  
select Count(distinct name) from cte1;

#21 longest delivery_time 1hr plus
with cte1 as(
  select *from restro_data 
  where delivery_time > 60
  order by delivery_time)
  
select distinct name, rating, specials, cost, delivery_time, dense_rank () over (order by delivery_time desc) as denserank from cte1
order by delivery_time desc;

# 22 how many restro have delivery_time 1hr plus

with cte1 as(
  select *from restro_data 
  where delivery_time > 60
  order by delivery_time)
  
select Count(distinct name) as restaurants from cte1;

# 23 30min or less delivery_time
with cte1 as(
  select *from restro_data 
  where delivery_time < 31
  order by delivery_time)
  
select distinct name, specials, cost, delivery_time, dense_rank () 
over (order by delivery_time) as denserank from cte1
order by delivery_time;

# 24. how many rwestro have 30min less delivery_time
with cte1 as(
  select *from restro_data 
  where delivery_time < 31
  order by delivery_time)
  
 select Count(distinct name) as restaurants from cte1;

# 25. Special wise average Cost                    r karo                     ating
select specials, avg(rating) as avg_rating from restro_data
group by specials
order by avg_rating asc;

# 26. Clustering on the basis of type of specials and total number of factors
with cte1 as (
  select specials, count(distinct name) as total_restro, 
  count(distinct rating) as unique_rating, 
  count(distinct delivery_time) as distinct_time, 
  count(distinct cost) as unique_cost, 
  count(distinct coupons) as unique_coupon 
  from restro_data
  group by specials
)

select specials, sum(total_restro), 
sum(unique_rating), sum(distinct_time), 
sum(unique_cost) , sum(unique_coupon)
from cte1
group by specials
order by sum(total_restro)desc;

# 27. special wiseavg cost time rating
select specials, avg(cost) , avg(delivery_time), avg(rating) from restro_data
group by specials
order by avg(cost), avg(delivery_time)asc, avg(rating)desc ;

# 28. Clustering on the basis of rating and total number of factors
with cte1 as (
  select rating, count(distinct specials) as distinct_specials,
  count(distinct name) as total_restro, 
  count(distinct delivery_time) as distinct_time, 
  count(distinct cost) as unique_cost, 
  count(distinct coupons) as unique_coupon 
  from restro_data
  group by rating
)

select rating, sum(total_restro), sum(distinct_specials), sum(distinct_time), 
sum(unique_cost) , sum(unique_coupon)
from cte1
group by rating
;

# 29. rating wise avg cost time 
select rating, count(distinct name) as no_of_restro, avg(cost), 
avg(delivery_time) from restro_data
group by rating
order by avg(cost), avg(delivery_time)asc ;

# 30. Clustering on the basis of delivery_time and total number of related factors

with cte1 as (
  select delivery_time, count(distinct name) as total_restro, 
  count(distinct specials) as distinct_specials ,
  count(distinct rating) as unique_rating, 
  count(distinct cost) as unique_cost, count(distinct coupons) as unique_coupon
  from restro_data
  group by delivery_time)

select delivery_time, sum(total_restro), sum(distinct_specials), sum(unique_rating), 
sum(unique_cost) , sum(unique_coupon)
from cte1
group by delivery_time
order by delivery_time desc;

# 31. special wiseavg cost time rating
select delivery_time, count(distinct name) as no_of_restro, avg(cost), avg(rating) from restro_data
group by delivery_time
order by delivery_time desc ;


# 32. Clustering on the basis ofcost and total number of distinct related factors
with cte1 as (
  select cost, count(distinct delivery_time) as distinct_delivery_times, 
  count(distinct name) as total_restro, 
  count(distinct specials) as distinct_specials ,
  count(distinct rating) as unique_rating, 
  count(distinct coupons) as unique_coupon
  from restro_data
  group by cost)
  
select cost, sum(distinct_delivery_times), sum(total_restro), sum(distinct_specials), 
sum(unique_rating), sum(unique_coupon)
from cte1
group by cost
order by cost desc;

# 33. cost wise avg
select cost, count(distinct name) as no_of_restro,  avg(delivery_time), avg(rating) from restro_data
group by cost
order by cost desc ;

# 34. Clustering on the basis of coupons and distinct total number of factors
with cte1 as (
  select coupons, count(distinct specials) as distinct_specials, count(distinct name) as total_restro, 
  count(distinct rating) as unique_rating, count(distinct delivery_time) as distinct_time, 
  count(distinct cost) as unique_cost
  from restro_data
  group by coupons
)

select coupons, sum(distinct_specials), sum(total_restro), sum(unique_rating), sum(distinct_time)
from cte1
group by coupons
order by sum(total_restro)desc;

# 35. coupon wise avg cost time rating
select coupons, count(distinct name) as no_of_restro, avg(cost) , 
avg(delivery_time), avg(rating) from restro_data
group by coupons
order by no_of_restro desc ;

# 36. show top 5 most expensive restaurants
with cte1 as(
  select * , 
  dense_rank () over (order by cost desc) as ranking
  from restro_data
)

select distinct name, cost, ranking
 from cte1
 where ranking <6;
 
 # 37. show top 5 most budget friendly restaurants
 
with cte1 as(
  select * , 
  dense_rank () over (order by cost) as ranking
  from restro_data
)

select distinct name, cost, ranking
 from cte1
 where ranking <6;
 
 # 38. show top 5 most famous coupons
with cte1 as(
  select distinct(coupons) as Coupons, count(distinct name) as total_restro
  from restro_data
  group by Coupons
  order by total_restro desc),
cte2 as (
  select *, dense_rank () over (order by total_restro desc) as ranking 
  from cte1)
  
select * from cte2
where ranking <6 ;

 # 39. top 5 most famous specials
 with cte1 as ( 
   select distinct(specials) as specials, count(distinct name) as total_restro
   from restro_data
   group by specials
   order by total_restro desc),
cte2 as (
  select *, dense_rank () over (order by total_restro desc) as ranking 
  from cte1)
  
select * from cte2
where ranking <6 ;

 # 40. top 5 least famous specials
  with cte1 as (
    select distinct(specials) as specials, count(distinct name) as total_restro
    from restro_data
    group by specials
    order by total_restro),
cte2 as (
  select *, dense_rank () over (order by total_restro ) as ranking 
  from cte1)
  
select * from cte2
where ranking <6 ;
 
 # 41. top 5 most famous frequency of cost 
 with cte1 as( 
  select distinct(cost) as cost, count(distinct name) as total_restro
    from restro_data
    group by cost
    order by total_restro desc),
cte2 as(
  select *, dense_rank () over (order by total_restro desc) as ranking 
  from cte1)
  
select * from cte2
where ranking <6 ;


 # 42. top 5 least famous frequency of cost 
  with cte1 as(
    select distinct(cost) as cost, count(distinct name) as total_restro
    from restro_data
    group by cost
    order by total_restro ),
cte2 as(
  select *, dense_rank () over (order by total_restro) as ranking 
  from cte1)
  
select * from cte2
where ranking <6 ;

 # 43.  top 5 most famous frequency of delivery time
   with cte1 as(
     select distinct(delivery_time) as delivery_time, count(distinct name) as total_restro
     from restro_data
     group by delivery_time
     order by total_restro desc),
cte2 as(
  select *, dense_rank () over (order by total_restro desc) as ranking 
from cte1)

select * from cte2
where ranking <6 ;
 
  # 44.  top 5 least famous frequency of delivery time
with cte1 as(
  select distinct(delivery_time) as delivery_time, count(distinct name) as total_restro
  from restro_data
  group by delivery_time
  order by total_restro ),
cte2 as
(select *, dense_rank () over (order by total_restro ) as ranking 
from cte1)
select * from cte2
where ranking <6 ;
 

 # 45. top 5 most famous frequency of cost 
  with cte1 as
( 
  select distinct(cost) as cost, count(distinct name) as total_restro
  from restro_data
  group by cost
  order by total_restro desc),
cte2 as(
  select *, dense_rank () over (order by total_restro desc) as ranking 
from cte1)

select * from cte2
where ranking <6 ;

 # 46. top 5 most least frequency of cost 
 with cte1 as( 
   select distinct(cost) as cost, count(distinct name) as total_restro
   from restro_data
   group by cost
   order by total_restro ),
cte2 as(
  select *, dense_rank () over (order by total_restro ) as ranking 
  from cte1)
  
select * from cte2
where ranking <6 ;
