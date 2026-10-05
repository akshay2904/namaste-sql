-- ======================================================================
-- Ghost Products
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/ghost_products
-- ======================================================================

/*
Merchandising is hunting for dead inventory that has never sold. Find every product in products that has no matching row in transactions. Return the product_name for each.

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

Expected output ['product_name']:
  ['Basic Device 11X']
  ['Basic Set v10']
  ['Basic Set v100']
  ['Basic Set v20']
  ['Basic Set v30']
*/


-- Write your SQL solution below:

SELECT p.product_name
FROM products p
LEFT JOIN transactions t ON p.product_id = t.product_id
WHERE t.product_id IS NULL
ORDER BY p.product_name
