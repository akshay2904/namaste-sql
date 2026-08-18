-- ======================================================================
-- Profit Tiers
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/profit_tiers
-- ======================================================================

/*
The CFO wants orders bucketed by profitability for the operating review. Label each order in orders as 'high' when profit exceeds 100, 'moderate' when profit is between 0 and 100 inclusive, and 'negative' when profit is below 0, then count orders per tier. Return the tier label and its order count.

Table: orders(order_id, status, region, profit)

Sample data - orders ['order_id', 'status', 'region', 'profit']:
  [10097, 'Pending', 'EU', 69.37]
  [10194, 'Cancelled', 'APAC', 88.74]
  [10291, 'Shipped', 'LATAM', 108.11]
  [10388, 'Processing', 'MEA', 127.48]
  [10485, 'Returned', 'US', 146.85]

Expected output ['tier', 'order_count']:
  ['high', 178]
  ['moderate', 12]
  ['negative', 10]
*/


-- Write your SQL solution below:

SELECT
    CASE
        WHEN profit > 100 THEN 'high'
        WHEN profit >= 0 THEN 'moderate'
        ELSE 'negative'
    END AS tier,
    COUNT(*) AS order_count
FROM orders
GROUP BY tier
