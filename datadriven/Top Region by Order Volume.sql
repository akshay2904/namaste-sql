-- ======================================================================
-- Top Region by Order Volume
-- ======================================================================
-- Difficulty : Medium
-- Company    : Forbes
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_region_by_order_volume
-- ======================================================================

/*
Which single region generates the most orders? Return the region and its order count.

Table: orders(order_id, status, region, profit)

Sample data - orders ['order_id', 'status', 'region', 'profit']:
  [10097, 'Pending', 'EU', 69.37]
  [10194, 'Cancelled', 'APAC', 88.74]
  [10291, 'Shipped', 'LATAM', 108.11]
  [10388, 'Processing', 'MEA', 127.48]
  [10485, 'Returned', 'US', 146.85]

Expected output ['region', 'order_count']:
  ['US', 38]
*/


-- Write your SQL solution below:

SELECT region, COUNT(*) AS order_count
FROM orders
WHERE region IS NOT NULL
GROUP BY region
ORDER BY order_count DESC, region ASC
LIMIT 1;
