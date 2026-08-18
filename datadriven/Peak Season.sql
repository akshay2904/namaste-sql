-- ======================================================================
-- Peak Season
-- ======================================================================
-- Difficulty : Medium
-- Company    : Lyft
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/most_profitable_region_month
-- ======================================================================

/*
The finance team wants the single most profitable region and month pairing from 2026. Match each order to the transactions sharing the same ID modulo 100, total the order profit within each region and transaction month, and return the one pairing with the highest total.

Table: orders(order_id, status, region, profit)

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - orders ['order_id', 'status', 'region', 'profit']:
  [10097, 'Pending', 'EU', 69.37]
  [10194, 'Cancelled', 'APAC', 88.74]
  [10291, 'Shipped', 'LATAM', 108.11]
  [10388, 'Processing', 'MEA', 127.48]
  [10485, 'Returned', 'US', 146.85]

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['region', 'txn_month', 'total_profit']:
  ['US', '05', 8585]
*/


-- Write your SQL solution below:

SELECT
    o.region,
    strftime('%m', t.transaction_date) AS txn_month,
    SUM(o.profit) AS total_profit
FROM orders o
INNER JOIN transactions t
    ON (o.order_id % 100) = (t.transaction_id % 100)
GROUP BY o.region, strftime('%m', t.transaction_date)
ORDER BY total_profit DESC
LIMIT 1
