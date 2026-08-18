-- ======================================================================
-- Completion Rate
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/completion_rate
-- ======================================================================

/*
Operations wants to compare how cleanly each region closes out orders. For each region, compute the percentage of orders whose status is 'Completed', skipping rows where region is NULL. Return the region and that completion percentage.

Table: orders(order_id, status, region, profit)

Sample data - orders ['order_id', 'status', 'region', 'profit']:
  [10097, 'Pending', 'EU', 69.37]
  [10194, 'Cancelled', 'APAC', 88.74]
  [10291, 'Shipped', 'LATAM', 108.11]
  [10388, 'Processing', 'MEA', 127.48]
  [10485, 'Returned', 'US', 146.85]

Expected output ['region', 'completion_pct']:
  ['APAC', 11.11]
  ['EU', 11.11]
  ['LATAM', 16.67]
  ['MEA', 16.67]
  ['US', 10.53]
*/


-- Write your SQL solution below:

SELECT region,
       ROUND(100.0 * SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) / COUNT(*), 2) AS completion_pct
FROM orders
WHERE region IS NOT NULL
GROUP BY region
ORDER BY region
