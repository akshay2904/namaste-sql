-- ======================================================================
-- 132 - Last Sunday
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/132-last-sunday
-- ======================================================================

/*
Write an SQL to get the date of the last Sunday as per today's date. If you are solving the problem on Sunday then it should still return the date of last Sunday (not current date).

 

Note : Dates are displayed as per UTC time zone.
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Use ISODOW: Monday=1 ... Sunday=7
-- Subtract enough days to always land on the previous Sunday (never today if today is Sunday)
SELECT (CURRENT_DATE - INTERVAL '1 day' * (((EXTRACT(ISODOW FROM CURRENT_DATE)::INT % 7) + 7) % 7 + (CASE WHEN EXTRACT(ISODOW FROM CURRENT_DATE)::INT = 7 THEN 7 ELSE 0 END)))::DATE AS last_sunday;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- DOW: Sunday=0, Monday=1, ..., Saturday=6
-- If today is Sunday (DOW=0), go back 7 days; otherwise go back DOW days
SELECT
    CASE
        WHEN EXTRACT(DOW FROM CURRENT_DATE)::INT = 0
            THEN (CURRENT_DATE - INTERVAL '7 days')::DATE
        ELSE
            (CURRENT_DATE - INTERVAL '1 day' * EXTRACT(DOW FROM CURRENT_DATE)::INT)::DATE
    END AS last_sunday;
