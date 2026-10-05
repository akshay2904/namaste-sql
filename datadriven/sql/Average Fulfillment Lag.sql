-- ======================================================================
-- Average Fulfillment Lag
-- ======================================================================
-- Difficulty : Medium
-- Company    : Airbnb
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_fulfillment_lag
-- ======================================================================

/*
The operations team is measuring fulfillment lag across the customer base. For each user, compute the average number of days between their transaction dates and today, only considering transactions with a positive amount. Present users from the longest average lag to the shortest.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'avg_days']:
  [197, 949.7142857142857]
  [1167, 898.5]
  [682, 897]
  [1264, 745.6666666666666]
  [294, 735.8571428571429]
*/


-- Write your SQL solution below:

SELECT user_id, AVG(julianday(date('now')) - julianday(transaction_date)) AS avg_days FROM transactions WHERE total_amount > 0 GROUP BY user_id ORDER BY avg_days DESC
