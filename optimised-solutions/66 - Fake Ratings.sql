-- ======================================================================
-- 66 - Fake Ratings
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/66-fake-ratings
-- ======================================================================

/*
As an analyst at Amazon, you are responsible for ensuring the integrity of product ratings on the platform. Fake ratings can distort the perception of product quality and mislead customers. To maintain trust and reliability, you need to identify potential fake ratings that deviate significantly from the average ratings for each product.
Write an SQL query to identify the single rating that is farthest (in absolute value) from the average rating value for each product, display rating details in ascending order of rating id.

 
Table : product_ratings
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| rating_id   | int          |
| product_id  | int          |
| user_id     | int          |
| rating      | decimal(2,1) |
+-------------+--------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH stats AS (
    SELECT
        rating_id,
        product_id,
        user_id,
        rating,
        AVG(rating) OVER (PARTITION BY product_id) AS avg_rating,
        ABS(rating - AVG(rating) OVER (PARTITION BY product_id)) AS deviation,
        -- Rank by deviation descending within each product; pick the farthest one
        RANK() OVER (
            PARTITION BY product_id
            ORDER BY ABS(rating - AVG(rating) OVER (PARTITION BY product_id)) DESC
        ) AS rnk
    FROM product_ratings
)
SELECT
    rating_id,
    product_id,
    user_id,
    rating,
    ROUND(avg_rating, 2) AS avg_rating,
    ROUND(deviation, 2)  AS deviation
FROM stats
WHERE rnk = 1
ORDER BY rating_id ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    pr.rating_id,
    pr.product_id,
    pr.user_id,
    pr.rating,
    ROUND(pa.avg_rating, 2) AS avg_rating,
    ROUND(ABS(pr.rating - pa.avg_rating), 2) AS deviation
FROM product_ratings pr
-- Join with per-product average
JOIN (
    SELECT
        product_id,
        AVG(rating) AS avg_rating
    FROM product_ratings
    GROUP BY product_id
) pa ON pr.product_id = pa.product_id
-- Keep only the row(s) with the maximum deviation per product
WHERE ABS(pr.rating - pa.avg_rating) = (
    SELECT MAX(ABS(inner_pr.rating - inner_avg.avg_rating))
    FROM product_ratings inner_pr
    JOIN (
        SELECT product_id, AVG(rating) AS avg_rating
        FROM product_ratings
        GROUP BY product_id
    ) inner_avg ON inner_pr.product_id = inner_avg.product_id
    WHERE inner_pr.product_id = pr.product_id
)
ORDER BY pr.rating_id ASC;
