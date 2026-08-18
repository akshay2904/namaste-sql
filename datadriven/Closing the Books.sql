-- ======================================================================
-- Closing the Books
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/japan_revenue_for_april
-- ======================================================================

/*
Finance is closing April 2026 and needs a single revenue figure for the month. Each transaction's revenue is its `quantity` multiplied by the `total_amount` line total, so roll that up across every April 2026 transaction into one number.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Table: customers(customer_id, first_name, last_name, country)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Sample data - customers ['customer_id', 'first_name', 'last_name', 'country']:
  [40089, 'Priya', 'Gupta', 'India']
  [40178, 'Luca', 'Rossi', 'Italy']
  [40267, 'Ava', 'Nguyen', 'Vietnam']
  [40356, 'Ethan', 'Johnson', 'Spain']
  [40445, 'Maria', 'Garcia', 'China']

Expected output ['total_revenue']:
  [22228.86]
*/


-- Write your SQL solution below:

SELECT SUM(t.quantity * t.total_amount) AS total_revenue
FROM transactions t
WHERE strftime('%Y-%m', t.transaction_date) = '2026-04'
