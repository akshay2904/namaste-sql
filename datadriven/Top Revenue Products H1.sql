-- ======================================================================
-- Top Revenue Products H1
-- ======================================================================
-- Difficulty : Medium
-- Company    : General Assembly
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_revenue_products_h1
-- ======================================================================

/*
The revenue team needs the top 5 products by total revenue for January through June. Show each product's ID and total revenue. If products are tied at the cutoff, include all of them.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['product_id', 'total_revenue']:
  [None, 8071.11]
  [5852, 2713.98]
  [5754, 2660.1]
  [5705, 2633.16]
  [5313, 2417.64]
*/


-- Write your SQL solution below:

SELECT product_id, total_revenue
FROM (
  SELECT product_id,
         SUM(total_amount) AS total_revenue,
         DENSE_RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rnk
  FROM transactions
  WHERE CAST(strftime('%m', transaction_date) AS INTEGER) BETWEEN 1 AND 6
  GROUP BY product_id
) ranked
WHERE rnk <= 5
ORDER BY total_revenue DESC
