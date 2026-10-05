-- ======================================================================
-- Top Shelf
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_shelf
-- ======================================================================

/*
A procurement team sets vendor price ceilings from the highest price in each product category, along with the product sitting at that ceiling. Products with no price on record don't count. Give them the three categories with the highest ceilings, most expensive first.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['category', 'product_name', 'max_price']:
  ['Electronics', 'Basic Set v100', 1859.72]
  ['Music', 'Premium Widget v99', 1850.45]
  ['Garden', 'Turbo Set v98', 1841.18]
*/


-- Write your SQL solution below:

SELECT category, product_name, max_price
FROM (
    SELECT
        category,
        product_name,
        price AS max_price,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY price DESC, product_name ASC
        ) AS rn
    FROM products
    WHERE price IS NOT NULL
) ranked
WHERE rn = 1
ORDER BY max_price DESC, category ASC
LIMIT 3;
