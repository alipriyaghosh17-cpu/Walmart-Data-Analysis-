Create database Walmart;
-- #1 How many unique cities does the data have?
Select Count(distinct city) as  number_city
from walmart;
-- #2 In which city is each branch?
Select City , Branch
from Walmart 
group by city , branch ;
-- #3 How many unique product lines does the data have?
Select Count(distinct Product_line)
from walmart;
-- #4 What is the most common payment method 
Select Payment , count(Payment) as number_times
from walmart
group by Payment
order by number_times  desc
limit 1;
-- #5 What is the most selling product line
Select product_line , sum(Quantity) as most_sold
from walmart
GROUP BY product_line
ORDER BY most_sold DESC 
limit 1;

-- #6 What is the total revenue by month

Select  Month(date) as Month_number, date_format(date,'%M') as month_name, round(sum(total),1) as total_revenue
from walmart
group by Month_number , month_name;

-- #7 What month had the largest COGS?
Select  Month(date) as Month_number, date_format(date,'%M') as month_name, round(sum(cogs),1) as total_cogs
from walmart
group by Month_number , month_name
order by total_cogs desc
limit 1;

-- #8 What product line had the largest revenue?

Select product_line ,round(sum(total),2) as Revenue
from walmart
group by product_line
order by Revenue desc;

-- #9 What is the city with the largest revenue?
Select city ,round(sum(total),2) as Revenue
from walmart
group by city
order by Revenue desc;

-- #10 What product line had the largest VAT?
SELECT product_line, avg(`Tax_5%`) AS Max_VAT
FROM walmart
GROUP BY product_line
ORDER BY Max_VAT DESC
LIMIT 1;

-- #11  -- Fetch each product line and add a column to those product ,line showing "Good", "Bad". Good if its greater than average sales

With  total_sales as 
(Select product_line, sum(total) as total_s 
from walmart
group by Product_line) ,
Average as ( select  Avg(total_s ) as averge_sales from total_sales)
Select product_line, total_s ,  
Case When  total_s> averge_sales Then "Good Product"
Else "Bad product"
end as performance
from total_sales, Average;

-- #12  Which branch sold more products than average product sold?

WITH branch_totals AS (
    SELECT Branch, SUM(Quantity) AS total_products
    FROM walmart
    GROUP BY Branch
),
average_total AS (
    SELECT AVG(total_products) AS avg_products
    FROM branch_totals
)
SELECT b.Branch, b.total_products
FROM branch_totals b, average_total a
WHERE b.total_products > a.avg_products;


-- #13 What is the most common product line by gender
Select product_line , count(gender) as no_of_productline
from walmart
group by  product_line
order by no_of_productline desc;

-- #14 What is the average rating of each product line
select product_line, avg(rating) as rate
from walmart
group by Product_line
order by rate desc;



-- #15 How many unique customer types does the data have?

Select count(distinct  Customer_type) as unique_type
from walmart ;

WITH type_count AS (
    SELECT COUNT(DISTINCT Customer_type) AS unique_type
    FROM walmart
)
SELECT DISTINCT 
    Customer_type,
    unique_type
FROM walmart ,type_count;

-- #16 How many unique payment methods does the data have?
Select count(distinct Payment) as num_payment_types
from walmart ;

with num_payment_types as
(Select count(distinct Payment) as num_payt
from walmart) 
Select distinct Payment ,num_payt
from walmart,num_payment_types;

-- #17 What is the most common customer type?
Select Customer_type , count(*) as count
from walmart 
group by Customer_type
ORDER BY count DESC;

-- #18  What is the gender of most of the customers?
Select Gender , count(*) as count
from walmart 
group by Gender
ORDER BY count DESC;

-- #19 What is the gender distribution per branch?

Select Gender , Branch ,count(*) as count
from walmart 
group by Gender, branch
ORDER BY  Gender;

-- #20 Which time of the day do customers give most ratings?
Select  time , Max_rating 
from 
(Select Hour(time) as time , count(rating) as max_rating , row_number() over (ORDER BY COUNT(rating) DESC)as row_num
from walmart
group by time) as t
where row_num=1;

-- #21 Which time of the day do customers give most ratings per branch?

WITH rating AS (
   SELECT 
       HOUR(time) AS time_of_the_day, 
       branch, 
       COUNT(rating) AS most_rating  
   FROM walmart  
   GROUP BY time_of_the_day, branch
),
ranking AS (
   SELECT 
       rating.*,
       ROW_NUMBER() OVER (
           PARTITION BY branch 
           ORDER BY most_rating DESC
       ) AS row_num
   FROM rating
)
SELECT time_of_the_day, branch, most_rating
FROM ranking
WHERE row_num = 1;

-- 22 Which day fo the week has the best avg ratings?
SELECT 
    DAYNAME(date) AS day_of_week, 
    AVG(rating) AS avg_rating
FROM walmart
GROUP BY DAYNAME(date)
ORDER BY avg_rating DESC;

-- #23 Which day of the week has the best average ratings per branch?

WITH branch_ratings AS (
    SELECT 
        DAYNAME(date) AS day_of_week,
        branch,
        AVG(rating) AS avg_rating
    FROM walmart
    GROUP BY DAYOFWEEK(date), DAYNAME(date), branch
)
SELECT day_of_week, branch, avg_rating
FROM (
    SELECT 
        br.*,
        ROW_NUMBER() OVER (
            PARTITION BY branch 
            ORDER BY avg_rating DESC
        ) AS rn
    FROM branch_ratings br
) ranked
WHERE rn = 1;



-- #24 Number of sales made in each time of the day per weekday

Select   weekday(date) as week_number,
         dayname(date) as week_name ,
               Case when time between 4 and 11 then 'Morning'
               when time between 12 and 16 then "Afternoon"
               when time between  17 and 20 then  "Evening"
               Else "Night"
               End as time_of_the_day,
		count(*) as no_of_sales 
 from walmart
 group by week_number,week_name ,time_of_the_day
 order by week_number;
 
-- #25 Which of the customer types brings the most revenue?
Select customer_type , sum(total) as total_rev
from Walmart
group by customer_type
order by total_rev desc;


-- #26 Which city has the largest tax percent/ VAT (Value Added Tax)?
Select City , Max(Vat)
from walmart
group by city;

-- #27 Which customer type pays the most in VAT?
Select customer_type ,  round(sum(Vat),2) as most_of_vat 
from Walmart
group by customer_type
order by most_of_vat  desc;




























