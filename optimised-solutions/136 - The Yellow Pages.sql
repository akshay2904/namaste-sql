-- ======================================================================
-- 136 - The Yellow Pages
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Htc global
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/136-the-yellow-pages
-- ======================================================================

/*
To enhance the functionality of "The Yellow Pages" website, create a SQL query to generate a report of companies, including their phone numbers and ratings. The query must account for the following:

Columns in the output:

name: The company name as per below rules:
    For promoted companies:
        Format: [PROMOTED] <company_name>.
    For non-promoted companies:
        Format: <company_name>.

phone: The company phone number.

 

rating: The overall star rating of the company as per rules below:
    Promoted companies : should always have NULL as their rating.
    For non-promoted companies:
        Format: <#_stars> (<average_rating>, based on <total_reviews> reviews), where:
        <#_stars>: Rounded down average rating to the nearest whole number.
        <average_rating>: Exact average rating rounded to 1 decimal place.
        <total_reviews>: Total number of reviews across all categories for the company.

 

Rules: Non-promoted companies should only be included if their average rating is 1 star or higher.

 

Results should be sorted:
By promotion status (promoted first).
In descending order of the average rating (before rounding).
By the total number of reviews (descending).

 

Table: companies
+------------+----------+
| COLUMN_NAME| DATA_TYPE|
+------------+----------+
| id         | int      |
| name       | VARCHAR  | 
| phone      | VARCHAR  | 
| is_promoted| int      | 
+------------+----------+Table: categories
+------------+----------+
| COLUMN_NAME| DATA_TYPE|
+------------+----------+
| company_id | int      |
| name       | VARCHAR  | 
| rating     | decimal  | 
+------------+----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH company_stats AS (
    SELECT
        c.id,
        c.name,
        c.phone,
        c.is_promoted,
        AVG(cat.rating)   AS avg_rating,
        COUNT(cat.rating)  AS total_reviews
    FROM companies c
    LEFT JOIN categories cat ON cat.company_id = c.id
    GROUP BY c.id, c.name, c.phone, c.is_promoted
)
SELECT
    -- Name formatting based on promotion status
    CASE
        WHEN is_promoted = 1 THEN '[PROMOTED] ' || name
        ELSE name
    END AS name,

    phone,

    -- Rating formatting based on promotion status and rules
    CASE
        WHEN is_promoted = 1 THEN NULL
        ELSE
            FLOOR(avg_rating)::TEXT
            || ' ('
            || ROUND(avg_rating, 1)::TEXT
            || ', based on '
            || total_reviews::TEXT
            || ' reviews)'
    END AS rating

FROM company_stats
WHERE
    -- Promoted companies always included; non-promoted only if avg_rating >= 1
    is_promoted = 1
    OR avg_rating >= 1
ORDER BY
    is_promoted DESC,                    -- promoted first
    avg_rating   DESC,                   -- descending average rating (pre-rounding)
    total_reviews DESC;                  -- descending total reviews


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    -- Name formatting based on promotion status
    CASE
        WHEN co.is_promoted = 1 THEN '[PROMOTED] ' || co.name
        ELSE co.name
    END AS name,

    co.phone,

    -- Rating formatting based on promotion status and rules
    CASE
        WHEN co.is_promoted = 1 THEN NULL
        ELSE
            FLOOR(
                (SELECT AVG(cat2.rating)
                 FROM categories cat2
                 WHERE cat2.company_id = co.id)
            )::TEXT
            || ' ('
            || ROUND(
                (SELECT AVG(cat3.rating)
                 FROM categories cat3
                 WHERE cat3.company_id = co.id),
                1
               )::TEXT
            || ', based on '
            || (SELECT COUNT(cat4.rating)
                FROM categories cat4
                WHERE cat4.company_id = co.id)::TEXT
            || ' reviews)'
    END AS rating

FROM companies co
WHERE
    co.is_promoted = 1
    OR (
        -- Non-promoted: only include if avg rating >= 1
        (SELECT AVG(cat5.rating) FROM categories cat5 WHERE cat5.company_id = co.id) >= 1
    )
ORDER BY
    co.is_promoted DESC,
    (SELECT AVG(cat6.rating) FROM categories cat6 WHERE cat6.company_id = co.id) DESC,
    (SELECT COUNT(cat7.rating) FROM categories cat7 WHERE cat7.company_id = co.id) DESC;
