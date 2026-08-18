-- ======================================================================
-- Consistent High-Quantity Revenue
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/consistent_high_quantity_revenue
-- ======================================================================

/*
Compute total transaction revenue for each user and product pair, but only for pairs where every single transaction had a quantity of at least 2. If any transaction for that pair falls below 2, exclude the entire pair. Show user, product, and total revenue, listed by user ascending and revenue descending.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['user_id', 'product_id', 'total_revenue']:
  [197, 5411, 2471.52]
  [197, 4676, 2067.42]
  [197, 3941, 1663.32]
  [197, 3206, 1259.22]
  [197, 2471, 855.12]
*/


-- Write your SQL solution below:

SELECT
    user_id,
    product_id,
    SUM(total_amount) AS total_revenue
FROM transactions
GROUP BY user_id, product_id
HAVING MIN(quantity) >= 2
ORDER BY user_id ASC, total_revenue DESC
