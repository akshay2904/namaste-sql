-- ======================================================================
-- 72 - Product Sales
-- ======================================================================
-- Difficulty : Easy
-- Category   : Analytics
-- Companies  : Infosys
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/72-product-sales
-- ======================================================================

/*
You are provided with two tables: Products and Sales. The Products table contains information about various products, including their IDs, names, and prices. The Sales table contains data about sales transactions, including the product IDs, quantities sold, and dates of sale. Your task is to write a SQL query to find the total sales amount for each product. Display product name and total sales . Sort the result by product name.

 
Table: products
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| product_id   | int         |
| product_name | varchar(10) |
| price        | int         |
+--------------+-------------+Table: sales
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| sale_id     | int       |
| product_id  | int       |
| quantity    | int       |
| sale_date   | date      |
+-------------+-----------+
*/


-- Write your SQL solution below:
