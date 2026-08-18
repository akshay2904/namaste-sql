-- ======================================================================
-- 27 - Income Tax Returns
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Tcs
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/27-income-tax-returns
-- ======================================================================

/*
Given two tables: income_tax_dates and users, write a query to identify users who either filed their income tax returns late or completely skipped filing for certain financial years.

A return is considered late if the return_file_date is after the file_due_date.
A return is considered missed if there is no entry for the user in the users table for a given financial year (i.e., the user did not file at all).
Your task is to generate a list of users along with the financial year for which they either filed late or missed filing, and also include a comment column specifying whether it is a 'late return' or 'missed'. The result should be sorted by financial year in ascending order.

 
Table: income_tax_dates
+-----------------+------------+
| COLUMN_NAME     | DATA_TYPE  |
+-----------------+------------+
| financial_year  | varchar(4) |
| file_start_date | date       |
| file_due_date   | date       |
+-----------------+------------+Table: users
+------------------+------------+
| COLUMN_NAME      | DATA_TYPE  |
+------------------+------------+
| user_id          | int        |
| financial_year   | varchar(4) |
| return_file_date | date       |
+------------------+------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH all_users AS (
    -- Get distinct list of all users across all years
    SELECT DISTINCT user_id FROM users
),
all_combinations AS (
    -- Cross join every user with every financial year to find missed filings
    SELECT 
        au.user_id,
        itd.financial_year,
        itd.file_due_date
    FROM all_users au
    CROSS JOIN income_tax_dates itd
),
late_returns AS (
    -- Users who filed but filed late
    SELECT 
        u.user_id,
        u.financial_year,
        'late return' AS comment
    FROM users u
    JOIN income_tax_dates itd 
        ON u.financial_year = itd.financial_year
    WHERE u.return_file_date > itd.file_due_date
),
missed_returns AS (
    -- Users who never filed for a given financial year
    SELECT 
        ac.user_id,
        ac.financial_year,
        'missed' AS comment
    FROM all_combinations ac
    LEFT JOIN users u 
        ON ac.user_id = u.user_id 
        AND ac.financial_year = u.financial_year
    WHERE u.user_id IS NULL
)
SELECT user_id, financial_year, comment
FROM late_returns
UNION ALL
SELECT user_id, financial_year, comment
FROM missed_returns
ORDER BY financial_year ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Late returns: users whose return_file_date exceeds the file_due_date
SELECT 
    u.user_id,
    u.financial_year,
    'late return' AS comment
FROM users u, income_tax_dates itd
WHERE u.financial_year = itd.financial_year
  AND u.return_file_date > itd.file_due_date

UNION ALL

-- Missed returns: users who have no record for a financial year they should have filed
SELECT 
    all_u.user_id,
    itd.financial_year,
    'missed' AS comment
FROM (
    -- All distinct users
    SELECT DISTINCT user_id FROM users
) all_u,
income_tax_dates itd
WHERE NOT EXISTS (
    SELECT 1 
    FROM users u2
    WHERE u2.user_id = all_u.user_id
      AND u2.financial_year = itd.financial_year
)

ORDER BY financial_year ASC;
