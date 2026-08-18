-- ======================================================================
-- Lines on the Map
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/regional_order_summary
-- ======================================================================

/*
The ops team is preparing a regional performance recap from the orders log, ignoring any order with no region recorded. For each region with at least five orders, show the region, its order count, and its total profit, highest total profit first.

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

Expected output ['region', 'order_count', 'total_profit']:
  ['US', 38, 31324.4]
  ['APAC', 36, 27668.88]
  ['EU', 36, 26959.64]
  ['LATAM', 36, 26911.32]
  ['MEA', 36, 26620.56]
*/


-- Write your SQL solution below:

SELECT region,
       COUNT(order_id) AS order_count,
       SUM(profit)     AS total_profit
FROM orders
WHERE region IS NOT NULL
GROUP BY region
HAVING COUNT(order_id) >= 5
ORDER BY total_profit DESC, region;
