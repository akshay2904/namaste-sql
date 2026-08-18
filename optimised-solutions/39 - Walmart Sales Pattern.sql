-- ======================================================================
-- 39 - Walmart Sales Pattern
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Walmart
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/39-walmart-sales-pattern
-- ======================================================================

/*
You are tasked with analyzing the sales data of a Walmart chain with multiple stores across different locations. The company wants to identify the highest and lowest sales months for each location for the year 2023 to gain insights into their sales patterns, display the output in ascending order of location. In case of a tie display the latest month.

 
Table: stores
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| store_id    | int         |
| store_name  | varchar(20) |
| location    | varchar(20) |
+-------------+-------------+Table: transactions 
+------------------+-----------+
| COLUMN_NAME      | DATA_TYPE |
+------------------+-----------+
| customer_id      | int       |
| store_id         | int       |
| amount           | int       |
| transaction_date | date      |
| transaction_id   | int       |
+------------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_sales AS (
    SELECT 
        s.location,
        EXTRACT(MONTH FROM t.transaction_date) AS month,
        SUM(t.amount) AS total_sales
    FROM stores s
    JOIN transactions t ON s.store_id = t.store_id
    WHERE EXTRACT(YEAR FROM t.transaction_date) = 2023
    GROUP BY s.location, EXTRACT(MONTH FROM t.transaction_date)
),
ranked_sales AS (
    SELECT
        location,
        month,
        total_sales,
        -- For highest: rank desc by sales, then desc by month to get latest on tie
        RANK() OVER (PARTITION BY location ORDER BY total_sales DESC, month DESC) AS high_rank,
        -- For lowest: rank asc by sales, then desc by month to get latest on tie
        RANK() OVER (PARTITION BY location ORDER BY total_sales ASC, month DESC) AS low_rank
    FROM monthly_sales
)
SELECT
    location,
    MAX(CASE WHEN high_rank = 1 THEN month END) AS highest_sales_month,
    MAX(CASE WHEN low_rank = 1 THEN month END)  AS lowest_sales_month
FROM ranked_sales
WHERE high_rank = 1 OR low_rank = 1
GROUP BY location
ORDER BY location ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH monthly_sales AS (
    SELECT 
        s.location,
        EXTRACT(MONTH FROM t.transaction_date) AS month,
        SUM(t.amount) AS total_sales
    FROM stores s
    JOIN transactions t ON s.store_id = t.store_id
    WHERE EXTRACT(YEAR FROM t.transaction_date) = 2023
    GROUP BY s.location, EXTRACT(MONTH FROM t.transaction_date)
),
-- Get the max and min sales per location
max_min_per_location AS (
    SELECT
        location,
        MAX(total_sales) AS max_sales,
        MIN(total_sales) AS min_sales
    FROM monthly_sales
    GROUP BY location
),
-- For highest month: among months tied at max_sales, pick the latest month
highest_month AS (
    SELECT ms.location, MAX(ms.month) AS highest_sales_month
    FROM monthly_sales ms
    JOIN max_min_per_location mm 
        ON ms.location = mm.location 
       AND ms.total_sales = mm.max_sales
    GROUP BY ms.location
),
-- For lowest month: among months tied at min_sales, pick the latest month
lowest_month AS (
    SELECT ms.location, MAX(ms.month) AS lowest_sales_month
    FROM monthly_sales ms
    JOIN max_min_per_location mm 
        ON ms.location = mm.location 
       AND ms.total_sales = mm.min_sales
    GROUP BY ms.location
)
SELECT
    h.location,
    h.highest_sales_month,
    l.lowest_sales_month
FROM highest_month h
JOIN lowest_month l ON h.location = l.location
ORDER BY h.location ASC;
