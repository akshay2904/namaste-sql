-- ======================================================================
-- Selling Where Nobody Lives
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/regions_outside_customer_countries
-- ======================================================================

/*
Our logistics team keeps flagging orders that ship to destination markets where we have no customers on file. Using the order records, return each shipping destination (`orders.region`) that never appears as the home country of any customer (`customers.country`).

Table: customers(customer_id, first_name, last_name, country)

Table: orders(order_id, status, region, profit)

Sample data - customers ['customer_id', 'first_name', 'last_name', 'country']:
  [40089, 'Priya', 'Gupta', 'India']
  [40178, 'Luca', 'Rossi', 'Italy']
  [40267, 'Ava', 'Nguyen', 'Vietnam']
  [40356, 'Ethan', 'Johnson', 'Spain']
  [40445, 'Maria', 'Garcia', 'China']

Sample data - orders ['order_id', 'status', 'region', 'profit']:
  [10097, 'Pending', 'EU', 69.37]
  [10194, 'Cancelled', 'APAC', 88.74]
  [10291, 'Shipped', 'LATAM', 108.11]
  [10388, 'Processing', 'MEA', 127.48]
  [10485, 'Returned', 'US', 146.85]

Expected output ['region']:
  ['APAC']
  ['EU']
  ['LATAM']
  ['MEA']
  ['US']
*/


-- Write your SQL solution below:

SELECT DISTINCT region
FROM orders
WHERE region NOT IN (
    SELECT country
    FROM customers
    WHERE country IS NOT NULL
)
ORDER BY region;
