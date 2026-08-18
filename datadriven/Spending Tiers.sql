-- ======================================================================
-- Spending Tiers
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/spending_tiers
-- ======================================================================

/*
The loyalty program wants to bucket every customer into a spending tier. Compute each user's total transaction spending and label them 'high' if the total is above 500, 'medium' if it is between 200 and 500 inclusive, and 'low' if it is below 200. Return the user_id and that tier label.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', "CASE WHEN total > 500 THEN 'high' WHEN total >= 200 THEN 'medium' ELSE 'low' END"]:
  [100, 'high']
  [197, 'high']
  [294, 'high']
  [391, 'high']
  [488, 'high']
*/


-- Write your SQL solution below:

WITH totals AS (
    SELECT user_id, SUM(total_amount) AS total
    FROM transactions
    GROUP BY user_id
)
SELECT user_id, CASE WHEN total > 500 THEN 'high' WHEN total >= 200 THEN 'medium' ELSE 'low' END
FROM totals
