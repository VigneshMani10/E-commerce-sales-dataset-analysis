

create database Primeor_solution

use Primeor_solution

select * from E_commerce_dataset

-- DATA EXPLORATION 

select count(*) as Number_of_records from E_commerce_dataset

select top 10 * from E_commerce_dataset

select COLUMN_NAME,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH 
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME like 'E_commerce_dataset'

/*
In this dataset there are totally 21 columns in that datatype of DISCOUNT,
PROFIT AND SHIPPING COST columns are "float" so in that in the dataset
the values of these columns contains more number after decimal its look
inconsistent so i need to change the values with 2 decimal numbers only
*/

alter table e_commerce_dataset alter column discount decimal (8,2)

alter table e_commerce_dataset alter column profit  decimal (8,2)

alter table e_commerce_dataset alter column shipping_cost decimal (8,2)

-- checking for the null values present in the table

select * from E_commerce_dataset
where order_id is null
or
order_date is null
or
ship_date is null
or
ship_mode is null
or
customer_name is null
or
segment is null
or
state is null
or
country is null
or
market is null
or
region is null
or
product_id is null
or
category is null
or
sub_category is null
or
product_name is null
or
sales is null
or
quantity is null
or
discount is null
or
profit is null
or
shipping_cost is null
or
order_priority is null
or
year is null

/*
This dataset is already cleaned in Microsoft excel so there is no
null values in any columns. Now the dataset is ready for SQL ANALYSIS.
*/

--SQL QUERIES:

--1.) TOP 10 PROFITABLE PRODUCTS ?

select distinct top 10 product_id,product_name,SUM(profit) [Total profit] 
from E_commerce_dataset
where profit > 0
group by product_id,product_name
order by SUM(profit) desc;

--2.) TOP 10 CUSTOMERS BY SALES ?

select distinct top 10 customer_name,SUM(sales) [Total sales] 
from E_commerce_dataset
group by customer_name
order by SUM(sales) desc;

--3.) REGION-WISE TOTAL SALES

select distinct region,SUM(sales) [Total sales] 
from E_commerce_dataset
group by region
order by SUM(sales) desc;

--4.) CATEGORY-WISE AVERAGE PROFIT

select distinct category,cast(AVG(profit) as decimal(5,2)) [Average profit]
from E_commerce_dataset
group by category
order by [Average profit] desc;

--5.) HIGHEST DISCOUNT CATEGORY

select distinct category,discount from E_commerce_dataset
where discount = (select max(discount) from E_commerce_dataset)

--6.) ORDERS WITH NEGATIVE PROFIT

select order_id,customer_name,product_id,product_name,profit 
from E_commerce_dataset
where profit < 0
order by profit

--7.) MONTHLY SALES TREND

select month(order_date) [Month Numbers],
DATENAME(month, order_date) [Month names],
SUM(sales) [Total sales] 
from E_commerce_dataset
group by month(order_date),
DATENAME(month, order_date)
order by month(order_date) asc;

--8.) MARKET-WISE REVENUE ANALYSIS

select distinct market,SUM(sales) [Total revenue] 
from E_commerce_dataset
group by market
order by SUM(sales) desc;

--9.) TOP-PERFORMING SUB-CATEGORIES

-- Top one sub-category without using top function
select distinct sub_category,SUM(sales) [Total sales] 
from E_commerce_dataset
group by sub_category
having SUM(sales) = (select MAX([Total sales]) from 
(select SUM(sales) [Total sales] from E_commerce_dataset
group by sub_category) x );

-- Top 5 sub categories 
select distinct top 5 sub_category,SUM(sales) [Total sales] 
from E_commerce_dataset
group by sub_category
order by SUM(sales) desc;

-- Top 10 sub categories
select distinct top 10 sub_category,SUM(sales) [Total sales] 
from E_commerce_dataset
group by sub_category
order by SUM(sales) desc;

--10.) SHIP MODE USAGE ANALYSIS

select distinct ship_mode,COUNT(ship_mode) [Number of Times used] 
from E_commerce_dataset
group by ship_mode
order by COUNT(ship_mode) desc;

---------------------------------- TASK 3 ----------------------------------

------ PREPARE A SHORT INSIGHTS BASED ON SQL QUERY ------

--1.) Which market generates highest revenue?

-- Insights: Asia-pacific (APAC) Market generates the highest revenue that is Rupees ₹ 35,81,785/-. 
-- because of large amount of orders (10,997) placed in this market. it also indicates the demands amoung 
-- the people in this market is high. They shows interest in purchasing various kinds of 
-- products in this E-commerce platform.

--2.) Which categories are least profitable?

-- Insights: Furniture category has least profit that is Rupees ₹ 2,86,404.57 when compared to two other categories. Because of 
-- the Discount applied for customers and shipping cost of the products of Furniture categories is second
-- larger when we compare with other two categories. Almost more than 50% of profit are less than two
-- other categories.

--3.) Which shipping mode is most commonly used ?

-- There are totally 4 kind of ship mode is available in this E-commerce platform. There are standard class
-- second class, first class, same day delivery. In this, STANDARD CLASS is the most commonly used 
-- shipping mode, because Standard class is general and cheapest option for customer than other ship mode
-- as per my domain knowledge same day, first class and second class ship modes will charge more
-- for safe and fast delivery feature. so that most of the customers are choosing "STANDARD CLASS" ship mode.
