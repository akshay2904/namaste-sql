-- ======================================================================
-- Above Category Average
-- ======================================================================
-- Difficulty : Easy
-- Company    : Merilytics
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/above_category_average
-- ======================================================================

/*
The merchandising team wants to identify outperforming products ahead of the quarterly review. Find every product whose average transaction amount runs higher than the overall average transaction amount within its own category. Return the product name, its average transaction amount, and the category's average transaction amount.

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

Expected output ['product_name', 'product_avg', 'category_avg']:
  ['Basic Device 51X', 696.96, 681.9933333333333]
  ['Deluxe Bundle 52X', 710.43, 680.4966666666667]
  ['Pro Unit 53X', 723.9, 679]
  ['Ultra Tool 54X', 737.37, 677.5033333333333]
  ['Classic System 56X', 764.31, 674.51]
*/


-- Write your SQL solution below:

WITH product_avg AS (
    SELECT p.product_id,
           p.product_name,
           p.category,
           AVG(t.total_amount) AS product_avg
    FROM products p
    JOIN transactions t ON t.product_id = p.product_id
    GROUP BY p.product_id, p.product_name, p.category
),
category_avg AS (
    SELECT p.category,
           AVG(t.total_amount) AS cat_avg
    FROM products p
    JOIN transactions t ON t.product_id = p.product_id
    GROUP BY p.category
)
SELECT pa.product_name,
       pa.product_avg,
       ca.cat_avg AS category_avg
FROM product_avg pa
JOIN category_avg ca ON ca.category = pa.category
WHERE pa.product_avg > ca.cat_avg
