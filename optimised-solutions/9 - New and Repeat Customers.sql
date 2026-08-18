-- ======================================================================
-- 9 - New and Repeat Customers
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Flipkart
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/9-new-and-repeat-customers
-- ======================================================================

/*
Flipkart wants to build a very important business metrics where they want to track on daily basis how many new and repeat customers are purchasing products from their website. A new customer is defined when he purchased anything for the first time from the website and repeat customer is someone who has done at least one purchase in the past.

 

Display order date , new customers , repeat customers  in ascending order of order_date.

 
Table: customer_orders
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| order_id     | int       |
| customer_id  | int       |
| order_date   | date      |
| order_amount | int       |
+--------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH customer_first_order AS (
    -- Find the first purchase date for each customer using window function
    SELECT
        customer_id,
        order_date,
        MIN(order_date) OVER (PARTITION BY customer_id) AS first_order_date
    FROM customer_orders
)
SELECT
    order_date,
    COUNT(CASE WHEN order_date = first_order_date THEN 1 END) AS new_customers,
    COUNT(CASE WHEN order_date > first_order_date THEN 1 END)  AS repeat_customers
FROM customer_first_order
GROUP BY order_date
ORDER BY order_date ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    co.order_date,
    -- New customer: this order_date matches their very first order date
    COUNT(CASE WHEN co.order_date = fo.first_order_date THEN 1 END) AS new_customers,
    -- Repeat customer: they have made at least one purchase before this order_date
    COUNT(CASE WHEN co.order_date > fo.first_order_date THEN 1 END)  AS repeat_customers
FROM customer_orders co
JOIN (
    -- Subquery to get the minimum (first) order date per customer
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date
    FROM customer_orders
    GROUP BY customer_id
) fo
    ON co.customer_id = fo.customer_id
GROUP BY co.order_date
ORDER BY co.order_date ASC;
