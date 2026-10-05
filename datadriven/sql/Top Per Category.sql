-- ======================================================================
-- Top Per Category
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_per_category
-- ======================================================================

/*
Editorial wants to feature the top-rated product in every category. Within each category, find the product(s) with the highest rating and include all ties. Skip products with no rating. Return the product_name, category, and rating.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['product_name', 'category', 'rating']:
  ['Smart Gadget 47X', 'Automotive', 4.9]
  ['Smart Set v36', 'Beauty', 4.5]
  ['Basic Device 21X', 'Books', 4.7]
  ['Deluxe Bundle 2X', 'Clothing', 4.4]
  ['Eco Kit 28X', 'Garden', 4.6]
*/


-- Write your SQL solution below:

SELECT p.product_name,
       p.category,
       p.rating
FROM products AS p
WHERE p.rating IS NOT NULL
  AND NOT EXISTS (
        SELECT 1
        FROM products AS q
        WHERE q.category = p.category
          AND q.rating IS NOT NULL
          AND q.rating > p.rating
  )
ORDER BY p.category ASC, p.rating DESC, p.product_name ASC
