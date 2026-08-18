-- ======================================================================
-- Above Average
-- ======================================================================
-- Difficulty : Easy
-- Company    : Tata Consultancy Services
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/above_average
-- ======================================================================

/*
The pricing team is identifying premium products that stand out from the rest of the catalog. Show the name, category, and price of every product whose price exceeds the overall catalog average, and include a column with that catalog-wide average for reference. Present results from most expensive to least.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['product_name', 'category', 'price', 'catalog_avg']:
  ['Basic Set v100', 'Electronics', 1859.72, 896.9192670157067]
  ['Premium Widget v99', 'Music', 1850.45, 896.9192670157067]
  ['Turbo Set v98', 'Garden', 1841.18, 896.9192670157067]
  ['Eco Widget v97', 'Automotive', 1831.91, 896.9192670157067]
  ['Smart Set v96', 'Beauty', 1822.64, 896.9192670157067]
*/


-- Write your SQL solution below:

SELECT product_name, category, price, (SELECT AVG(price) FROM products) AS catalog_avg FROM products WHERE price > (SELECT AVG(price) FROM products) ORDER BY price DESC
