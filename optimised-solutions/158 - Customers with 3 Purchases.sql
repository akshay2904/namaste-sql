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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_orders AS (
    SELECT
        user_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY order_date) AS rn,
        COUNT(*) OVER (PARTITION BY user_id) AS total_orders
    FROM orders
),
pivoted AS (
    SELECT
        user_id,
        MAX(CASE WHEN rn = 1 THEN order_date END) AS first_order_date,
        MAX(CASE WHEN rn = 2 THEN order_date END) AS second_order_date,
        MAX(CASE WHEN rn = 3 THEN order_date END) AS third_order_date
    FROM ranked_orders
    WHERE total_orders = 3   -- exactly three purchases
    GROUP BY user_id
)
SELECT
    user_id,
    first_order_date,
    second_order_date,
    third_order_date
FROM pivoted
WHERE
    -- 2nd purchase within 7 days of 1st
    second_order_date - first_order_date <= 7
    -- 3rd purchase at least 30 days after 2nd
    AND third_order_date - second_order_date >= 30;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Step 1: keep only users with exactly 3 orders
WITH exact_three AS (
    SELECT user_id
    FROM orders
    GROUP BY user_id
    HAVING COUNT(*) = 3
),
-- Step 2: tag each order as 1st / 2nd / 3rd by joining min dates
first_orders AS (
    SELECT o.user_id, MIN(o.order_date) AS first_order_date
    FROM orders o
    INNER JOIN exact_three e ON o.user_id = e.user_id
    GROUP BY o.user_id
),
second_orders AS (
    SELECT o.user_id, MIN(o.order_date) AS second_order_date
    FROM orders o
    INNER JOIN first_orders f ON o.user_id = f.user_id
    WHERE o.order_date > f.first_order_date   -- strictly after first
    GROUP BY o.user_id
),
third_orders AS (
    SELECT o.user_id, MIN(o.order_date) AS third_order_date
    FROM orders o
    INNER JOIN second_orders s ON o.user_id = s.user_id
    WHERE o.order_date > s.second_order_date  -- strictly after second
    GROUP BY o.user_id
)
SELECT
    f.user_id,
    f.first_order_date,
    s.second_order_date,
    t.third_order_date
FROM first_orders  f
JOIN second_orders s ON f.user_id = s.user_id
JOIN third_orders  t ON f.user_id = t.user_id
WHERE
    -- 2nd purchase within 7 days of 1st
    s.second_order_date - f.first_order_date <= 7
    -- 3rd purchase at least 30 days after 2nd
    AND t.third_order_date - s.second_order_date >= 30;
