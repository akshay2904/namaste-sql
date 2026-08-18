-- ======================================================================
-- Roll Call
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/full_customer_order_list
-- ======================================================================

/*
Support needs a clean roster of everyone in the customer table. List each customer's first name, last name, and country, sorted alphabetically by first name and then last name.

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

Expected output ['first_name', 'last_name', 'country']:
  ['Aiden', 'Kim', 'United States']
  ['Aiden', 'Kim', 'Bangladesh']
  ['Aiden', 'Smith', 'Bangladesh']
  ['Aiden', 'Smith', 'France']
  ['Alexander', 'Brown', 'Italy']
*/


-- Write your SQL solution below:

SELECT first_name, last_name, country
FROM customers
ORDER BY first_name, last_name;
