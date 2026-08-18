-- ======================================================================
-- The Spender Leaderboard
-- ======================================================================
-- Difficulty : Easy
-- Company    : IBM
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_spenders_dense_rank
-- ======================================================================

/*
Show the top 5 users by total transaction value. Tied users share the same rank with no gaps. Include all tied users at each rank.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'total_spend', 'rnk']:
  [1070, 10511.76, 1]
  [973, 10323.18, 2]
  [876, 10134.6, 3]
  [779, 9946.02, 4]
  [682, 9757.44, 5]
*/


-- Write your SQL solution below:

SELECT user_id, total_spend, rnk
FROM (
    SELECT
        user_id,
        SUM(total_amount) AS total_spend,
        DENSE_RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rnk
    FROM transactions
    GROUP BY user_id
) ranked
WHERE rnk <= 5
ORDER BY rnk, user_id;
