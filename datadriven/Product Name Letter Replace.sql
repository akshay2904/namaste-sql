-- ======================================================================
-- Product Name Letter Replace
-- ======================================================================
-- Difficulty : Easy
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/product_name_letter_replace
-- ======================================================================

/*
Produce every product name with all lowercase 'e' characters swapped to uppercase 'E', listed in product ID sequence.

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['product_id', 'modified_name']:
  [1001, 'Basic DEvicE 1X']
  [1050, 'DEluxE BundlE 2X']
  [1099, 'Pro Unit 3X']
  [1148, 'Ultra Tool 4X']
  [1197, 'EssEntial SEt 5X']
*/


-- Write your SQL solution below:

SELECT product_id, REPLACE(product_name, 'e', 'E') AS modified_name
FROM products
ORDER BY product_id
