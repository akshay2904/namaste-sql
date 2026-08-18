-- ======================================================================
-- 19 - Order Fulfilment
-- ======================================================================
-- Difficulty : Extreme Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/19-order-fulfilment
-- ======================================================================

/*
You are given two tables: products and orders. The products table contains information about each product, including the product ID and available quantity in the warehouse. The orders table contains details about customer orders, including the order ID, product ID, order date, and quantity requested by the customer.

Write an SQL query to generate a report listing the orders that can be fulfilled based on the available inventory in the warehouse, following a first-come-first-serve approach based on the order date. Each row in the report should include the order ID, product name, quantity requested by the customer, quantity actually fulfilled, and a comments column as below:

If the order can be completely fulfilled then 'Full Order'.

If the order can be partially fulfilled then 'Partial Order'.

If order cannot be fulfilled at all then 'No Order' .

Display the output in ascending order of order id.

 
Table: products
+--------------------+-------------+
| COLUMN_NAME        | DATA_TYPE   |
+--------------------+-------------+
| product_id         | int         |
| product_name       | varchar(10) |
| available_quantity | int         |
+--------------------+-------------+

Table: orders
+--------------------+-----------+
| COLUMN_NAME        | DATA_TYPE |
+--------------------+-----------+
| order_id           | int       |
| product_id         | int       |
| order_date         | date      |
| quantity_requested | int       |
+--------------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_orders AS (
    -- Assign a row number per product based on order date (first-come-first-serve)
    SELECT
        o.order_id,
        o.product_id,
        o.order_date,
        o.quantity_requested,
        -- Cumulative sum of quantity requested for this product up to this order
        SUM(o.quantity_requested) OVER (
            PARTITION BY o.product_id
            ORDER BY o.order_date, o.order_id  -- use order_id as tiebreaker
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_requested
    FROM orders o
),
fulfilled AS (
    SELECT
        r.order_id,
        p.product_name,
        r.quantity_requested,
        -- What was available before this order arrived
        GREATEST(0,
            p.available_quantity - (r.cumulative_requested - r.quantity_requested)
        ) AS remaining_before,
        p.available_quantity,
        r.cumulative_requested
    FROM ranked_orders r
    JOIN products p ON r.product_id = p.product_id
)
SELECT
    order_id,
    product_name,
    quantity_requested,
    -- Fulfilled quantity: min of what was requested vs what remained
    LEAST(quantity_requested, remaining_before) AS quantity_fulfilled,
    CASE
        WHEN remaining_before >= quantity_requested THEN 'Full Order'
        WHEN remaining_before > 0                   THEN 'Partial Order'
        ELSE                                             'No Order'
    END AS comments
FROM fulfilled
ORDER BY order_id;


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    o.order_id,
    p.product_name,
    o.quantity_requested,
    -- Remaining inventory before this order = available - sum of all prior orders for same product
    CASE
        WHEN (
            p.available_quantity - COALESCE((
                SELECT SUM(o2.quantity_requested)
                FROM orders o2
                WHERE o2.product_id = o.product_id
                  AND (o2.order_date < o.order_date
                       OR (o2.order_date = o.order_date AND o2.order_id < o.order_id))
            ), 0)
        ) >= o.quantity_requested
        THEN o.quantity_requested  -- fully fulfilled

        WHEN (
            p.available_quantity - COALESCE((
                SELECT SUM(o2.quantity_requested)
                FROM orders o2
                WHERE o2.product_id = o.product_id
                  AND (o2.order_date < o.order_date
                       OR (o2.order_date = o.order_date AND o2.order_id < o.order_id))
            ), 0)
        ) > 0
        THEN (
            p.available_quantity - COALESCE((
                SELECT SUM(o2.quantity_requested)
                FROM orders o2
                WHERE o2.product_id = o.product_id
                  AND (o2.order_date < o.order_date
                       OR (o2.order_date = o.order_date AND o2.order_id < o.order_id))
            ), 0)
        )  -- partially fulfilled

        ELSE 0  -- nothing left
    END AS quantity_fulfilled,
    CASE
        WHEN (
            p.available_quantity - COALESCE((
                SELECT SUM(o2.quantity_requested)
                FROM orders o2
                WHERE o2.product_id = o.product_id
                  AND (o2.order_date < o.order_date
                       OR (o2.order_date = o.order_date AND o2.order_id < o.order_id))
            ), 0)
        ) >= o.quantity_requested THEN 'Full Order'

        WHEN (
            p.available_quantity - COALESCE((
                SELECT SUM(o2.quantity_requested)
                FROM orders o2
                WHERE o2.product_id = o.product_id
                  AND (o2.order_date < o.order_date
                       OR (o2.order_date = o.order_date AND o2.order_id < o.order_id))
            ), 0)
        ) > 0 THEN 'Partial Order'

        ELSE 'No Order'
    END AS comments
FROM orders o
JOIN products p ON o.product_id = p.product_id
ORDER BY o.order_id;
