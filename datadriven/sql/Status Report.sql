-- ======================================================================
-- Status Report
-- ======================================================================
-- Difficulty : Easy
-- Company    : Tata Consultancy Services
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/status_report
-- ======================================================================

/*
The operations team suspects that too many orders are sitting in non-terminal states. For each order status, they want to see the number of orders and the average profit. Skip any orders that have no status on record. Only include statuses that have at least five orders behind them, and list them from most orders to fewest.

Table: orders(order_id, status, region, profit)

Sample data - orders ['order_id', 'status', 'region', 'profit']:
  [10097, 'Pending', 'EU', 69.37]
  [10194, 'Cancelled', 'APAC', 88.74]
  [10291, 'Shipped', 'LATAM', 108.11]
  [10388, 'Processing', 'MEA', 127.48]
  [10485, 'Returned', 'US', 146.85]

Expected output ['status', 'order_count', 'avg_profit']:
  ['Pending', 28, 665.975]
  ['Cancelled', 28, 713.3514285714285]
  ['Shipped', 26, 792.5230769230768]
  ['Returned', 26, 782.4776923076922]
  ['Processing', 26, 798.2276923076922]
*/


-- Write your SQL solution below:

SELECT status, COUNT(*) AS order_count, AVG(profit) AS avg_profit
FROM orders
WHERE status IS NOT NULL
GROUP BY status
HAVING COUNT(*) >= 5
ORDER BY order_count DESC
