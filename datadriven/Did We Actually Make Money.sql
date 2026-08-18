-- ======================================================================
-- Did We Actually Make Money?
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/fulfillable_order_percentage
-- ======================================================================

/*
Finance is reviewing order economics, and cancelled orders don't count since those deals never closed. Across the remaining orders, total the profit for each region and list the regions from the biggest earner down.

Table: orders(order_id, status, region, profit)

Table: customers(customer_id, first_name, last_name, country)

Sample data - orders ['order_id', 'status', 'region', 'profit']:
  [10097, 'Pending', 'EU', 69.37]
  [10194, 'Cancelled', 'APAC', 88.74]
  [10291, 'Shipped', 'LATAM', 108.11]
  [10388, 'Processing', 'MEA', 127.48]
  [10485, 'Returned', 'US', 146.85]

Sample data - customers ['customer_id', 'first_name', 'last_name', 'country']:
  [40089, 'Priya', 'Gupta', 'India']
  [40178, 'Luca', 'Rossi', 'Italy']
  [40267, 'Ava', 'Nguyen', 'Vietnam']
  [40356, 'Ethan', 'Johnson', 'Spain']
  [40445, 'Maria', 'Garcia', 'China']

Expected output ['region', 'total_profit']:
  ['US', 24470.1]
  ['MEA', 22400.58]
  ['APAC', 21954.26]
  ['EU', 20552.98]
  ['LATAM', 19136.24]
*/


-- Write your SQL solution below:

SELECT
    region,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders
WHERE status <> 'Cancelled'
GROUP BY region
ORDER BY total_profit DESC;
