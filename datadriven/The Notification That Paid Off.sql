-- ======================================================================
-- The Notification That Paid Off
-- ======================================================================
-- Difficulty : Hard
-- Company    : ActiveCampaign
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/campaign_conversion_count
-- ======================================================================

/*
We ran a push notification campaign starting one day after each user's first transaction. How many users went on to buy new products they hadn't purchased on their first day? Users who only re-bought the same items or never made additional purchases don't count. Return a single count.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_count']:
  [15]
*/


-- Write your SQL solution below:

WITH first_txn AS (
  SELECT user_id, MIN(transaction_date) AS first_date
  FROM transactions
  GROUP BY user_id
),
first_day_products AS (
  SELECT DISTINCT t.user_id, t.product_id
  FROM transactions t
  INNER JOIN first_txn ft
    ON t.user_id = ft.user_id
   AND t.transaction_date = ft.first_date
),
post_campaign AS (
  SELECT DISTINCT t.user_id, t.product_id
  FROM transactions t
  INNER JOIN first_txn ft
    ON t.user_id = ft.user_id
  WHERE julianday(t.transaction_date) > julianday(ft.first_date) + 1
)
SELECT COUNT(DISTINCT pc.user_id) AS user_count
FROM post_campaign pc
WHERE pc.product_id NOT IN (
  SELECT product_id
  FROM first_day_products
  WHERE user_id = pc.user_id
);
