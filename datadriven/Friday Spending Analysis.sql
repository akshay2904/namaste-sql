-- ======================================================================
-- Friday Spending Analysis
-- ======================================================================
-- Difficulty : Hard
-- Company    : IBM
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/friday_spending_analysis
-- ======================================================================

/*
For each Friday in the first 13 weeks of the year, calculate the average transaction amount. Show the week number and average amount.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['week_number', 'avg_amount']:
  [0, 1154.94]
  [1, 494.91]
  [5, 434.29499999999996]
  [10, 858.6]
  [11, 1020.24]
*/


-- Write your SQL solution below:

SELECT
    CAST(strftime('%W', transaction_date) AS INTEGER) AS week_number,
    AVG(total_amount) AS avg_amount
FROM transactions
WHERE CAST(strftime('%w', transaction_date) AS INTEGER) = 5
  AND CAST(strftime('%W', transaction_date) AS INTEGER) <= 13
  AND strftime('%m', transaction_date) IN ('01', '02', '03')
GROUP BY CAST(strftime('%W', transaction_date) AS INTEGER)
ORDER BY week_number;
