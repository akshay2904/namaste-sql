-- ======================================================================
-- The Weight of Everything Before
-- ======================================================================
-- Difficulty : Medium
-- Company    : Databricks
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the-weight-of-everything-before
-- ======================================================================

/*
The lifecycle analytics team is studying how each customer's spend accumulates over their lifetime on the platform, because lifetime-value models depend on seeing the full trajectory of a buyer rather than a single snapshot. For every purchase a customer has ever made, they want to see that buyer's cumulative spend as it stood at the moment of that purchase, with each customer's history walked forward from their earliest transaction to their most recent. Produce one row per purchase showing the customer, the date of that purchase, and the total amount the customer had spent up to and including that point, laid out customer by customer and earliest to latest within each.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'transaction_date', 'running_total']:
  [100, '2026-01-05', 818.19]
  [100, '2026-03-16', 1030.23]
  [100, '2026-03-20', 2050.4700000000003]
  [100, '2026-04-16', 2262.51]
  [100, '2026-04-20', 3282.75]
*/


-- Write your SQL solution below:

SELECT user_id, transaction_date, SUM(total_amount) OVER (PARTITION BY user_id ORDER BY transaction_date) AS running_total FROM transactions ORDER BY user_id, transaction_date;
