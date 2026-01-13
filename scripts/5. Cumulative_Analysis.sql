```sql
/*
================================================================================
TITLE: Sales Data Warehouse - Cumulative Performance Analysis
AUTHOR: Deneke Zewdu
DATE: 13 Jan,2025
PURPOSE: Analyze cumulative trends and running totals of sales performance

  
DESCRIPTION:
This script performs a cumulative analysis to track the progressive accumulation
of sales metrics over time. It calculates running totals and moving averages
to visualize growth patterns, momentum, and long-term performance trends.

KEY ANALYSIS AREAS:
1. MONTHLY CUMULATIVE SALES - Running total of sales across months
2. ANNUAL CUMULATIVE TRENDS - Yearly running totals with moving averages
3. PROGRESSIVE PERFORMANCE - Visualize accumulation patterns over time

BUSINESS INSIGHTS PROVIDED:
- How do sales accumulate progressively throughout the year?
- What is the overall growth trajectory over time?
- How do moving averages smooth out short-term fluctuations?
- What is the cumulative revenue generation pattern?

ANALYTICAL TECHNIQUES DEMONSTRATED:
1. Window Functions with OVER() clause for cumulative calculations
2. Running totals using SUM() OVER(ORDER BY ...)
3. Moving averages for trend smoothing
4. Nested queries for multi-level aggregation

CUMULATIVE METRICS CALCULATED:
- Running total sales (progressive sum)
- Moving average price (smoothed pricing trends)
- Monthly and yearly accumulation patterns

DEPENDENCIES:
- gold.fact_sales (sales transaction data with order_date, sales, and price fields)

OUTPUT: Chronological progression of cumulative metrics showing growth momentum
================================================================================
*/

--- Cumulative Analysis 

--- Calculate the Total Sales in each month 
--- and running total of sales over time 
select 
order_month,
sales,
sum(sales) over(order by order_month) as running_total
from (
select
month(order_date) as order_month,
sum(sales) as sales

from gold.fact_sales
where order_date is not null
group by month(order_date)
) t



--- Calculate the Total Sales in each year
--- and moving avrage of price over time 

select 
order_year,
sales,
sum(sales) over(order by order_year) as running_total,
sum(avg_price) over(order by order_year) as moving_avg_price
from (
select
year(order_date) as order_year,
sum(sales) as sales,
avg(price) as avg_price
from gold.fact_sales
where order_date is not null
group by year(order_date)
) t
```

