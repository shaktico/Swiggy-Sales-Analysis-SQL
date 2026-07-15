 select * from Swiggy_data

 select count (*) as total_rows from Swiggy_data

 --Data Validation & cleaning 
 --Null check 

 select 
 sum(case when state is null then 1 else 0 end) as null_state,
 sum(case when city is null then 1 else 0 end ) as null_city,
 sum(case when Order_Date is null then 1 else 0 end) as null_order_date,
sum(case when Restaurant_Name is null then 1 else 0 end) as null_restaurant,
sum(case when Location is null then 1 else 0 end) as null_location,
sum(case when Category is null then 1 else 0 end) as null_category,
sum(case when Dish_Name is null then 1 else 0 end) as null_dish,
sum(case when Price_INR is null then 1 else 0 end) as null_price,
sum(case when Rating is null then 1 else 0 end) as null_rating,
sum(case when Rating_Count is null then 1 else 0 end) as null_rating_count
from swiggy_data;

 
 --Blank or Empty Strings
 select * from Swiggy_data
 where state ='' or city = '' or Restaurant_Name = '' or Location = '' or Category = '' or Dish_name = ''

 --Duplicate Detection 

 select 
 state,city,order_date,restaurant_name,Location,category,Dish_name,Price_inr,rating,rating_count,count(*) as CNt from Swiggy_data
 group by state,city,order_date,restaurant_name,Location,category,Dish_name,Price_inr,rating,rating_count
 having count(*) >1

 --delete Duplicate
with CTE as(
select *,ROW_NUMBER()over(partition by state,city,order_date,restaurant_name,Location,category,Dish_name,Price_inr,rating,rating_count
order by (select null)
)as T
from Swiggy_data
)
delete from CTE where T>1

select * from Swiggy_data


--create Schema:-
--Dimension Table
--Date Table
create table dim_date(
date_id int identity (1,1) primary key,
full_date int,
year int,
month int,
Month_name varchar(30),
Quarter int,
day int,
week int)

--Dim_loaction
create table dim_location(
    location_id int identity(1,1) primary key,
    state varchar(100),
    city varchar(100),
    location varchar(200)
);
--dim_restaurant
create table dim_restaurant(
restaurant_id int identity(1,1) primary key,
restaurant_name varchar(200),
)
--dim category
create table dim_category(
category_id int identity(1,1) primary key,
category varchar(200)
)
--dim Dish
create table dim_dish(
dish_id int identity (1,1) primary Key,
Dish_name varchar(200)
)

 --fact table
 
 create table fact_swiggy_orders(
    order_id int identity(1,1) primary key,
    date_id int,
    Price_INR decimal(10,2),
    Rating decimal(4,2),
    rating_count int,

    location_id int,
    restaurant_id int,
    category_id int,
    dish_id int,

    foreign key (date_id) references dim_date(date_id),
    foreign key (location_id) references dim_location(location_id),
    foreign key (restaurant_id) references dim_restaurant(restaurant_id),
    foreign key (category_id) references dim_category(category_id),
    foreign key (dish_id) references dim_dish(dish_id)
);


-- insert data in tables
-- dim_date

insert into dim_date
(full_date, year, month, month_name, quarter, day, week)

select distinct
    order_date,
    year(order_date),
    month(order_date),
    datename(month, order_date),
    datepart(quarter, order_date),
    day(order_date),
    datepart(week, order_date)
from swiggy_data
where order_date is not null;

select * from dim_date

--dim_loaction
insert into dim_location (state, city, location)
select distinct
state,
city,
location from Swiggy_data

select *from dim_location

--dim restaurant
insert into dim_restaurant (restaurant_name)
select distinct
restaurant_name
from Swiggy_data

--dim category
insert into dim_category (category)
select distinct
category
from Swiggy_data

--dim dish
insert into dim_dish(Dish_name)
select distinct
Dish_name
FROM Swiggy_data

 


 -- insert data into fact table

insert into fact_swiggy_orders
(
    date_id,
    price_inr,
    rating,
    rating_count,
    location_id,
    restaurant_id,
    category_id,
    dish_id
)

select
    dd.date_id,
    s.price_inr,
    s.rating,
    s.rating_count,
    dl.location_id,
    dr.restaurant_id,
    dc.category_id,
    dsh.dish_id

from swiggy_data s

join dim_date dd
    on dd.full_date = s.order_date

join dim_location dl
    on dl.state = s.state
    and dl.city = s.city
    and dl.location = s.location

join dim_restaurant dr
    on dr.restaurant_name = s.restaurant_name

join dim_category dc
    on dc.category = s.category

