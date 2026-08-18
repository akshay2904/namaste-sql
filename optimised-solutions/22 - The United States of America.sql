-- ======================================================================
-- 22 - The United States of America
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Meta
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/22-the-united-states-of-america
-- ======================================================================

/*
In some poorly designed UI applications, there's often a lack of data input restrictions. For instance, in a free text field for the country, users might input variations such as 'USA,' 'United States of America,' or 'US.'

Suppose we have survey data from individuals in the USA about their job satisfaction, rated on a scale of 1 to 5. Write a SQL query to count the number of respondents for each rating on the scale. Additionally, include the country name in the format that occurs most frequently in that scale, display the output in ascending order of job satisfaction.

 
Table: survey 
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| country          | varchar(20) |
| job_satisfaction | int         |
| name             | varchar(10) |
+------------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH usa_data AS (
    -- Filter only USA-related entries
    SELECT 
        country,
        job_satisfaction,
        name
    FROM survey
    WHERE UPPER(country) IN ('USA', 'US', 'UNITED STATES OF AMERICA', 'UNITED STATES', 'U.S.A', 'U.S.')
),
country_freq AS (
    -- Count frequency of each country name variant per rating
    SELECT
        job_satisfaction,
        country,
        COUNT(*) AS freq,
        -- Rank country variants by frequency within each rating
        ROW_NUMBER() OVER (
            PARTITION BY job_satisfaction 
            ORDER BY COUNT(*) DESC, country ASC  -- tie-break alphabetically
        ) AS rn
    FROM usa_data
    GROUP BY job_satisfaction, country
)
SELECT
    ud.job_satisfaction,
    COUNT(*) AS number_of_respondents,
    cf.country AS most_frequent_country_name
FROM usa_data ud
JOIN country_freq cf
    ON ud.job_satisfaction = cf.job_satisfaction
    AND cf.rn = 1  -- pick the most frequent country name variant
GROUP BY ud.job_satisfaction, cf.country
ORDER BY ud.job_satisfaction ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    base.job_satisfaction,
    COUNT(*) AS number_of_respondents,
    -- Subquery to find the most frequent country name for each rating
    (
        SELECT s2.country
        FROM survey s2
        WHERE UPPER(s2.country) IN ('USA', 'US', 'UNITED STATES OF AMERICA', 'UNITED STATES', 'U.S.A', 'U.S.')
          AND s2.job_satisfaction = base.job_satisfaction
        GROUP BY s2.country
        ORDER BY COUNT(*) DESC, s2.country ASC  -- tie-break alphabetically
        LIMIT 1
    ) AS most_frequent_country_name
FROM survey base
WHERE UPPER(base.country) IN ('USA', 'US', 'UNITED STATES OF AMERICA', 'UNITED STATES', 'U.S.A', 'U.S.')
GROUP BY base.job_satisfaction
ORDER BY base.job_satisfaction ASC;
