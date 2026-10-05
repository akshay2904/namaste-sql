-- ======================================================================
-- The Address That Changed
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/slowly_changing_dimension_type_2
-- ======================================================================

/*
We maintain a slowly changing dimension (Type 2) for customer addresses. Each customer_id can appear multiple times, once per address change. The current record is the one where last_name is NULL. Find each customer's current country and how many times they have moved (total records minus 1). Show customer_id, first_name, current country, and move count.

Table: customers(customer_id, first_name, last_name, country)

Sample data - customers ['customer_id', 'first_name', 'last_name', 'country']:
  [40089, 'Priya', 'Gupta', 'India']
  [40178, 'Luca', 'Rossi', 'Italy']
  [40267, 'Ava', 'Nguyen', 'Vietnam']
  [40356, 'Ethan', 'Johnson', 'Spain']
  [40445, 'Maria', 'Garcia', 'China']

Expected output ['customer_id', 'first_name', 'current_city', 'move_count']:
  [40445, 'Maria', 'China', 1]
  [40445, 'Maria', 'Sweden', 1]
  [41068, 'Oliver', 'Sweden', 1]
  [41068, 'Oliver', 'Bulgaria', 1]
  [42047, 'Harper', 'Switzerland', 1]
*/


-- Write your SQL solution below:

SELECT c.customer_id, c.first_name, c.country AS current_city, versions.move_count
FROM customers c
JOIN (SELECT customer_id, COUNT(*) - 1 AS move_count FROM customers GROUP BY customer_id) versions ON c.customer_id = versions.customer_id
WHERE versions.move_count > 0
ORDER BY c.customer_id