join dim_dish dsh
    on dsh.dish_name = s.dish_name;

	SELECT * FROM fact_swiggy_orders

	select * from fact_swiggy_orders f
join dim_date d on f.date_id = d.date_id
join dim_restaurant r  on f.restaurant_id = r.restaurant_id
join dim_category c on f.category_id = c.category_id
join dim_dish di on f.dish_id = di.dish_id;

--kpi's
--Total orders
select count(*) as total_orders
from fact_swiggy_orders

--total_revenue (INR million)

select format(sum(convert(float,price_inr))/1000000,'n2')+' inr  million' as total_revenue from fact_swiggy_orders f 

--Average Dish prize 
select format(avg(convert(float,price_inr)),'n2') as total_revenue from fact_swiggy_orders f 
--Average Rating
select cast(avg(Rating) as decimal(9,2)) as Average_rating from fact_swiggy_orders


--Deep- dive business Analysis

--Monthly orders Trends 
 select d.year, d.month,d.month_name,
 count(*) as total_orders,
  format(sum(convert(float,price_inr))/1000000,'n2')+' inr  million' as total_revenue
 from fact_swiggy_orders f
 join dim_date d 
 on f.date_id = d.date_id
 group by d.year, d.month,d.month_name
 order by total_revenue desc

 --Quaterly Trends
  select d.year, d.Quarter,
 count(*) as total_orders,
  format(sum(convert(float,price_inr))/1000000,'n2')+' inr  million' as total_revenue
 from fact_swiggy_orders f
 join dim_date d 
 on f.date_id = d.date_id
 group by d.year, d.Quarter
 order by total_revenue desc

 --Yearly trends
   select d.year,
 count(*) as total_orders,
  format(sum(convert(float,price_inr))/1000000,'n2')+' inr  million' as total_revenue
 from fact_swiggy_orders f
 join dim_date d 
 on f.date_id = d.date_id
 group by d.year
 order by total_revenue desc

  --orders by day of week (Mon- Sun)
 select  datename(weekday,d.full_date) as day_name,
  count(*) as total_orders
  from fact_swiggy_orders f
  join dim_date d 
 on f.date_id = d.date_id
 group by  datename(weekday, d.full_date),datepart(weekday, d.full_date)
 order by datepart(weekday, d.full_date)
 
 --top 10 citys by order volume
 select top 10
 l.city,
 count(*) as total_orders from fact_swiggy_orders f
 join dim_location l
 on l.location_id = f.location_id
 group by l.city
 order by total_orders desc

 --revenue contribution by states
 select l.state,
 sum(f.Price_INR) as total_revenue from fact_swiggy_orders f
 join dim_location l
 on l.location_id = f.location_id
 group by l.state, l.city
 order by total_revenue  desc

 --top 10 restaurent by orders
  select top 10 r.restaurant_name,
 sum(f.Price_INR) as total_revenue from fact_swiggy_orders f
 join dim_restaurant r
 on r.restaurant_id = f.restaurant_id
 group by r.restaurant_name
 order by total_revenue  desc


 --top category by order volume
 select top 10
 c.category,
 count(*) as total_orders from fact_swiggy_orders f
 join dim_category c on f.category_id = c.category_id
 group by  c.category
order by total_orders desc

 --most ordered Dishes
 select top 10
 d.dish_name,
 count(*) as total_orders
 from fact_swiggy_orders f
 join dim_dish d on f.dish_id = d.dish_id
 group by d.Dish_name
 order by total_orders desc

 --cuisine performance (orders + Avg rating)

 select 
 c.category,
 count(*) as total_orders,
 cast(avg(convert(float,f.rating)) as decimal(10,2)) as avg_rating
 from fact_swiggy_orders f
 join dim_category c on f.category_id = c.category_id
 group by c.category
 order by total_orders desc

 --total orders by price range


 -- total orders by price range
-- total orders by price range

select
case
    when price_inr < 100 then 'under 100'
    when price_inr between 100 and 199 then '100 - 199'
    when price_inr between 200 and 299 then '200 - 299'
    when price_inr between 300 and 499 then '300 - 499'
    else '500+'
end as price_range,
count(*) as total_orders
from fact_swiggy_orders
group by
case
    when price_inr < 100 then 'under 100'
    when price_inr between 100 and 199 then '100 - 199'
    when price_inr between 200 and 299 then '200 - 299'
    when price_inr between 300 and 499 then '300 - 499'
    else '500+'
end order by total_orders desc;

--rating count distribution( 1-5)
select 
rating,count(*) as rating_count from fact_swiggy_orders 
group by rating
order by rating_count desc


















 






