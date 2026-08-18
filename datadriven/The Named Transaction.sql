-- ======================================================================
-- The Named Transaction
-- ======================================================================
-- Difficulty : Easy
-- Company    : Clear Capital
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/transactions_with_product_names
-- ======================================================================

/*
The finance team's line-item report only shows product IDs. Enrich each transaction with the product name from the catalog so stakeholders can see what was actually purchased.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Table: products(product_id, product_name, category, price, rating, in_stock)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['transaction_id', 'user_id', 'product_id', 'quantity', 'transaction_date', 'product_name']:
  [1067, 197, 1001, 2, '2026-02-02', 'Basic Device 1X']
  [1134, 294, 1050, 3, '2026-03-03', 'Deluxe Bundle 2X']
  [1201, 391, 1099, 4, '2026-04-04', 'Pro Unit 3X']
  [1268, 488, 1148, 5, '2026-05-05', 'Ultra Tool 4X']
  [1335, 585, 1197, 1, '2026-06-06', 'Essential Set 5X']
*/


-- Write your SQL solution below:

SELECT
    t.transaction_id,
    t.user_id,
    t.product_id,
    t.quantity,
    t.transaction_date,
    p.product_name
FROM transactions t
INNER JOIN products p ON t.product_id = p.product_id
ORDER BY t.transaction_id;
