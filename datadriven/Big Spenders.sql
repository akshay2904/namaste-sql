-- ======================================================================
-- Big Spenders
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/big_spenders
-- ======================================================================

/*
Marketing is launching a loyalty tier program and needs to identify high-value customers. For each user, calculate their total spending and the number of transactions they have made. Only include users whose lifetime spending exceeds five hundred dollars. List them from highest spender to lowest.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'lifetime_spend', 'tx_count']:
  [1070, 10511.76, 14]
  [973, 10323.18, 14]
  [876, 10134.6, 14]
  [100, 8605.98, 12]
  [1458, 8444.34, 12]
*/


-- Write your SQL solution below:

SELECT user_id,
       SUM(total_amount) AS lifetime_spend,
       COUNT(*) AS tx_count
FROM transactions
GROUP BY user_id
HAVING SUM(total_amount) > 500
ORDER BY lifetime_spend DESC
