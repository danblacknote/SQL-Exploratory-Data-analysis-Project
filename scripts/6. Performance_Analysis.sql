```sql
/*
================================================================================
TITLE: Sales Data Warehouse - Product Performance Trend Analysis
AUTHOR: Deneke Zewdu
DATE: 13 Jan,2026
PURPOSE: Analyze year-over-year product performance with comparative metrics


DESCRIPTION:
This script performs sophisticated performance analysis comparing each product's
yearly sales against its historical average and the previous year's performance.
It provides insights into product growth trends, consistency, and year-over-year growth
changes using advanced window functions and comparative analytics.

KEY ANALYSIS AREAS:
1. YEARLY PRODUCT SALES - Annual revenue performance by product
2. HISTORICAL AVERAGE COMPARISON - Current sales vs. product lifetime average
3. YEAR-OVER-YEAR CHANGES - Growth/decline comparison with the previous year
4. PERFORMANCE CATEGORIZATION - Classification of performance patterns

BUSINESS INSIGHTS PROVIDED:
- Which products consistently perform above their historical average?
- What are the year-over-year growth/decline patterns for each product?
- How volatile or stable is each product's performance over time?
- Which products show positive momentum versus negative trends?

ANALYTICAL TECHNIQUES DEMONSTRATED:
1. Common Table Expressions (CTEs) for modular querying
2. Window functions: AVG() OVER() for historical averages
3. Window functions: LAG() for year-over-year comparisons
4. CASE statements for performance categorization
5. Partitioned calculations by product

COMPARATIVE METRICS CALCULATED:
- Current sales vs. historical average
- Year-over-year absolute change
- Performance categorization (above/below average, increase/decrease)
- Growth trend indicators

DEPENDENCIES:
- gold.fact_sales (sales transaction data with order_date and sales fields)
- gold.dim_product (product information, including product_name)

OUTPUT: Yearly performance matrix for each product with comparative analytics
================================================================================
*/

--- Performance Analysis 

--- Analyze the yearly performance of the  product by comparing each product's sales to both its 
--- average sales and previous sales performance

with yearly_product_sales as
(
select 
year(order_date) as order_year,
dp.product_name ,
sum(fs.sales) as current_sales

from gold.fact_sales fs
left join gold.dim_product dp
on fs.product_key = dp.product_key

where fs.order_date is not null
group by year(fs.order_date),
         dp.product_name )


select 
order_year,
product_name,
current_sales,
avg(current_sales) over(partition by product_name) as avg_sales,
current_sales - avg(current_sales) over(partition by product_name) as diff_avg_sales,
case when current_sales - avg(current_sales) over(partition by product_name) > 0 then 'above_avg'
     when current_sales - avg(current_sales) over(partition by product_name) < 0 then 'below_avg'
     else 'avg'
     end avg_change,
lag(current_sales) over(partition by product_name order by order_year ) as py_sales,
current_sales - lag(current_sales) over(partition by product_name order by order_year) as diff_py,
case when current_sales - lag(current_sales) over(partition by product_name order by order_year ) > 0 then 'Increase'
     when current_sales - lag(current_sales) over(partition by product_name order by order_year ) < 0 then 'Dicrease'
     else 'no changes'
     end py_changes
from yearly_product_sales
order by product_name, order_year
```


