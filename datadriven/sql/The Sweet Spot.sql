-- ======================================================================
-- The Sweet Spot
-- ======================================================================
-- Difficulty : Medium
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cheapest_high_rated_product
-- ======================================================================

/*
A budget-conscious shopper is comparing electronics that are worth buying: in stock and rated at least 4.0. List those products cheapest first, showing just the name and price.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['product_name', 'price']:
  ['Premium Widget 30X', 235.89]
  ['Basic Set v30', 1210.82]
  ['Basic Set v70', 1581.62]
*/


-- Write your SQL solution below:

SELECT product_name, price
FROM products
WHERE rating >= 4.0
  AND in_stock = 1
  AND category LIKE '%Electronics%'
ORDER BY price ASC
