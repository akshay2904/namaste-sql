-- ======================================================================
-- Rolling Revenue Average
-- ======================================================================
-- Difficulty : Hard
-- Company    : Amazon
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/rolling_revenue_average
-- ======================================================================

/*
Compute a 3-month rolling average of total revenue from transactions, excluding refunds (negative amounts). For each month, the average uses the current month and the two preceding months. Show year-month in YYYY-MM format and the rolling average, sorted chronologically. The first two months will not be true 3-month averages.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['ym', 'rolling_avg']:
  ['2022-01', 855.12]
  ['2022-02', 1191.8700000000001]
  ['2022-03', 1026.9]
  ['2022-04', 1161.6000000000001]
  ['2022-05', 839.48]
*/


-- Write your SQL solution below:

WITH monthly_rev AS (
    SELECT strftime('%Y-%m', transaction_date) AS ym, SUM(total_amount) AS revenue
    FROM transactions
    WHERE total_amount >= 0
    GROUP BY strftime('%Y-%m', transaction_date)
)
SELECT ym, AVG(revenue) OVER (ORDER BY ym ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_avg
FROM monthly_rev
ORDER BY ym
