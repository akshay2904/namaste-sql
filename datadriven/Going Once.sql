-- ======================================================================
-- Going Once
-- ======================================================================
-- Difficulty : Medium
-- Company    : TikTok
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/auction_lot_summary
-- ======================================================================

/*
The product team is building a sales leaderboard for in-stock items. For each product currently in stock, show how many transactions reference it, the highest transaction amount, and which user placed the top transaction. Products with no transactions should still appear, showing a count of zero and no top user.

Table: products(product_id, product_name, in_stock)

Table: transactions(transaction_id, product_id, total_amount, user_id)

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

Expected output ['product_id', 'product_name', 'bid_count', 'highest_bid', 'winner']:
  [1001, 'Basic Device 1X', 2, 23.46, 197]
  [1050, 'Deluxe Bundle 2X', 2, 36.93, 294]
  [1099, 'Pro Unit 3X', 2, 50.4, 391]
  [1491, 'Basic Device 11X', 0, None, None]
  [2030, 'Deluxe Bundle 22X', 0, None, None]
*/


-- Write your SQL solution below:

WITH ranked_bids AS (
    SELECT
        product_id,
        user_id,
        ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY total_amount DESC, transaction_id) AS rn
    FROM transactions
)
SELECT
    p.product_id,
    p.product_name,
    COUNT(t.transaction_id) AS bid_count,
    MAX(t.total_amount) AS highest_bid,
    rb.user_id AS winner
FROM products p
LEFT JOIN transactions t ON p.product_id = t.product_id
LEFT JOIN ranked_bids rb ON p.product_id = rb.product_id AND rb.rn = 1
WHERE p.in_stock = 1
GROUP BY p.product_id, p.product_name, rb.user_id
ORDER BY p.product_id;
