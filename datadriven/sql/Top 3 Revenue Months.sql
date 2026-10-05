-- ======================================================================
-- Top 3 Revenue Months
-- ======================================================================
-- Difficulty : Medium
-- Company    : OnDeck
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_3_revenue_months
-- ======================================================================

/*
Find the three highest-grossing months by total transaction amount, formatted as YYYY-MM.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['year_month', 'total_sales']:
  ['2026-04', 8178.42]
  ['2026-11', 7454.52]
  ['2026-01', 7400.64]
*/


-- Write your SQL solution below:

SELECT
  strftime('%Y-%m', transaction_date) AS year_month,
  SUM(total_amount) AS total_sales
FROM transactions
GROUP BY year_month
ORDER BY total_sales DESC
LIMIT 3;
