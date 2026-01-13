/*
================================================================================
TITLE: Sales Data Warehouse - Top-N Performance Analysis
AUTHOR: Deneke Zewdu
DATE: 13 Jan,2025
PURPOSE: Identify top and bottom performers across products and customers

DESCRIPTION:
This script performs Top-N analysis to identify the best and worst performing
products and customers based on revenue generation and order volume.
It helps in strategic decision-making by highlighting high-value segments
and underperforming areas that may require attention.

KEY ANALYSIS AREAS:
1. PRODUCT PERFORMANCE RANKING - Top 5 and bottom 5 products by revenue
2. CUSTOMER VALUE RANKING - Top 10 highest revenue-generating customers
3. CUSTOMER ENGAGEMENT - 3 customers with the lowest order frequency
4. MULTIPLE RANKING METHODS - Demonstrates different analytical approaches

BUSINESS INSIGHTS PROVIDED:
- Which products contribute most to company revenue?
- Which products are underperforming and may need review?
- Who are our most valuable customers?
- Which customers engage least with our products?

ANALYTICAL TECHNIQUES DEMONSTRATED:
1. Simple TOP-N queries with ORDER BY
2. Subquery-based ranking with ROW_NUMBER()
3. Multiple approaches to solve the same business problem

DEPENDENCIES:
- gold.fact_sales (sales transaction data)
- gold.dim_product (product information)
- gold.dim_customers (customer information)

OUTPUT: Multiple ranked lists showing performance extremes for strategic focus
================================================================================
*/

--- Top-N Analysis 

--- which 5 products generate the highest revenue
select top 5
dp.product_name,
sum(fs.seals) as revenue 
from  gold.fact_sales fs
left join gold.dim_product dp
on dp.product_key= fs.product_key
group by dp.product_name 
order by revenue desc

---- Another way using sub-queiry
select 
*
from
(
select top 5
dp.product_name,
sum(fs.seals) as revenue, 
row_number() over(order by sum(fs.seals) desc) as Ranke
from  gold.fact_sales fs
left join gold.dim_product dp
on dp.product_key= fs.product_key
group by dp.product_name)t
where Ranke <=5



--- What are the 5 worst performing products in terms of sales
select top 5
dp.product_name,
sum(fs.seals) as revenue 
from gold.dim_product dp
left join gold.fact_sales fs
on dp.product_key= fs.product_key
group by dp.product_name
order by revenue 


---- Another way using sub-queiry
select 
*
from
(
select top 5
dp.product_name,
sum(fs.seals) as revenue, 
row_number() over(order by sum(fs.seals)) as Ranke
from  gold.fact_sales fs
left join gold.dim_product dp
on dp.product_key= fs.product_key
group by dp.product_name)t
where Ranke <=5


--- Find the top 10 customers who  generated the highest revenue 

select
*
from (
select 
dc.customer_key,
dc.first_name,
dc.last_name,
row_number() over(order by sum(fs.seals) desc) as total_revenue
from gold.fact_sales fs
left join gold.dim_customers dc
on dc.customer_key= fs.customer_key
group by dc.customer_key,
		 dc.first_name,
		 dc.last_name
		 )t  where total_revenue <=10 


--- Find 3 customers who placed the lowest order

	select top 3
	dc.customer_key,
	dc.first_name,
	dc.last_name,
	count (distinct order_number) as customer_order 
	from gold.fact_sales fs
	left join gold.dim_customers dc
	on dc.customer_key= fs.customer_key
	group by dc.customer_key,
			 dc.first_name,
			 dc.last_name
	order by customer_order



