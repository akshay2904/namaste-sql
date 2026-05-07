-- ======================================================================
-- 188 - Category Revenue ETL Pipeline
-- ======================================================================
-- Difficulty : Easy
-- Category   : ETL & Data Pipelines
-- Companies  : Practice question
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/188-category-revenue-etl-pipeline
-- ======================================================================

/*
A retail company has provided you with two datasets on GitHub :

orders.csv – containing customer order details:
order_id, product_id, quantity, order_date, region

products.csv – containing product information
product_id, category, price
Your task is to perform data cleaning and revenue analysis
by building an ETL code that performs the following operations:
 

1. Extract/Read both CSV files to DataFrame
Read both the datasets into dataframes directly from the GitHub URLs.
2. Transform the data
A. Data Cleaning
In the orders dataset:
→ Fill missing quantity values with 1
→ Convert quantity column to integer data type
In the products dataset:
→ Fill missing category values with “unknown”

B. Merge
Perform an INNER JOIN between orders and products on product_id

C. Create Derived Column
revenue = quantity * price

D. Aggregation
Compute total revenue for each category using groupby
3. Output
Print the final aggregated DataFrame with the following columns: 
category and total_revenue

Sorted by total_revenue in descending order.
*/


-- Write your SQL solution below:
