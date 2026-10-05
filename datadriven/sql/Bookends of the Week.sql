-- ======================================================================
-- Bookends of the Week
-- ======================================================================
-- Difficulty : Hard
-- Company    : Meta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/weekly_transaction_day_split
-- ======================================================================

/*
A payments team is profiling how each week's spending clusters around its two edges, Monday and Sunday. For every week, give the percentage of that week's transaction volume that fell on Monday and the percentage that fell on Sunday, each rounded to the nearest whole number, earliest week first.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['week_num', 'monday_pct', 'sunday_pct']:
  ['00', 0, 1]
  ['01', 38, 0]
  ['02', 0, 4]
  ['03', 0, 13]
  ['04', 100, 0]
*/


-- Write your SQL solution below:

WITH weekly AS (
  SELECT
    strftime('%W', transaction_date) AS week_num,
    SUM(total_amount) AS week_total,
    SUM(CASE WHEN strftime('%w', transaction_date) = '1' THEN total_amount ELSE 0 END) AS monday_total,
    SUM(CASE WHEN strftime('%w', transaction_date) = '0' THEN total_amount ELSE 0 END) AS sunday_total
  FROM transactions
  GROUP BY week_num
)
SELECT
  week_num,
  CAST(ROUND(monday_total * 100.0 / week_total) AS REAL) AS monday_pct,
  CAST(ROUND(sunday_total * 100.0 / week_total) AS REAL) AS sunday_pct
FROM weekly
ORDER BY week_num;
