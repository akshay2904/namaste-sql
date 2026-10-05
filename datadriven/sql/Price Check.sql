-- ======================================================================
-- Price Check
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/price_check
-- ======================================================================

/*
The finance team is reviewing pricing strategy across the product catalog. For each category, they need to see the average price and the number of products that actually have a price on file. Exclude any product whose price is missing, and list categories from most expensive on average to least.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['category', 'avg_price', 'product_count']:
  ['Garden', 949.2089473684211, 19]
  ['Music', 947.3216666666667, 18]
  ['Electronics', 933.3549999999999, 20]
  ['Automotive', 932.8368421052633, 19]
  ['Beauty', 907.3216666666667, 18]
*/


-- Write your SQL solution below:

SELECT
    category,
    AVG(price) AS avg_price,
    COUNT(*) AS product_count
FROM products
WHERE price IS NOT NULL
GROUP BY category
ORDER BY avg_price DESC
