-- ======================================================================
-- Monthly Category Totals
-- ======================================================================
-- Difficulty : Easy
-- Company    : Visa
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/monthly_category_totals
-- ======================================================================

/*
Ahead of the holiday planning cycle, the merchandising team needs to see how each product category's revenue shifts month to month. Show the total transaction amount for each category-month combination, ordered by category then month.

Table: transactions(transaction_id, product_id, total_amount, transaction_date)

Table: products(product_id, category)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Expected output ['category', 'month', 'total_revenue']:
  ['Automotive', '2023-01', 1824.96]
  ['Automotive', '2023-03', 1555.5600000000002]
  ['Automotive', '2023-05', 238.98]
  ['Automotive', '2023-07', 1016.76]
  ['Automotive', '2023-09', 777.78]
*/


-- Write your SQL solution below:

SELECT p.category,
    STRFTIME('%Y-%m', t.transaction_date) AS month,
    SUM(t.total_amount) AS total_revenue
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.category, STRFTIME('%Y-%m', t.transaction_date)
ORDER BY p.category, month
