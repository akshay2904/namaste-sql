-- ======================================================================
-- Priciest Item in Each Category
-- ======================================================================
-- Difficulty : Medium
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/priciest_item_in_each_category
-- ======================================================================

/*
For each product category, find the product with the top price. If there is a tie, include all tied products.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['category', 'product_name', 'price']:
  ['Automotive', 'Eco Widget v97', 1831.91]
  ['Beauty', 'Smart Set v96', 1822.64]
  ['Books', 'Deluxe Widget v91', 1776.29]
  ['Clothing', 'Pro Set v92', 1785.56]
  ['Electronics', 'Basic Set v100', 1859.72]
*/


-- Write your SQL solution below:

SELECT category, product_name, price
FROM (
    SELECT
        category,
        product_name,
        price,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY price DESC) AS rnk
    FROM products
) ranked
WHERE rnk = 1
ORDER BY category, product_name
