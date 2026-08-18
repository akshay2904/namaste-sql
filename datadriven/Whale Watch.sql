-- ======================================================================
-- Whale Watch
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/whale_watch
-- ======================================================================

/*
The revenue operations team is building an account health dashboard and needs to identify high-value users. For each user, calculate their total spending, the number of transactions, and the average transaction size. Only surface users whose total spending exceeds five hundred dollars, sorted from biggest spender to smallest. Round the average to two decimal places.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'total_spend', 'txn_count', 'avg_txn_size']:
  [1070, 10511.76, 14, 750.84]
  [973, 10323.18, 14, 737.37]
  [876, 10134.6, 14, 723.9]
  [100, 8605.98, 12, 717.16]
  [1458, 8444.34, 12, 703.7]
*/


-- Write your SQL solution below:

SELECT
    user_id,
    SUM(total_amount) AS total_spend,
    COUNT(*) AS txn_count,
    ROUND(AVG(total_amount), 2) AS avg_txn_size
FROM transactions
GROUP BY user_id
HAVING SUM(total_amount) > 500
ORDER BY total_spend DESC
