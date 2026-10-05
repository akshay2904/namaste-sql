-- ======================================================================
-- The Provinces
-- ======================================================================
-- Difficulty : Easy
-- Company    : Snap
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the-provinces-regional-earnings
-- ======================================================================

/*
We run a retail operation split into regional zones, with the US as our home base and main branch. Find the three highest earning zones outside the home region, biggest earners first.

Table: orders(order_id, status, region, profit)

Sample data - orders ['order_id', 'status', 'region', 'profit']:
  [10097, 'Pending', 'EU', 69.37]
  [10194, 'Cancelled', 'APAC', 88.74]
  [10291, 'Shipped', 'LATAM', 108.11]
  [10388, 'Processing', 'MEA', 127.48]
  [10485, 'Returned', 'US', 146.85]

Expected output ['region', 'total_profit']:
  ['APAC', 27668.88]
  ['EU', 26959.64]
  ['LATAM', 26911.32]
*/


-- Write your SQL solution below:

SELECT region,
       SUM(profit) AS total_profit
FROM orders
WHERE region <> 'US'
GROUP BY region
ORDER BY total_profit DESC
LIMIT 3
