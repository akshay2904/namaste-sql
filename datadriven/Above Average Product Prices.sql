-- ======================================================================
-- Above Average Product Prices
-- ======================================================================
-- Difficulty : Medium
-- Company    : Rosetta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/above_average_product_prices
-- ======================================================================

/*
The finance team defines a product's base price as the lowest transaction amount ever recorded for it. They want to flag products whose base price runs above the average base price across all products. Return the product ID and its base price.

Table: transactions(transaction_id, user_id, product_id, quantity, total_amount, transaction_date)

Sample data - transactions ['transaction_id', 'user_id', 'product_id', 'quantity', 'total_amount', 'transaction_date']:
  [1067, 197, 1001, 2, 23.46, '2026-02-02']
  [1134, 294, 1050, 3, 36.93, '2026-03-03']
  [1201, 391, 1099, 4, 50.4, '2026-04-04']
  [1268, 488, 1148, 5, 63.87, '2026-05-05']
  [1335, 585, 1197, 1, 77.34, '2026-06-06']

Expected output ['product_id', 'base_price']:
  [3402, 683.49]
  [3451, 696.96]
  [3500, 710.43]
  [3549, 723.9]
  [3598, 737.37]
*/


-- Write your SQL solution below:

SELECT
  product_id,
  MIN(total_amount) AS base_price
FROM transactions
GROUP BY product_id
HAVING MIN(total_amount) > (
  SELECT AVG(min_price)
  FROM (
    SELECT MIN(total_amount) AS min_price
    FROM transactions
    GROUP BY product_id
  )
)
