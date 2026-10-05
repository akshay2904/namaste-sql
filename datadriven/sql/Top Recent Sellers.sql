-- ======================================================================
-- Top Recent Sellers
-- ======================================================================
-- Difficulty : Easy
-- Company    : Vanguard
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_recent_sellers
-- ======================================================================

/*
The marketplace homepage needs a trending widget. Pull the 3 products with the highest total sales over the last 30 days. Return the product_id and total sales amount, highest first.

Table: transactions(transaction_id, product_id, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['product_id', 'total_sales']:
  [5607, 1289.64]
  [5019, 1128]
  [4431, 966.36]
*/


-- Write your SQL solution below:

SELECT product_id, SUM(total_amount) AS total_sales
FROM transactions
WHERE DATE(transaction_date) >= DATE('2026-12-28', '-30 days')
GROUP BY product_id
ORDER BY total_sales DESC, product_id ASC
LIMIT 3;
