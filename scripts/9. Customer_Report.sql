/*
================================================================================
TITLE: Sales Data Warehouse - Comprehensive Customer Analytics Report
AUTHOR: Deneke Zewdu
DATE: 13 Jan,2026
PURPOSE: Generate a complete customer intelligence report with segmentation and KPIs

DESCRIPTION:
This script creates a comprehensive customer analytics view that consolidates
all key customer metrics, behaviors, and segmentation into a single report.
It provides a 360-degree view of each customer, including demographic profiling,
transaction history, spending patterns, and value-based segmentation for
targeted marketing and customer relationship management.

KEY REPORT SECTIONS:
1. CUSTOMER DEMOGRAPHICS - Name, age, and basic information
2. TRANSACTION HISTORY - Order counts, sales totals, and product diversity
3. TEMPORAL METRICS - Customer lifespan, recency, and engagement duration
4. SEGMENTATION ANALYSIS - Age groups and value-based customer segments
5. PERFORMANCE KPIs - Average order value and monthly spending patterns

BUSINESS VALUE PROVIDED:
- Complete customer profile for sales and support teams
- Segmentation for targeted marketing campaigns
- Identification of high-value VIP customers
- Insights into customer lifecycle and engagement patterns
- Data-driven customer relationship management

ANALYTICAL COMPONENTS:
1. Multi-stage Common Table Expressions (CTEs) for modular processing
2. Customer lifetime value calculations
3. Age-based and spending-based segmentation
4. Recency, frequency, and monetary (RFM) analysis elements
5. Comprehensive KPI calculations

SEGMENTATION LOGIC:
AGE GROUPS:
- Under 20
- 20-29
- 30-39
- 40-49
- 50 and above

CUSTOMER VALUE SEGMENTS:
- VIP: 12+ months lifespan AND >$5,000 total sales
- Regular: ≤12 months lifespan AND ≥$5,000 total sales  
- New: All other customers

CALCULATED KPIs:
- Total orders, sales, and quantity purchased
- Product diversity count
- Customer lifespan in months
- Months since last purchase (recency)
- Average order value (AOV)
- Average monthly spend

DEPENDENCIES:
- gold.fact_sales (sales transaction data)
- gold.dim_customers (customer demographic data)

USAGE: 
SELECT * FROM gold.report_customers ORDER BY total_sales DESC
================================================================================
*/

--- Full Completed Customer report

/* 
##########################################################################
##                        Customer Report                               ##
##########################################################################

Purpose:
  - This report presents all the key customer matrices and behavior

  Highlight:
        1. Gathers Essential fields such as name, age, and transaction details
        2. Segment customers into (VIP, Regular, New) and age groups 
        3. Aggregate customer-level matrices:
            - total order 
            - total sales
            - total quantity purchased 
            - total product 
            - lifespan (in months)
        4. Calculates Valuable KPI's
            - recency (months since last order)
            - average order value
            - average monthly spend
           
###########################################################################
*/

create view gold.report_customers as 
with base_queiry as (
/*  
##########################################################################
##         1.Base Columns: Retrieve core columns from the tables          ##
##########################################################################
*/
select 
fs.order_number,
fs.order_date,
fs.product_key,
fs.quantity,
fs.sales,
dc.customer_key,
concat(dc.first_name,' ', dc.last_name) as customer_name,
datediff(year, dc.birth_date, getdate()) as age,
dc.customer_no

from gold.fact_sales fs
left join gold.dim_customers dc
on fs.customer_key = dc.customer_key
where fs.order_date is not null )

, Customer_aggregation as (
/*  
##############################################################################
##  2.customer_aggregation: summarizing key metrics at the customer level   ##
##############################################################################
*/
select 
customer_key,
customer_name,
customer_no,
age,
count(distinct order_number) as total_order,
sum(sales) as total_sales ,
sum(quantity) as total_quantity,
count(distinct product_key) as total_product,
max(order_date) as last_order_date,
datediff(month, min(order_date), max(order_date)) as lifespan
from base_queiry
group by customer_key,
         customer_name,
         customer_no,
         age 
 )


 select 
         customer_key,
         customer_name,
         customer_no,
         age,
         case when age < 20               then 'Under 20'
              when age between 20 and 29  then '20-29'
              when age between 30 and 39  then '30-39'
              when age between 40 and 49  then '40-49'
              else '50 and above'
         end age_group,
         
         case when lifespan >= 12 and total_sales > 5000  then 'VIP'
	          when lifespan <= 12 and total_sales >= 5000 then 'Regulare'
		      else 'New'

	     end customer_segment,
         last_order_date,
         datediff(month, last_order_date, getdate()) as recency,
         total_order,
         total_quantity,
         total_product,
         lifespan,

         --- Computing the avrage order value of a customer
         case when total_order = 0 then 0
         else total_sales/total_order 
         end  avg_order_val,

         --- Computing the average order value of a customer
         case when lifespan = 0 then total_sales
         else total_sales/lifespan 
         end  avg_monthly_spande

 from Customer_aggregation 



 --- To execute the view, use the code below
 select 
 *
 from gold.report_customers




