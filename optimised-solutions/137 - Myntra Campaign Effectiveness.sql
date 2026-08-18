-- ======================================================================
-- 137 - Myntra Campaign Effectiveness
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Myntra
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/137-myntra-campaign-effectiveness
-- ======================================================================

/*
Myntra marketing team wants to measure the effectiveness of recent campaigns aimed at acquiring new customers. A new customer is defined as someone who made their first-ever purchase during a specific period, with no prior purchase history.

They have asked you to identify the new customers acquired in the last 3 months, excluding the current month. Output should display customer id and their first purchase date. Order the result by customer id.

For example:
If today is March 15, 2025, the SQL should give customers whose first purchase falls in the range from December 1, 2024, to February 28, 2025, and should not include any new customers made in March 2025.
 
Table: transactions
+---------------+------------+
| COLUMN_NAME     | DATA_TYPE|
+-----------------+----------+
| transaction_id  | int      |
| customer_id     | int      | 
| transaction_date| date     | 
| amount          | int      | 
+-----------------+----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH customer_first_purchase AS (
    SELECT
        customer_id,
        MIN(transaction_date) AS first_purchase_date
    FROM transactions
    GROUP BY customer_id
)
SELECT
    customer_id,
    first_purchase_date
FROM customer_first_purchase
WHERE first_purchase_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '3 months'
  AND first_purchase_date <  DATE_TRUNC('month', CURRENT_DATE)  -- excludes current month
ORDER BY customer_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    customer_id,
    MIN(transaction_date) AS first_purchase_date
FROM transactions
GROUP BY customer_id
HAVING
    -- First purchase must be on or after the start of the 3-month window
    MIN(transaction_date) >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '3 months'
    -- First purchase must be before the current month (exclude current month)
    AND MIN(transaction_date) < DATE_TRUNC('month', CURRENT_DATE)
ORDER BY customer_id;
