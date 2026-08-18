-- ======================================================================
-- 80 - Rolling Sales
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Walmart
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/80-rolling-sales
-- ======================================================================

/*
You are tasked with analysing the sales data for products during the month of January 2024. Your goal is to calculate the rolling sum of sales for each product and each day of Jan 2024, considering the sales for the current day and the two previous days. Note that for some days, there might not be any sales for certain products, and you need to consider these days as having sales of 0.

You can make use of the calendar table which has the all the dates for Jan-2024.

 
Tables: orders
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| amount      | int        |
| order_date  | date       |
| order_id    | int        |
| product_id  | varchar(5) |
+-------------+------------+Tables: calendar_dim
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| cal_date    | date      |
+-------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_sales AS (
    -- Aggregate sales per product per day (only for Jan 2024 dates)
    SELECT
        product_id,
        order_date,
        SUM(amount) AS daily_amount
    FROM orders
    WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
    GROUP BY product_id, order_date
),
products AS (
    -- Get distinct products that have at least one sale in Jan 2024
    SELECT DISTINCT product_id FROM daily_sales
),
product_calendar AS (
    -- Cross join products with every day in Jan 2024 to fill in gaps
    SELECT
        p.product_id,
        c.cal_date
    FROM products p
    CROSS JOIN calendar_dim c
    WHERE c.cal_date BETWEEN '2024-01-01' AND '2024-01-31'
),
filled_sales AS (
    -- Fill missing days with 0 using LEFT JOIN
    SELECT
        pc.product_id,
        pc.cal_date AS order_date,
        COALESCE(ds.daily_amount, 0) AS daily_amount
    FROM product_calendar pc
    LEFT JOIN daily_sales ds
        ON pc.product_id = ds.product_id
        AND pc.cal_date  = ds.order_date
)
SELECT
    product_id,
    order_date,
    daily_amount,
    -- Rolling 3-day sum: current day + 2 preceding days
    SUM(daily_amount) OVER (
        PARTITION BY product_id
        ORDER BY order_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_3day_sum
FROM filled_sales
ORDER BY product_id, order_date;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH daily_sales AS (
    SELECT
        product_id,
        order_date,
        SUM(amount) AS daily_amount
    FROM orders
    WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
    GROUP BY product_id, order_date
),
products AS (
    SELECT DISTINCT product_id FROM daily_sales
),
product_calendar AS (
    -- All product-date combinations for Jan 2024
    SELECT
        p.product_id,
        c.cal_date AS order_date
    FROM products p
    CROSS JOIN calendar_dim c
    WHERE c.cal_date BETWEEN '2024-01-01' AND '2024-01-31'
),
filled_sales AS (
    SELECT
        pc.product_id,
        pc.order_date,
        COALESCE(ds.daily_amount, 0) AS daily_amount
    FROM product_calendar pc
    LEFT JOIN daily_sales ds
        ON pc.product_id = ds.product_id
        AND pc.order_date = ds.order_date
)
SELECT
    f1.product_id,
    f1.order_date,
    f1.daily_amount,
    -- Manually sum current day + up to 2 preceding days using a correlated subquery
    (
        SELECT SUM(f2.daily_amount)
        FROM filled_sales f2
        WHERE f2.product_id = f1.product_id
          AND f2.order_date BETWEEN f1.order_date - INTERVAL '2 days' AND f1.order_date
    ) AS rolling_3day_sum
FROM filled_sales f1
ORDER BY f1.product_id, f1.order_date;
