-- ======================================================================
-- 43 - Customer Retention
-- ======================================================================
-- Difficulty : Extreme Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/43-customer-retention
-- ======================================================================

/*
Customer retention can be defined as number of customers who continue to make purchases over a certain period compared to the total number of customers. Here's a step-by-step approach to calculate customer retention rate:
1- Determine the number of customers who made purchases 
in the current period (e.g., month: m )
2- Identify the number of customers from month m who made purchases 
in month m+1 , m+2 as well.
Suppose you are a data analyst working for Amazon. The company is interested in measuring customer retention over the months to understand how many customers continue to make purchases over time. Your task is to write an SQL to derive customer retention month over month, display the output in ascending order of current year, month & future year, month.

 
Table: orders
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| order_id    | int       |
| customer_id | int       |
| order_date  | date      |
+-------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_customers AS (
    -- Get distinct customers per year-month
    SELECT DISTINCT
        customer_id,
        DATE_TRUNC('month', order_date) AS purchase_month
    FROM orders
),
retention AS (
    SELECT
        EXTRACT(YEAR FROM m.purchase_month)::INT  AS current_year,
        EXTRACT(MONTH FROM m.purchase_month)::INT AS current_month,
        EXTRACT(YEAR FROM f.purchase_month)::INT  AS future_year,
        EXTRACT(MONTH FROM f.purchase_month)::INT AS future_month,
        COUNT(DISTINCT f.customer_id)             AS retained_customers,
        COUNT(DISTINCT m.customer_id)             AS total_customers_current
    FROM monthly_customers m
    -- Join to any future month where the same customer also purchased
    JOIN monthly_customers f
        ON m.customer_id = f.customer_id
        AND f.purchase_month > m.purchase_month
    GROUP BY
        m.purchase_month,
        f.purchase_month
)
SELECT
    current_year,
    current_month,
    future_year,
    future_month,
    total_customers_current,
    retained_customers,
    ROUND(
        retained_customers * 100.0 / total_customers_current, 2
    ) AS retention_rate_pct
FROM retention
ORDER BY
    current_year,
    current_month,
    future_year,
    future_month;


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    EXTRACT(YEAR  FROM m.purchase_month)::INT AS current_year,
    EXTRACT(MONTH FROM m.purchase_month)::INT AS current_month,
    EXTRACT(YEAR  FROM f.purchase_month)::INT AS future_year,
    EXTRACT(MONTH FROM f.purchase_month)::INT AS future_month,
    -- Total unique customers who purchased in the current month
    (
        SELECT COUNT(DISTINCT customer_id)
        FROM orders
        WHERE DATE_TRUNC('month', order_date) = m.purchase_month
    ) AS total_customers_current,
    -- Customers from current month who also purchased in the future month
    COUNT(DISTINCT f.customer_id) AS retained_customers,
    ROUND(
        COUNT(DISTINCT f.customer_id) * 100.0 /
        (
            SELECT COUNT(DISTINCT customer_id)
            FROM orders
            WHERE DATE_TRUNC('month', order_date) = m.purchase_month
        ), 2
    ) AS retention_rate_pct
FROM
    -- All distinct customer-month combinations
    (
        SELECT DISTINCT
            customer_id,
            DATE_TRUNC('month', order_date) AS purchase_month
        FROM orders
    ) AS m
JOIN
    (
        SELECT DISTINCT
            customer_id,
            DATE_TRUNC('month', order_date) AS purchase_month
        FROM orders
    ) AS f
    ON  m.customer_id    = f.customer_id
    AND f.purchase_month > m.purchase_month  -- future months only
GROUP BY
    m.purchase_month,
    f.purchase_month
ORDER BY
    current_year,
    current_month,
    future_year,
    future_month;
