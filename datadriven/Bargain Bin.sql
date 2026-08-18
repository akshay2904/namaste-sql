-- ======================================================================
-- Bargain Bin
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/bargain_bin
-- ======================================================================

/*
We're prepping for a vendor call and need a read on each product category's price floor, its ceiling, and the gap between the two. Skip anything with no price on file, and lead with the categories where that gap is widest.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['category', 'floor_price', 'ceiling_price', 'price_spread']:
  ['Electronics', 85.29, 1859.72, 1774.43]
  ['Music', 77.76, 1850.45, 1772.69]
  ['Garden', 70.23, 1841.18, 1770.95]
  ['Automotive', 62.7, 1831.91, 1769.21]
  ['Beauty', 55.17, 1822.64, 1767.47]
*/


-- Write your SQL solution below:

SELECT category,
       MIN(price) AS floor_price,
       MAX(price) AS ceiling_price,
       MAX(price) - MIN(price) AS price_spread
FROM products
WHERE price IS NOT NULL
GROUP BY category
ORDER BY price_spread DESC
