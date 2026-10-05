-- ======================================================================
-- Regional Sales Growth QoQ
-- ======================================================================
-- Difficulty : Hard
-- Company    : Shopify
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/regional_sales_growth_qoq
-- ======================================================================

/*
Compare total transaction amounts in Q4 vs Q3 to compute quarter-over-quarter revenue growth by region. Growth is ((Q4 total minus Q3 total) / Q3 total) * 100. Only include regions with sales in both quarters. Return the region and growth percentage.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['region', 'growth_pct']:
  [100, -36.323317883969956]
  [197, -62.14739196306183]
  [294, -61.95378225835078]
  [391, -21.66617166617167]
  [488, 30.155816244291227]
*/


-- Write your SQL solution below:

WITH q3 AS (
    SELECT user_id AS region, SUM(total_amount) AS total
    FROM transactions
    WHERE CAST(strftime('%m', transaction_date) AS INTEGER) BETWEEN 7 AND 9
    GROUP BY user_id
)
, q4 AS (
    SELECT user_id AS region, SUM(total_amount) AS total
    FROM transactions
    WHERE CAST(strftime('%m', transaction_date) AS INTEGER) BETWEEN 10 AND 12
    GROUP BY user_id
)
SELECT q4.region, (q4.total - q3.total) * 100.0 / q3.total AS growth_pct
FROM q4
JOIN q3 ON q4.region = q3.region
