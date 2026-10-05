-- ======================================================================
-- Top Users by Recent Spend
-- ======================================================================
-- Difficulty : Medium
-- Company    : Vanguard
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_users_by_recent_spend
-- ======================================================================

/*
Our loyalty program selects VIP tiers based on recent activity. Return the top 10 users by total spending in the last 30 days, only counting users with a positive total. Show user_id and their total spend, highest to lowest.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'total_spend']:
  [585, 1771.0800000000002]
  [876, 1447.8]
  [1167, 1124.52]
  [100, 818.19]
  [1458, 804.72]
*/


-- Write your SQL solution below:

SELECT user_id,
       SUM(total_amount) AS total_spend
FROM transactions
WHERE transaction_date >= DATE('now', '-30 days')
  AND transaction_date <= DATE('now')
GROUP BY user_id
HAVING SUM(total_amount) > 0
ORDER BY total_spend DESC, user_id ASC
LIMIT 10
