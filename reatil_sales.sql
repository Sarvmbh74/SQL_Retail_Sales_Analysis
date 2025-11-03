-- SQL Retail Sales Analysis - P1

-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE  retail_sales
 		 	(
				transactions_id INT PRIMARY KEY,
				sales_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantity INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);

select * from retail_sales;

select * from retail_sales limit 10;

select 
  	count(*) 
	from retail_sales;



--Data Cleaning (Removing NULL Values)
Select * from retail_sales
where transactions_id IS NULL;


SELECT * FROM retail_sales
where 
	transactions_id IS NULL
	or
	sales_date is null
	or 
	sale_time is null 
	or 
	gender is null
	or 
	age is null
	or 
	category is null 
	or 
	quantity is null
	or 
	price_per_unit is null
	or 
	cogs is null
	or 
	total_sale is null;

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	or
	sales_date is null
	or 
	sale_time is null 
	or 
	gender is null
	or 
	age is null
	or 
	category is null 
	or 
	quantity is null
	or 
	price_per_unit is null
	or 
	cogs is null
	or 
	total_sale is null;


-- DATA EXPLORATION
-- How many sales you have ?
SELECT COUNT(*) as total_sales FROM retail_sales;

-- How many customers we have ?
SELECT COUNT(Customer_id) AS Customers from retail_sales; 

-- How many unique customers we have ?
SELECT COUNT(DISTINCT customer_id) as dist_customer from retail_sales;

-- Unique Category
Select count(distinct category) as category_name from retail_sales;

--- Data Analysis & Business Key Problems & Answers.
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select  * 
from retail_sales
where sales_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select 
   *
from retail_sales
where category = 'Clothing'
	and 
	TO_CHAR(sales_date, 'YYYY-MM') ='2022-11'
	and
	quantity >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select 
	category,
	SUM(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
group by 1;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	ROUND(AVG(age)) as average_age
from retail_sales
where category = 'Beauty';

--  Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from retail_sales
where total_sale >= 1000;

select count(*)
from retail_sales
where total_sale >= 1000;

--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
	category,
	gender,
	Count(*) as total_transaction
from retail_sales
Group by category,
	gender
order by 1;

--  Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT * FROM 
(
SELECT 
	EXTRACT(YEAR FROM sales_date) as year,
	EXTRACT(MONTH FROM sales_date) as month,
	ROUND(AVG(total_sale)) as average_sales,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sales_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1,2
) as t1
where rank = 1
-- ORDER BY 1,3 DESC;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category, 			
	count(distinct(customer_id))
from retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sale
as
(
select *,
	case
		when extract(hour from sale_time) < 12 then 'morning' 
		when extract(hour from sale_time) between 12 and 17 then 'afternoon' 
		else 'evening'
	end as shift
from retail_sales
)
select
	shift,
	count(*) as total_orders
from hourly_sale
group by shift;

-- end ---