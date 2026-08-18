-- ======================================================================
-- 109 - Top 5 Single-Purchase Spendings
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/109-top-5-single-purchase-spendings
-- ======================================================================

/*
Write an SQL to retrieve the top 5 customers who have spent the most on their single purchase. Sort the result by max single purchase in descending order.

 
Table: purchase
+-------------+------------+
|COLUMN_NAME  | DATA_TYPE  |
+-------------+------------+
|customer_id  | int        |
|purchase_date| date       |
|amount       | int        |
+-------------+------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_purchases AS (
    SELECT
        customer_id,
        amount AS max_single_purchase,
        RANK() OVER (PARTITION BY customer_id ORDER BY amount DESC) AS rnk
    FROM purchase
),
customer_max AS (
    SELECT
        customer_id,
        max_single_purchase
    FROM ranked_purchases
    WHERE rnk = 1
)
SELECT
    customer_id,
    max_single_purchase
FROM customer_max
ORDER BY max_single_purchase DESC
LIMIT 5;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    customer_id,
    MAX(amount) AS max_single_purchase
FROM purchase
GROUP BY customer_id
ORDER BY max_single_purchase DESC
LIMIT 5;
