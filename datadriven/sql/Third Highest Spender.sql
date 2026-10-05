-- ======================================================================
-- Third Highest Spender
-- ======================================================================
-- Difficulty : Medium
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/third_highest_spender
-- ======================================================================

/*
Find the user with the third highest total spend across all transactions. If there is a tie, include all users sharing that rank. Show the user ID, a reference country from the customers table, and total spend.

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

Expected output ['user_id', 'total_spend']:
  [876, 10134.6]
*/


-- Write your SQL solution below:

SELECT user_id, total_spend
FROM (
    SELECT
        user_id,
        SUM(total_amount) AS total_spend,
        DENSE_RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rnk
    FROM transactions
    GROUP BY user_id
) ranked
WHERE rnk = 3
