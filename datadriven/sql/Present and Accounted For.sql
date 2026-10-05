-- ======================================================================
-- Present and Accounted For
-- ======================================================================
-- Difficulty : Easy
-- Company    : DoorDash
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/category_specific_product_volume
-- ======================================================================

/*
The merchandising team wants a per-product read on how much sales volume comes specifically from the 'Electronics' category. For every product, show the total transaction amount tied to Electronics, biggest first, and keep products that have never sold under Electronics in the list with a zero.

Table: products(product_id, product_name, category)

Table: transactions(transaction_id, product_id, total_amount)

Sample data - products ['product_id', 'product_name', 'category', 'price', 'rating', 'in_stock']:
  [1001, 'Basic Device 1X', 'Books', 17.52, 2.7, 1]
  [1050, 'Deluxe Bundle 2X', 'Clothing', 25.05, 4.4, 1]
  [1099, 'Pro Unit 3X', 'Home & Kitchen', 32.58, 2.1, 1]
  [1148, 'Ultra Tool 4X', 'Sports', 40.11, 3.8, 1]
  [1197, 'Essential Set 5X', 'Toys', 47.64, 1.5, 1]

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['product_name', 'electronics_total']:
  ['Premium Widget 100X', 2713.98]
  ['Premium Widget 90X', 2444.58]
  ['Premium Widget 80X', 2175.18]
  ['Premium Widget 70X', 1905.78]
  ['Premium Widget 60X', 1636.38]
*/


-- Write your SQL solution below:

SELECT p.product_name,
       COALESCE(SUM(CASE WHEN p.category = 'Electronics' THEN t.total_amount END), 0) AS electronics_total
FROM products p
LEFT JOIN transactions t ON p.product_id = t.product_id
GROUP BY p.product_id, p.product_name
ORDER BY electronics_total DESC, p.product_name
