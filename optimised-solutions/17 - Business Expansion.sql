-- ======================================================================
-- 17 - Business Expansion
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/17-business-expansion
-- ======================================================================

/*
Amazon is expanding their pharmacy business to new cities every year. You are given a table of business operations where you have information about cities where Amazon is doing operations along with the business date information.

Write a SQL to find year wise number of new cities added to the business, display the output in increasing order of year.

 
Table: business_operations
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| business_date | date      |
| city_id       | int       |
+---------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH city_first_year AS (
    -- Find the first year each city appeared in the business
    SELECT
        city_id,
        MIN(EXTRACT(YEAR FROM business_date)) AS first_year
    FROM business_operations
    GROUP BY city_id
)
SELECT
    first_year AS year,
    COUNT(city_id) AS new_cities_added
FROM city_first_year
GROUP BY first_year
ORDER BY first_year ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    EXTRACT(YEAR FROM business_date) AS year,
    COUNT(DISTINCT city_id) AS new_cities_added
FROM business_operations bo_outer
WHERE EXTRACT(YEAR FROM bo_outer.business_date) = (
    -- Keep only records where the year matches the city's first ever year
    SELECT MIN(EXTRACT(YEAR FROM bo_inner.business_date))
    FROM business_operations bo_inner
    WHERE bo_inner.city_id = bo_outer.city_id
)
GROUP BY EXTRACT(YEAR FROM business_date)
ORDER BY year ASC;
