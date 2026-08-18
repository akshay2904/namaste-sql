-- ======================================================================
-- 134 - Dormant Customers
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Swiggy
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/134-dormant-customers
-- ======================================================================

/*
Imagine you are working for Swiggy (a food delivery service platform). As part of your role in the data analytics team, you're tasked with identifying dormant customers - those who have registered on the platform but have not placed any orders recently. Identifying dormant customers is crucial for targeted marketing efforts and customer re-engagement strategies.

 

A dormant customer is defined as a user who registered more than 6 months ago from today but has not placed any orders in the last 3 months. Your query should return the list of dormant customers and order amount of last order placed by them. If no order was placed by a customer then order amount should be 0. order the output by user id.

Note: All the dates are in UTC time zone.

 
Table: users
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| user_id      | int      |
| name         | varchar  | 
| email        | varchar  |
| signup_date  | date     |
+--------------+--------- +Table: orders
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| order_id     | int      |
| order_date   | date     | 
| user_id      | int      |
| order_amount | int      |
+--------------+----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH dormant_users AS (
    -- Users registered more than 6 months ago
    SELECT user_id, name, email, signup_date
    FROM users
    WHERE signup_date < CURRENT_DATE - INTERVAL '6 months'
),
recent_orderers AS (
    -- Users who placed at least one order in the last 3 months
    SELECT DISTINCT user_id
    FROM orders
    WHERE order_date >= CURRENT_DATE - INTERVAL '3 months'
),
last_order AS (
    -- Get the last order amount per user using window function
    SELECT DISTINCT ON (user_id)
        user_id,
        order_amount,
        order_date
    FROM orders
    ORDER BY user_id, order_date DESC
)
SELECT
    d.user_id,
    d.name,
    d.email,
    d.signup_date,
    COALESCE(lo.order_amount, 0) AS last_order_amount
FROM dormant_users d
-- Exclude users who ordered in the last 3 months
LEFT JOIN recent_orderers ro ON d.user_id = ro.user_id
-- Bring in last order amount
LEFT JOIN last_order lo ON d.user_id = lo.user_id
WHERE ro.user_id IS NULL  -- not a recent orderer = dormant
ORDER BY d.user_id;


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    u.user_id,
    u.name,
    u.email,
    u.signup_date,
    -- If customer never ordered or no recent order, get last order amount
    COALESCE(
        (
            SELECT o2.order_amount
            FROM orders o2
            WHERE o2.user_id = u.user_id
            ORDER BY o2.order_date DESC
            LIMIT 1
        ),
        0
    ) AS last_order_amount
FROM users u
WHERE
    -- Registered more than 6 months ago
    u.signup_date < CURRENT_DATE - INTERVAL '6 months'
    -- Has NOT placed any order in the last 3 months
    AND u.user_id NOT IN (
        SELECT DISTINCT user_id
        FROM orders
        WHERE order_date >= CURRENT_DATE - INTERVAL '3 months'
          AND user_id IS NOT NULL  -- guard against NULLs in NOT IN
    )
ORDER BY u.user_id;
