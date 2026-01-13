/*
================================================================================
TITLE: Sales Data Warehouse - Temporal Trend Analysis
AUTHOR: Deneke Zewdu 
DATE: 13 Jan,2025
PURPOSE: Analyze sales performance trends and patterns over time

DESCRIPTION:
This script performs time-series analysis to track changes in key sales metrics
across monthly intervals. It examines revenue trends, customer engagement,
and sales volume patterns to identify seasonal variations, growth trends,
and performance cycles.

KEY ANALYSIS AREAS:
1. MONTHLY TREND ANALYSIS - Sales, customers, and quantity over time
2. MULTIPLE TIME FORMATTING METHODS - Demonstrates different date grouping approaches
3. TEMPORAL PATTERN IDENTIFICATION - Spot seasonal trends and growth patterns

BUSINESS INSIGHTS PROVIDED:
- How are sales trending month-over-month?
- Is customer count growing or declining over time?
- What are seasonal patterns in sales volume?
- Which months show peak performance?

ANALYTICAL TECHNIQUES DEMONSTRATED:
1. YEAR() and MONTH() functions for date decomposition
2. DATETRUNC() for clean monthly aggregation (SQL Server 2022+)
3. FORMAT() function for human-readable date formatting
4. Multiple approaches to time-series analysis

TIME PERIOD ANALYSIS:
- Monthly granularity for detailed trend observation
- Chronological ordering to visualize progression
- Null date filtering for data quality assurance

DEPENDENCIES:
- gold.fact_sales (sales transaction data with order_date field)

OUTPUT: Chronologically ordered monthly performance metrics showing trends over time
================================================================================
*/

--- Change Over Time Analysis 

--- change over time analysis 
select
year(order_date) as order_year,
month(order_date) as order_month,
sum(sales) as sales,
count(distinct customer_key) as coustomer_key,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by year(order_date),month(order_date)
order by year(order_date),month(order_date) desc



--- Another Way of Change Over Time Analysis 

select
datetrunc(month, order_date) as order_year,
sum(sales) as sales,
count(distinct customer_key) as coustomer_key,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by datetrunc(month, order_date)
order by datetrunc(month, order_date) desc



--- Another Way of Change Over Time Analysis 
select
format(order_date , 'yyy-MMM') as order_year,
sum(sales) as sales,
count(distinct customer_key) as coustomer_key,
sum(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by format(order_date , 'yyy-MMM')
order by format(order_date , 'yyy-MMM') desc
