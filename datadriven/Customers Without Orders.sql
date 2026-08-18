-- ======================================================================
-- Customers Without Orders
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/customers_without_orders
-- ======================================================================

/*
The customers table and the transactions table are linked by customer id: the customer_id column in customers corresponds to the user_id column in transactions. Count how many customers have never placed a transaction, and return that as a single integer.

Table: customers(customer_id, first_name, last_name, country)

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - customers ['customer_id', 'first_name', 'last_name', 'country']:
  [40089, 'Priya', 'Gupta', 'India']
  [40178, 'Luca', 'Rossi', 'Italy']
  [40267, 'Ava', 'Nguyen', 'Vietnam']
  [40356, 'Ethan', 'Johnson', 'Spain']
  [40445, 'Maria', 'Garcia', 'China']

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['no_order_count']:
  [200]
*/


-- Write your SQL solution below:

WITH ordering_customers AS (
    SELECT DISTINCT c.customer_id
    FROM customers c
    INNER JOIN transactions t ON c.customer_id = t.user_id
)
SELECT COUNT(*) AS no_order_count
FROM customers c
LEFT JOIN ordering_customers oc ON c.customer_id = oc.customer_id
WHERE oc.customer_id IS NULL
