-- ======================================================================
-- Regional Profits
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/regional_profits
-- ======================================================================

/*
Headquarters is preparing the quarterly P&L deck and needs a regional breakdown. For every region that has order data, show the total profit and the number of orders. Some orders have missing region information and should be left out. Regions should appear from highest total profit to lowest.

Table: orders(order_id, status, region, profit)

Sample data - orders ['order_id', 'status', 'region', 'profit']:
  [10097, 'Pending', 'EU', 69.37]
  [10194, 'Cancelled', 'APAC', 88.74]
  [10291, 'Shipped', 'LATAM', 108.11]
  [10388, 'Processing', 'MEA', 127.48]
  [10485, 'Returned', 'US', 146.85]

Expected output ['region', 'total_profit', 'order_count']:
  ['US', 31324.4, 38]
  ['APAC', 27668.88, 36]
  ['EU', 26959.64, 36]
  ['LATAM', 26911.32, 36]
  ['MEA', 26620.56, 36]
*/


-- Write your SQL solution below:

SELECT region, SUM(profit) AS total_profit, COUNT(*) AS order_count
FROM orders
WHERE region IS NOT NULL
GROUP BY region
ORDER BY total_profit DESC
