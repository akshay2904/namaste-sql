-- ======================================================================
-- 69 - Country Indicators
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Deloitte
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/69-country-indicators
-- ======================================================================

/*
In the realm of global indicators and country-level assessments, it's imperative to identify the years in which certain indicators hit their lowest values for each country. Leveraging a dataset provided by government, which contains indicators across multiple years for various countries, your task is to formulate an SQL query to find the following information:
For each country and indicator combination, determine the year in which the indicator value was lowest, along with the corresponding indicator value. Sort the output by country name and indicator name.

 
Table: country_data 
+----------------+--------------+
| COLUMN_NAME    | DATA_TYPE    |
+----------------+--------------+
| country_name   | varchar(15)  |
| indicator_name | varchar(25)  |
| year_2010      | decimal(3,2) |
| year_2011      | decimal(3,2) |
| year_2012      | decimal(3,2) |
| year_2013      | decimal(3,2) |
| year_2014      | decimal(3,2) |
+----------------+--------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH unpivoted AS (
    -- Unpivot year columns into rows using UNION ALL
    SELECT country_name, indicator_name, 2010 AS year, year_2010 AS value FROM country_data WHERE year_2010 IS NOT NULL
    UNION ALL
    SELECT country_name, indicator_name, 2011, year_2011 FROM country_data WHERE year_2011 IS NOT NULL
    UNION ALL
    SELECT country_name, indicator_name, 2012, year_2012 FROM country_data WHERE year_2012 IS NOT NULL
    UNION ALL
    SELECT country_name, indicator_name, 2013, year_2013 FROM country_data WHERE year_2013 IS NOT NULL
    UNION ALL
    SELECT country_name, indicator_name, 2014, year_2014 FROM country_data WHERE year_2014 IS NOT NULL
),
ranked AS (
    SELECT
        country_name,
        indicator_name,
        year,
        value,
        -- Rank rows by value ascending; pick rank=1 (lowest value)
        RANK() OVER (PARTITION BY country_name, indicator_name ORDER BY value ASC) AS rnk
    FROM unpivoted
)
SELECT
    country_name,
    indicator_name,
    year        AS lowest_year,
    value       AS lowest_value
FROM ranked
WHERE rnk = 1
ORDER BY country_name, indicator_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH unpivoted AS (
    -- Unpivot year columns into rows
    SELECT country_name, indicator_name, 2010 AS year, year_2010 AS value FROM country_data WHERE year_2010 IS NOT NULL
    UNION ALL
    SELECT country_name, indicator_name, 2011, year_2011 FROM country_data WHERE year_2011 IS NOT NULL
    UNION ALL
    SELECT country_name, indicator_name, 2012, year_2012 FROM country_data WHERE year_2012 IS NOT NULL
    UNION ALL
    SELECT country_name, indicator_name, 2013, year_2013 FROM country_data WHERE year_2013 IS NOT NULL
    UNION ALL
    SELECT country_name, indicator_name, 2014, year_2014 FROM country_data WHERE year_2014 IS NOT NULL
),
min_values AS (
    -- Find the minimum value per country/indicator
    SELECT
        country_name,
        indicator_name,
        MIN(value) AS lowest_value
    FROM unpivoted
    GROUP BY country_name, indicator_name
)
SELECT
    u.country_name,
    u.indicator_name,
    -- If multiple years share the same minimum, pick the earliest year
    MIN(u.year)  AS lowest_year,
    m.lowest_value
FROM unpivoted u
JOIN min_values m
    ON  u.country_name   = m.country_name
    AND u.indicator_name = m.indicator_name
    AND u.value          = m.lowest_value
GROUP BY u.country_name, u.indicator_name, m.lowest_value
ORDER BY u.country_name, u.indicator_name;
