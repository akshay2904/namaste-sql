-- ======================================================================
-- 81 - Consistent Growth
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Google
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/81-consistent-growth
-- ======================================================================

/*
In a financial analysis project, you are tasked with identifying companies that have consistently increased their revenue by at least 25% every year. You have a table named revenue that contains information about the revenue of different companies over several years.
Your goal is to find companies whose revenue has increased by at least 25% every year consecutively. So for example If a company's revenue has increased by 25% or more for three consecutive years but not for the fourth year, it will not be considered.

Write an SQL query to retrieve the names of companies that meet the criteria mentioned above along with total lifetime revenue , display the output in ascending order of company id
Table : revenue 
+-------------+---------------+
| COLUMN_NAME | DATA_TYPE     |
+-------------+---------------+
| company_id  | int           |
| year        | int           |
| revenue     | decimal(10,2) |
+-------------+---------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH yearly_growth AS (
    SELECT
        company_id,
        year,
        revenue,
        LAG(revenue) OVER (PARTITION BY company_id ORDER BY year) AS prev_revenue
    FROM revenue
),
growth_flags AS (
    SELECT
        company_id,
        year,
        revenue,
        -- For the first year of a company, prev_revenue is NULL; treat as meeting criteria
        CASE
            WHEN prev_revenue IS NULL THEN 1
            WHEN revenue >= prev_revenue * 1.25 THEN 1
            ELSE 0
        END AS meets_criteria
    FROM yearly_growth
),
qualifying_companies AS (
    SELECT company_id
    FROM growth_flags
    GROUP BY company_id
    -- All rows must meet criteria (no year failed the 25% growth test)
    HAVING MIN(meets_criteria) = 1
      AND COUNT(*) > 1  -- Must have at least 2 years of data to show growth
)
SELECT
    r.company_id,
    SUM(r.revenue) AS total_lifetime_revenue
FROM revenue r
JOIN qualifying_companies qc ON r.company_id = qc.company_id
GROUP BY r.company_id
ORDER BY r.company_id ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    r.company_id,
    SUM(r.revenue) AS total_lifetime_revenue
FROM revenue r
WHERE r.company_id IN (
    SELECT company_id
    FROM revenue
    GROUP BY company_id
    -- Must have more than 1 year of data
    HAVING COUNT(*) > 1
)
AND r.company_id NOT IN (
    -- Find companies where ANY year failed to grow by 25% compared to prior year
    SELECT curr.company_id
    FROM revenue curr
    JOIN revenue prev
      ON curr.company_id = prev.company_id
     AND curr.year = (
         -- Get the immediately preceding year for this company
         SELECT MAX(r2.year)
         FROM revenue r2
         WHERE r2.company_id = curr.company_id
           AND r2.year < curr.year
     )
    WHERE curr.revenue < prev.revenue * 1.25
)
GROUP BY r.company_id
ORDER BY r.company_id ASC;
