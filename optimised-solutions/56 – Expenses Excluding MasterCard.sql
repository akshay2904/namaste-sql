-- ======================================================================
-- 56 – Expenses Excluding MasterCard
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Paypal
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/56-expenses-excluding-mastercard
-- ======================================================================

/*
You're working for a financial analytics company that specializes in analyzing credit card expenditures. You have a dataset containing information about users' credit card expenditures across different card companies.
Write an SQL query to find the total expenditure from other cards (excluding Mastercard) for users who hold Mastercard.  Display only the users(along with Mastercard expense and other expense) for which expense from other cards together is more than Mastercard expense.

 
Table: expenditures
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| user_name    | varchar(10) |
| expenditure  | int         |
| card_company | varchar(15) |
+--------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH card_summary AS (
    SELECT
        user_name,
        -- Sum expenditure only for Mastercard
        SUM(CASE WHEN card_company = 'Mastercard' THEN expenditure ELSE 0 END) AS mastercard_expense,
        -- Sum expenditure for all other cards
        SUM(CASE WHEN card_company != 'Mastercard' THEN expenditure ELSE 0 END) AS other_expense
    FROM expenditures
    GROUP BY user_name
)
SELECT
    user_name,
    mastercard_expense,
    other_expense
FROM card_summary
WHERE mastercard_expense > 0          -- Must be a Mastercard holder
  AND other_expense > mastercard_expense  -- Other cards total exceeds Mastercard
ORDER BY user_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    mc.user_name,
    mc.mastercard_expense,
    oc.other_expense
FROM
    -- Subquery: get Mastercard holders and their Mastercard total
    (
        SELECT
            user_name,
            SUM(expenditure) AS mastercard_expense
        FROM expenditures
        WHERE card_company = 'Mastercard'
        GROUP BY user_name
    ) mc
    INNER JOIN
    -- Subquery: get total expenditure on non-Mastercard cards
    (
        SELECT
            user_name,
            SUM(expenditure) AS other_expense
        FROM expenditures
        WHERE card_company != 'Mastercard'
        GROUP BY user_name
    ) oc
    ON mc.user_name = oc.user_name
WHERE oc.other_expense > mc.mastercard_expense  -- Filter: other cards exceed Mastercard
ORDER BY mc.user_name;
