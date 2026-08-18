-- ======================================================================
-- Deep Pockets
-- ======================================================================
-- Difficulty : Medium
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/transaction_revenue_by_customer
-- ======================================================================

/*
We're closing the books for March 2026 and need a spend breakdown by customer. Total each customer's transactions for the month, biggest spenders first.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'total_revenue']:
  [876, 1851.9]
  [1167, 1528.6200000000001]
  [100, 1232.28]
  [1458, 1205.34]
  [294, 882.06]
*/


-- Write your SQL solution below:

SELECT user_id, SUM(total_amount) AS total_revenue
FROM transactions
WHERE transaction_date >= '2026-03-01'
  AND transaction_date < '2026-04-01'
GROUP BY user_id
ORDER BY total_revenue DESC
