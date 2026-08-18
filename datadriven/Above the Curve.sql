-- ======================================================================
-- Above the Curve
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/above_the_curve
-- ======================================================================

/*
The growth team is building a high-value customer segment for a targeted campaign. Compute each user's total spend across all transactions, then surface only users whose total exceeds the average spend. For each qualifying user, show their ID, total spend, and how far above the average they land. Present them sorted from biggest spender to smallest.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'total', 'above_avg']:
  [1070, 10511.76, 1308.7600000000002]
  [973, 10323.18, 1120.1800000000003]
  [876, 10134.6, 931.6000000000004]
  [779, 9946.02, 743.0200000000004]
  [682, 9757.44, 554.4400000000005]
*/


-- Write your SQL solution below:

WITH totals AS (
  SELECT user_id, SUM(total_amount) AS total
  FROM transactions
  GROUP BY user_id
)
SELECT
  user_id,
  total,
  total - (SELECT AVG(total) FROM totals) AS above_avg
FROM totals
WHERE total > (SELECT AVG(total) FROM totals)
ORDER BY total DESC
