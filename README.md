
# 📊 Sales Data Warehouse Analytics Project

## 📖 Overview
This repository contains a comprehensive **Sales Data Warehouse Analytics** solution built with SQL Server. The project transforms sales data into actionable business intelligence through a structured data warehouse architecture and analytical queries.

## 🎯 Project Objectives
- **Data Warehousing**: Implement star schema design for scalable analytics
- **Business Intelligence**: Generate actionable insights from sales data
- **Performance Tracking**: Monitor customer and product performance metrics
- **Strategic Decision Support**: Provide data-driven insights for business strategy

## 🏗️ Architecture

### Data Layers
```
├── Gold Layer (Analytical)
│   ├── dim_customers        # Customer dimension
│   ├── dim_product          # Product dimension
│   ├── fact_sales           # Sales fact table
│   └── Analytical Views
│       ├── report_customers # Customer analytics
│       ├── report_product   # Product analytics
│       └── report_prodduct  # Product performance
```

### Star Schema Design
- **Fact Table**: `fact_sales` (transactions with surrogate keys)
- **Dimension Tables**: 
  - `dim_customers` (customer attributes + demographics)
  - `dim_product` (product attributes + cost structure)

## 📊 Analytical Capabilities

### 1. Exploratory Data Analysis (EDA)
- Database structure exploration
- Temporal analysis (date ranges, trends)
- Customer demographics analysis
- Sales performance metrics

### 2. Magnitude Analysis
- Customer distribution by country/gender
- Product category analysis
- Revenue distribution across segments
- Geographic sales performance

### 3. Top-N Performance Analysis
- Top 5 best/worst performing products
- Top 10 highest revenue customers
- Customer engagement rankings
- Multiple ranking methodologies

### 4. Time Series Analysis
- Monthly sales trends
- Year-over-year comparisons
- Seasonal pattern identification
- Cumulative growth tracking

### 5. Segmentation Analysis
- **Product Segmentation**: By cost ranges (Below 100, 100-500, 500-1000, Above 1000)
- **Customer Segmentation**: VIP, Regular, New, based on tenure and spending
- **Performance Segmentation**: High/Mid/Low performers by revenue

### 6. Comparative Analytics
- Product performance vs. historical averages
- Year-over-year growth/decline analysis
- Benchmarking against category averages

## 🔧 Technical Implementation

### Key SQL Features Used
- **Window Functions**: `ROW_NUMBER()`, `LAG()`, `SUM() OVER()`
- **Common Table Expressions (CTEs)**: Modular query organization
- **Advanced Joins**: Multi-table relationships with surrogate keys
- **Dynamic Segmentation**: CASE statements for business logic
- **Performance Optimization**: Efficient aggregation and indexing strategies

### Data Quality Features
- Null handling and data validation
- Consistent surrogate key generation
- Historical data filtering (`prd_end_dt IS NULL`)
- Data type consistency enforcement

## 📈 Key Business Metrics Calculated

### Customer Metrics
- Total orders, sales, and quantity purchased
- Customer lifespan and recency (months since last order)
- Average Order Value (AOV)
- Average Monthly Spend
- Customer segmentation (VIP/Regular/New)

### Product Metrics
- Total revenue and quantity sold
- Product lifespan and sales recency
- Average Selling Price (ASP)
- Average Order Revenue (AOR)
- Average Monthly Revenue (AMR)
- Performance segmentation (High/Mid/Low performer)

 

### Sample Queries
```sql
-- Get customer report
SELECT * FROM gold.report_customers ORDER BY total_sales DESC;

-- Get product performance
SELECT * FROM gold.report_product WHERE product_segment = 'High-Performer';

-- Monthly sales trend
SELECT 
    FORMAT(order_date, 'yyyy-MM') AS month,
    SUM(sales) AS monthly_revenue
FROM gold.fact_sales
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY month;
```

## 📋 Analytical Views

### `report_customers`
Comprehensive customer analytics, including demographics, transaction history, spending patterns, and segmentation.

### `report_product`
Complete product performance analysis with revenue tracking, customer adoption metrics, and profitability segmentation.

### `report_prodduct` (Legacy)
Alternative product performance view with additional historical comparisons.

## 🎨 Data Visualization Opportunities
This data warehouse supports various visualization layers:
- **Executive Dashboards**: KPI tracking and trend analysis
- **Customer Analytics**: Segmentation and lifetime value
- **Product Management**: Performance monitoring and inventory optimization
- **Sales Performance**: Territory and representative analytics



## 📝 Best Practices Implemented
- **Consistent Naming**: Standardized column and table names
- **Surrogate Keys**: System-generated keys for dimensions
- **Query Optimization**: Efficient joins and aggregations
- **Documentation**: Comprehensive comments and metadata


## 📄 License
This project is available for educational and analytical purposes.

## 👥 Author
Deneke Zewdu - Data Analyst / BI Developer

## 📞 Support
Phone: +251948956011
email: danblacknote111@gmail.com
For questions or support, please open an issue in the repository.


Last Updated: 13 Jan,2026
Version: 1.0.0

## 🎯 Next Steps
- Add predictive analytics modules
- Create Power BI/Tableau dashboards
- Expand to include inventory and supply chain analytics

---
This project demonstrates professional data warehousing practices and analytical thinking suitable for business intelligence 
roles and data engineering portfolios.

