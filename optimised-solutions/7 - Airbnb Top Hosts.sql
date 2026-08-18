-- ======================================================================
-- 7 - Airbnb Top Hosts
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Airbnb
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/7-airbnb-top-hosts
-- ======================================================================

/*
Suppose you are a data analyst working for a travel company that offers vacation rentals similar to Airbnb. Your company wants to identify the top hosts with the highest average ratings for their listings. This information will be used to recognize exceptional hosts and potentially offer them incentives to continue providing outstanding service.

 

Your task is to write an SQL query to find the top 2 hosts with the highest average ratings for their listings. However, you should only consider hosts who have at least 2 listings, as hosts with fewer listings may not be representative.

Display output in descending order of average ratings and round the average ratings to 2 decimal places.

 
Table: listings
+----------------+---------------+
| COLUMN_NAME    | DATA_TYPE     |
+----------------+---------------+
| host_id        | int           |
| listing_id     | int           |
| minimum_nights | int           |
| neighborhood   | varchar(20)   |
| price          | decimal(10,2) |
| room_type      | varchar(20)   |
+----------------+---------------+Table: reviews
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| listing_id  | int       |
| rating      | int       |
| review_date | date      |
| review_id   | int       |
+-------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH host_stats AS (
    SELECT
        l.host_id,
        ROUND(AVG(r.rating), 2) AS avg_rating,
        COUNT(DISTINCT l.listing_id) AS listing_count
    FROM listings l
    JOIN reviews r ON l.listing_id = r.listing_id
    GROUP BY l.host_id
    HAVING COUNT(DISTINCT l.listing_id) >= 2
),
ranked AS (
    SELECT
        host_id,
        avg_rating,
        listing_count,
        RANK() OVER (ORDER BY avg_rating DESC) AS rnk
    FROM host_stats
)
SELECT
    host_id,
    avg_rating,
    listing_count
FROM ranked
WHERE rnk <= 2
ORDER BY avg_rating DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    host_id,
    avg_rating,
    listing_count
FROM (
    SELECT
        l.host_id,
        ROUND(AVG(r.rating), 2) AS avg_rating,
        COUNT(DISTINCT l.listing_id) AS listing_count
    FROM listings l
    JOIN reviews r ON l.listing_id = r.listing_id
    GROUP BY l.host_id
    HAVING COUNT(DISTINCT l.listing_id) >= 2
) AS host_averages
ORDER BY avg_rating DESC
LIMIT 2;
