```sql
/*
================================================================================
TITLE: Sales Data Warehouse - Customer & Product Segmentation Analysis
AUTHOR: Deneke Zewdu
DATE: 13 Jan,2026
PURPOSE: Segment customers and products into meaningful groups for targeted strategies

DESCRIPTION:
This script performs segmentation analysis to categorize products by cost range
and customers by spending behavior and tenure. It enables targeted marketing,
inventory management, and customer relationship strategies by identifying
distinct groups with similar characteristics and value propositions.

KEY ANALYSIS AREAS:
1. PRODUCT COST SEGMENTATION - Group products into price tier categories
2. CUSTOMER VALUE SEGMENTATION - Classify customers by spending and tenure
3. SEGMENT SIZE ANALYSIS - Count distribution across different segments
4. STRATEGIC GROUPING - Create actionable customer and product categories

BUSINESS INSIGHTS PROVIDED:
- How are products distributed across different price points?
- What are the proportions of VIP vs. Regular vs. New customers?
- Which cost segments have the most product offerings?
- How should marketing strategies differ by customer segment?

ANALYTICAL TECHNIQUES DEMONSTRATED:
1. Common Table Expressions (CTEs) for modular analysis
2. CASE statements for multi-condition categorization
3. DATEDIFF for customer tenure calculation
4. Nested aggregation for segment size calculation
5. Strategic grouping based on business rules

SEGMENTATION CRITERIA:
PRODUCTS:
- Below $100
- $100 - $500
- $500 - $1000
- Above $1000

CUSTOMERS:
- VIP: 12+ months history AND >$5,000 spending
- Regular: 12+ months history AND ≤$5,000 spending
- New: <12 months history

DEPENDENCIES:
- gold.dim_product (product information with cost data)
- gold.dim_customers (customer information)
- gold.fact_sales (sales transaction data)

OUTPUT: Distribution counts showing segment sizes for strategic planning
================================================================================
*/

--- Segmentation Analysis



/* Segment Product into cost range 
and count how many  products fall into each segment */
with product_segmnet as (
select 
product_key,
product_name,
cost,
case when cost < 100 then 'Below 100'
	 when cost between 100 and 500 then '100 - 500'
	 when cost between 500 and 1000 then '500 - 1000'
	 else 'Above 1000'
	 end cost_range
from gold.dim_product )

select
cost_range,
count(product_key) as total_product
from product_segmnet
group by cost_range
order by total_product desc


/* Group customers into their segments based on their spending behavior:
    - VIP: customer with 12 months of history and spends more than $5,000 
	- Regular: customer with at least 12 months of history but spends $5,000 or less
	- New: customer with a life span of less than 12 months 
	and find the total number of customers by each group   */

with customer_spending as (
	select 
	cp.customer_key,
	sum(fs.sales) as total_sales,
	min(order_date) as first_order_date,
	max(order_date) as last_order_date,
	datediff(month, min(order_date), max(order_date)) as life_spane
	from gold.fact_sales fs
	left join gold.dim_customers cp
	on fs.product_key = cp.customer_key
	group by cp.customer_key )


	select 
	customer_segment,
	count(customer_key) as total_customer
	from (

	select 
	customer_key, 
	case when life_spane >= 12 and total_sales > 5000 then 'VIP'
	     when life_spane <= 12 and total_sales >= 5000 then 'Regulare'
		 else 'New'

	end customer_segment
	
	from customer_spending )t

    group by customer_segment
	order by total_customer desc
```



