/*
================================================================================
TITLE: Data Warehouse Exploration & Summary Report
AUTHOR: Deneke Zewdu
DATE: 13  Jan,2026
PURPOSE: Comprehensive analysis of the sales data warehouse for business intelligence

DESCRIPTION:
This script performs exploratory data analysis (EDA) on a sales data warehouse,
providing key business metrics across customers, products, and sales transactions.
It examines database structure, date ranges, customer demographics, sales performance,
and generates a unified summary report of essential business KPIs.

KEY ANALYSIS SECTIONS:
1. DATABASE STRUCTURE - Examines tables and columns in the data warehouse
2. TEMPORAL ANALYSIS - Date ranges and time periods of available data
3. CUSTOMER ANALYSIS - Demographics and customer base metrics
4. PRODUCT ANALYSIS - Product categories and inventory metrics
5. SALES PERFORMANCE - Revenue, quantity, and pricing analysis
6. UNIFIED SUMMARY REPORT - Consolidated KPIs for executive reporting

BUSINESS QUESTIONS ANSWERED:
- What is our total sales revenue and order volume?
- How many unique customers and products do we have?
- What is our sales history time range?
- What are the key customer demographics?
- What are the average selling prices and quantities sold?

DEPENDENCIES:
- gold.fact_sales (fact table)
- gold.dim_customers (customer dimension)
- gold.dim_product (product dimension)

OUTPUT: Multiple result sets showing database structure and business metrics
================================================================================
*/

--- Explore all the database objects
select * from INFORMATION_SCHEMA.TABLES



--- Explore all columns in the Database
select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='dim_customers'


--- Exploring all countries, our customers 
select distinct country
from gold.dim_customers 



--- Exploring all product categories in the major Division
select distinct 
subcategory,
product_name,
catagory 
from gold.dim_product



/* Date Exploration: find the first and last order date 
How many years of seals are available */

Select distinct 
min(shipment_date) as first_order_date,
max(shipment_date) as last_order_date,
min(due_date) as first_due_date,
max(due_date) as last_due_date,
datediff(year,min(shipment_date), max(shipment_date)) as order_range_years,
datediff(month,min(shipment_date), max(shipment_date)) as order_range_months
from gold.fact_sales


--- Find the Youngest and the Oldest Customer
Select 
min(birth_date) as youngest_cust,
max(birth_date) as Oldest_cust,
datediff(year, min(birth_date),getdate()) as Oldest_Cust,
datediff(year, max(birth_date),getdate()) as Yangest_Cust
from gold.dim_customers





--- Find the total sales
select 
count(*) as sales_count,
sum(seals) as total_sales
from gold.fact_sales


--- Find total item sold
Select 
Sum(quantity) as total_item_sold
from gold.fact_sales


--- Find the average selling price
select 
AVG(price) as average_price
from gold.fact_sales


--- Find the total number of orders
select 
count(order_number) total_order,
count(distinct order_number) as distinc_order
from gold.fact_sales



--- Find the total number of products
select 
count(product_key) as total_num_products,
count(distinct product_key) as distinct_num_products
from gold.dim_product


--- Find the total number of customers
selected 
count(customer_key) as totao_customers
from gold.dim_customers



--- Find the total number of customers placed an order
select 
count(distinct customer_key) as customers_placed_order
from gold.fact_sales



/*
########################################################################
###                           Generalized Report                     ###
######################################################################## */

select 'Total Seals' as Measure_name, 
sum(seals) as Measure_value
from gold.fact_sales

UNION All

Select 'Total Quantity' as Measure_name,
Sum(quantity) as Measure_value
from gold.fact_sales

UNION ALL


select 'Avrage Selling Price' as Measeur_name,
AVG(price) as Measure_value
from gold.fact_sales

UNION ALL

select 'Total Number of Orders' as Measure_name,
count(distinct order_number) as distinc_order
from gold.fact_sales

UNION ALL

select 'Total Number of Products' as Measure_name,
count(product_key) as Measure_value
from gold.dim_product

UNION ALL

select 'Total Number of Customers' as Measure_name,
count(customer_key) as Measure_value
from gold.dim_customers

UNION ALL

select 'Total_Coustomer_Ordered' as Measure_name, 
count(distinct customer_key) as Measure_value
from gold.fact_sales
