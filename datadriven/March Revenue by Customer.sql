-- ======================================================================
-- March Revenue by Customer
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/march_revenue_by_customer
-- ======================================================================

/*
Finance is breaking down March revenue by customer. For every user who transacted that month, show the user ID and the total they spent, biggest spender first, with the user ID as the tiebreaker.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'march_total']:
  [973, 1878.8400000000001]
  [876, 1851.9]
  [1264, 1555.5600000000002]
  [1167, 1528.6200000000001]
  [100, 1232.28]
*/


-- Write your SQL solution below:

SELECT user_id,
       SUM(total_amount) AS march_total
FROM transactions
WHERE strftime('%m', transaction_date) = '03'
GROUP BY user_id
ORDER BY march_total DESC, user_id
