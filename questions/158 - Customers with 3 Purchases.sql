-- ======================================================================
-- 158 - Customers with 3 Purchases
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/158-customers-with-3-purchases
-- ======================================================================

/*
Find users who have made exactly three purchases, such that:

1. Their second purchase occurred within 7 days of the first, 
2. Their third purchase occurred at least 30 days after the second, and
3. There is no more purchase after that

 

Return all user_ids that match the above pattern along with their first_order_date, second_order_date, and third_order_date.

 
Table: orders
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| order_id    | INT      |
| user_id     | INT      | 
| order_date  | DATE     |
+-------------+----------+
*/


-- Write your SQL solution below:

```sql
WITH ranked_orders AS (
  -- Rank orders by user and date to identify 1st, 2nd, 3rd purchases
  SELECT 
    user_id,
    order_date,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date) AS purchase_num
  FROM orders
),
user_purchase_counts AS (
  -- Count total purchases per user to ensure exactly 3
  SELECT 
    user_id,
    COUNT(*) AS total_purchases
  FROM orders
  GROUP BY user_id
  HAVING COUNT(*) = 3
),
purchase_dates AS (
  -- Get 1st, 2nd, 3rd purchase dates for users with exactly 3 purchases
  SELECT 
    ro.user_id,
    MAX(CASE WHEN ro.purchase_num = 1 THEN ro.order_date END) AS first_order_date,
    MAX(CASE WHEN ro.purchase_num = 2 THEN ro.order_date END) AS second_order_date,
    MAX(CASE WHEN ro.purchase_num = 3 THEN ro.order_date END) AS third_order_date
  FROM ranked_orders ro
  INNER JOIN user_purchase_counts upc ON ro.user_id = upc.user_id
  GROUP BY ro.user_id
)
SELECT 
  user_id,
  first_order_date,
  second_order_date,
  third_order_date
FROM purchase_dates
WHERE 
  -- Second purchase within 7 days of first
  (second_order_date - first_order_date) <= 7
  -- Third purchase at least 30 days after second
  AND (third_order_date - second_order_date) >= 30
ORDER BY user_id;
```
