-- ======================================================================
-- 196 - Tax Calculation
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Hackerrank
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/196-tax-calculation
-- ======================================================================

/*
In the evolving landscape of financial technology, quickly assessing financial performance over time is crucial. A development team is enhancing a tax calculation application to include a dashboard feature. This feature will provide users with a clear view of their financial inflows over the quarters of 2023, facilitating better financial planning and tax calculation.

 

The dashboard will display the total income for each account, segmented by the four quarters of 2023, and will also include the total yearly income. This breakdown will help users understand their earnings pattern and prepare for tax calculations.

 

The result should have the following columns: 
email, q1_income, q2_income, q3_income, q4_income, total_yearly_income

email - the email associated with the account
q1_income .. q4_income - the total income for the specific quarter, with two decimal places
total_yearly_income - the sum of all quarters’ incomes for the year, with two decimal places
 

The results should be sorted in ascending order by email.

Note:

Only income recorded in 2023 should be included.

 
Table: accounts
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| id          | INT          |
| email       | VARCHAR(30)  |
+-------------+--------------+
Table: reports
+-------------+----------------+
| COLUMN_NAME | DATA_TYPE      |
+-------------+----------------+
| account_id  | INT            |
| dt          | VARCHAR(19)    |
| amount      | DECIMAL(6,2)   |
+-------------+----------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH quarterly_income AS (
    SELECT
        a.email,
        SUM(CASE WHEN EXTRACT(QUARTER FROM dt::DATE) = 1 THEN r.amount ELSE 0 END) AS q1_income,
        SUM(CASE WHEN EXTRACT(QUARTER FROM dt::DATE) = 2 THEN r.amount ELSE 0 END) AS q2_income,
        SUM(CASE WHEN EXTRACT(QUARTER FROM dt::DATE) = 3 THEN r.amount ELSE 0 END) AS q3_income,
        SUM(CASE WHEN EXTRACT(QUARTER FROM dt::DATE) = 4 THEN r.amount ELSE 0 END) AS q4_income
    FROM accounts a
    JOIN reports r ON a.id = r.account_id
    WHERE EXTRACT(YEAR FROM r.dt::DATE) = 2023
    GROUP BY a.email
)
SELECT
    email,
    ROUND(q1_income, 2) AS q1_income,
    ROUND(q2_income, 2) AS q2_income,
    ROUND(q3_income, 2) AS q3_income,
    ROUND(q4_income, 2) AS q4_income,
    ROUND(q1_income + q2_income + q3_income + q4_income, 2) AS total_yearly_income
FROM quarterly_income
ORDER BY email ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    a.email,
    ROUND(
        COALESCE((
            SELECT SUM(r1.amount)
            FROM reports r1
            WHERE r1.account_id = a.id
              AND EXTRACT(YEAR FROM r1.dt::DATE) = 2023
              AND EXTRACT(QUARTER FROM r1.dt::DATE) = 1
        ), 0), 2) AS q1_income,
    ROUND(
        COALESCE((
            SELECT SUM(r2.amount)
            FROM reports r2
            WHERE r2.account_id = a.id
              AND EXTRACT(YEAR FROM r2.dt::DATE) = 2023
              AND EXTRACT(QUARTER FROM r2.dt::DATE) = 2
        ), 0), 2) AS q2_income,
    ROUND(
        COALESCE((
            SELECT SUM(r3.amount)
            FROM reports r3
            WHERE r3.account_id = a.id
              AND EXTRACT(YEAR FROM r3.dt::DATE) = 2023
              AND EXTRACT(QUARTER FROM r3.dt::DATE) = 3
        ), 0), 2) AS q3_income,
    ROUND(
        COALESCE((
            SELECT SUM(r4.amount)
            FROM reports r4
            WHERE r4.account_id = a.id
              AND EXTRACT(YEAR FROM r4.dt::DATE) = 2023
              AND EXTRACT(QUARTER FROM r4.dt::DATE) = 4
        ), 0), 2) AS q4_income,
    ROUND(
        COALESCE((
            SELECT SUM(r5.amount)
            FROM reports r5
            WHERE r5.account_id = a.id
              AND EXTRACT(YEAR FROM r5.dt::DATE) = 2023
        ), 0), 2) AS total_yearly_income
FROM accounts a
-- Only include accounts that have at least one 2023 record
WHERE EXISTS (
    SELECT 1 FROM reports r
    WHERE r.account_id = a.id
      AND EXTRACT(YEAR FROM r.dt::DATE) = 2023
)
ORDER BY a.email ASC;
