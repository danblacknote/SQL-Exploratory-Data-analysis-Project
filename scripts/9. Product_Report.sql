/*
================================================================================
TITLE: Sales Data Warehouse - Comprehensive Product Performance Report
AUTHOR: [Your Name]
DATE: [Current Date]
PURPOSE: Generate a complete product analytics report with performance segmentation and KPIs

DESCRIPTION:
This script creates a comprehensive product performance view that consolidates
all key product metrics, sales patterns, and profitability indicators into a
single report. It provides a complete view of each product's market performance
including revenue generation, customer reach, sales velocity, and profitability
segmentation for strategic product management and inventory optimization.

KEY REPORT SECTIONS:
1. PRODUCT INFORMATION - Name, category, subcategory, and cost structure
2. SALES PERFORMANCE - Revenue, quantity sold, and order volume
3. MARKET REACH - Customer adoption and purchase frequency
4. TEMPORAL METRICS - Product lifespan and sales recency
5. PERFORMANCE SEGMENTATION - Revenue-based performance tiers
6. PROFITABILITY KPIs - Average selling price and revenue efficiency metrics

BUSINESS VALUE PROVIDED:
- Complete product performance dashboard for product managers
- Performance segmentation for resource allocation decisions
- Identification of high-margin and high-volume products
- Insights into product lifecycle and market adoption
- Data-driven product portfolio optimization

ANALYTICAL COMPONENTS:
1. Multi-stage Common Table Expressions (CTEs) for modular processing
2. Revenue-based performance segmentation
3. Customer adoption and market penetration metrics
4. Product lifecycle and sales velocity analysis
5. Comprehensive KPI calculations for profitability assessment

SEGMENTATION LOGIC:
PERFORMANCE TIERS:
- High-Performer: Total sales > $5,000
- Mid-Range: Total sales between $1,001 and $5,000
- Low-Performer: Total sales ≤ $1,000

CALCULATED KPIs:
- Total orders, sales revenue, and quantity sold
- Unique customer count (market reach)
- Product lifespan in months (market duration)
- Months since last sale (sales recency)
- Average selling price (ASP)
- Average order revenue (AOR)
- Average monthly revenue (AMR)

PROFITABILITY METRICS:
- Revenue generation efficiency
- Sales velocity and customer adoption rate
- Product lifecycle profitability
- Market penetration effectiveness

DEPENDENCIES:
- gold.fact_sales (sales transaction data)
- gold.dim_product (product catalog and cost data)

USAGE: 
SELECT * FROM gold.report_product ORDER BY total_sales DESC
================================================================================
*/

--- Full completed Product Report


/* 
##########################################################################
##                        Customer Report                               ##
##########################################################################

Purpose:
  - This report presents all the key product matrices and behavior

  Highlight:

1.	Gathers essential fields such as product name, category, subcategory, and cost details

2.	Segment the product by its revenue to identify (High-performer, Mid-range, Low-performer) 


        3. Aggregate product-level metrics:
            - total order 
            - total sales
            - total quantity sold
            - total customer 
            - lifespan (in months)
        4. Calculates Valuable KPI's
            - recency (months since last order)
            - average order revenue (AOR)
            - average monthly revenue 
           
###########################################################################
*/
create view gold.report_product as
with base_query as (
/*  
##########################################################################
##         1. Base Columns: Retrieve core columns from the tables        ##
##########################################################################
*/
select 
fs.order_date,
fs.order_number,
fs.customer_key,
fs. quantity,
fs. sales,
dp.product_key,
dp.product_name,
dp. category,
dp. subcategory,
dp. cost
from gold.fact_sales fs
left join gold.dim_product dp
on fs.product_key = dp.product_key
where order_date is not null
)
 , aggregation_product as (

 /*  
#################################################################################
##  2. Product aggregation: summarizing key metrics at the product level       ##
#################################################################################
*/
select
product_key,
product_name,
category,
cost,
subcategory,
sum(sales) as total_sales ,
sum(quantity) as total_quantity,
count(distinct order_number) as total_order,
count(distinct customer_key) as total_customer,
max(order_date) as last_order_date,
datediff(month, min(order_date), max(order_date)) as lifespan,
round(avg(cast(sales as float)/ nullif(quantity, 0)),1) as avg_saling_price

from base_query
group by 
        product_key,
        product_name,
        category,
        subcategory,
        cost
        )


select 
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        datediff(month, last_order_date, getdate()) as last_order_date,
        case when total_sales > 5000 then 'High-Performer'
             when total_sales > 1000 then 'Mid-Range'
             else 'Low-Performer'
        end as product_segment,
        lifespan,
        total_order,
        total_quantity,
        total_sales,
        total_customer,
        avg_saling_price,

    --- Average of order revenue (AOR)
        case 
            when total_order = 0 then 0
            else total_sales/ total_order
        end as avg_order_revenue,
         --- Average of monthly revenue 
        case when lifespan = 0 then total_sales
             else total_sales/lifespan
        end as avg_monthly_revenue

     from aggregation_prodcut



     --- To execute this view, run this code 
     select 
     *
     from gold.report_product



