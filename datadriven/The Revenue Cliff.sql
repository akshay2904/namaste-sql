-- ======================================================================
-- The Revenue Cliff
-- ======================================================================
-- Difficulty : Medium
-- Company    : Finicity, a Mastercard
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_revenue_cliff
-- ======================================================================

/*
We're tracking monthly revenue and need to catch sharp declines. For each month show its revenue and the month-over-month percentage change, and flag any month that fell more than 10% from the previous month.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['month', 'revenue', 'prev_revenue', 'pct_change', 'flag']:
  ['2022-01', 855.12, None, None, '']
  ['2022-02', 1528.62, 855.12, 78.76, '']
  ['2022-03', 696.96, 1528.62, -54.41, 'ALERT']
  ['2022-04', 1259.22, 696.96, 80.67, '']
  ['2022-05', 562.26, 1259.22, -55.35, 'ALERT']
*/


-- Write your SQL solution below:

WITH monthly AS (
  SELECT strftime('%Y-%m', transaction_date) AS month, SUM(CAST(total_amount AS DOUBLE)) AS revenue
  FROM transactions GROUP BY strftime('%Y-%m', transaction_date)
),
with_lag AS (
  SELECT month, revenue, LAG(revenue) OVER (ORDER BY month) AS prev_revenue FROM monthly
)
SELECT month,
       ROUND(revenue, 2) AS revenue,
       ROUND(prev_revenue, 2) AS prev_revenue,
       ROUND((revenue - prev_revenue) / prev_revenue * 100, 2) AS pct_change,
       CASE WHEN (revenue - prev_revenue) / prev_revenue * 100 < -10 THEN 'ALERT' ELSE '' END AS flag
FROM with_lag
ORDER BY month
