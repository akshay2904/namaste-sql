-- ======================================================================
-- The Shape of the Year
-- ======================================================================
-- Difficulty : Medium
-- Company    : Capital One
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/monthly_revenue_comparison
-- ======================================================================

/*
We're tracing a retail marketplace's revenue as it moves month by month across the calendar. For each month, report the total revenue, the number of transactions, and the average transaction value, earliest month first.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['month', 'total_revenue', 'num_transactions', 'avg_transaction_value']:
  ['2022-01', 855.12, 2, 427.56]
  ['2022-03', 696.96, 1, 696.96]
  ['2026-01', 7400.64, 10, 740.0640000000001]
  ['2026-03', 7383.69, 11, 671.2445454545455]
  ['2026-07', 6003.24, 9, 667.0266666666666]
*/


-- Write your SQL solution below:

SELECT strftime('%Y-%m', transaction_date) AS month,
       SUM(total_amount) AS total_revenue,
       COUNT(*) AS num_transactions,
       SUM(total_amount) / COUNT(*) AS avg_transaction_value
FROM transactions
GROUP BY month
ORDER BY month
