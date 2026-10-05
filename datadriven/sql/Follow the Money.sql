-- ======================================================================
-- Follow the Money
-- ======================================================================
-- Difficulty : Easy
-- Company    : Truist
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/follow-the-money-yearly-account-volume
-- ======================================================================

/*
The account analytics team is closing out this year's books and wants a read on who is moving the most money through the platform. Add up each account's transaction amounts for 2026 and list them from the biggest total down.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'total_spent']:
  [1070, 10511.76]
  [585, 9568.86]
  [100, 8605.98]
  [973, 5161.59]
  [876, 5067.3]
*/


-- Write your SQL solution below:

SELECT user_id,
       SUM(total_amount) AS total_spent
FROM transactions
WHERE strftime('%Y', transaction_date) = '2026'
GROUP BY user_id
ORDER BY total_spent DESC, user_id
