-- ======================================================================
-- Regional Status
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/regional_status
-- ======================================================================

/*
The operations team is diagnosing fulfillment bottlenecks across regions. For each region and order status combination that has valid data on both fields, show the number of orders. Only surface combinations that account for at least three orders, and rank the results from the most common combination to the least.

Table: orders(order_id, status, region, profit)

Sample data - orders ['order_id', 'status', 'region', 'profit']:
  [10097, 'Pending', 'EU', 69.37]
  [10194, 'Cancelled', 'APAC', 88.74]
  [10291, 'Shipped', 'LATAM', 108.11]
  [10388, 'Processing', 'MEA', 127.48]
  [10485, 'Returned', 'US', 146.85]

Expected output ['region', 'status', 'order_count']:
  ['APAC', 'Cancelled', 6]
  ['EU', 'Cancelled', 6]
  ['LATAM', 'Cancelled', 6]
  ['MEA', 'Completed', 6]
  ['US', 'Pending', 6]
*/


-- Write your SQL solution below:

SELECT
    region,
    status,
    COUNT(*) AS order_count
FROM orders
WHERE region IS NOT NULL AND status IS NOT NULL
GROUP BY region, status
HAVING COUNT(*) >= 3
ORDER BY order_count DESC, region ASC, status ASC
