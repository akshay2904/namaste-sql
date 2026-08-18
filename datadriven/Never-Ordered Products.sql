-- ======================================================================
-- Never-Ordered Products
-- ======================================================================
-- Difficulty : Easy
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/never_ordered_products
-- ======================================================================

/*
Which products in the catalog have never been ordered? Show product ID and product name for items with no matching transaction.

Table: products(product_id, product_name, category, price, rating, in_stock)

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['product_id', 'product_name']:
  [1491, 'Basic Device 11X']
  [2030, 'Deluxe Bundle 22X']
  [2569, 'Pro Unit 33X']
  [3108, 'Ultra Tool 44X']
  [3647, 'Essential Set 55X']
*/


-- Write your SQL solution below:

SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN transactions t ON p.product_id = t.product_id
WHERE t.transaction_id IS NULL
