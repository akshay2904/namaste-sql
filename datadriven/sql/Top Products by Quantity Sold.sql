-- ======================================================================
-- Top Products by Quantity Sold
-- ======================================================================
-- Difficulty : Medium
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_products_by_quantity_sold
-- ======================================================================

/*
For all transactions in 2026, show each product alongside its total quantity sold, from highest volume to lowest.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['product_id', 'total_quantity']:
  [None, 30]
  [5558, 5]
  [5754, 4]
  [5705, 3]
  [5852, 2]
*/


-- Write your SQL solution below:

SELECT
  product_id,
  SUM(quantity) AS total_quantity
FROM transactions
WHERE strftime('%Y', transaction_date) = '2026'
GROUP BY product_id
ORDER BY total_quantity DESC
