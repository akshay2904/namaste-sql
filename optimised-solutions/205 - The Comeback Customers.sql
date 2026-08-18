-- ======================================================================
-- 205 - The Comeback Customers
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/205-the-comeback-customers
-- ======================================================================

/*
You work at an e-commerce company. The marketing team wants to identify “Comeback Customers” — customers who had a period of inactivity (no orders for 60 or more days) and then came back to purchase again. The team wants to understand their buying behaviour before and after the comeback.

---

Table: orders
One row per order placed by a customer.
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| order_id      | INT       |
| customer_id   | INT       |
| order_date    | DATE      |
| order_amount  | INT       |
+---------------+-----------+
---

The Ask

Find all comeback customers and return one row per customer:

- `customer_id`
- `gap_days` — the longest gap (in days) between any two consecutive orders
- `orders_before_comeback` — number of orders placed before the gap
- `orders_after_comeback` — number of orders placed after the gap
- `spend_before_comeback` — total amount spent before the gap
- `spend_after_comeback` — total amount spent after the gap
- `comeback_date` — the order date when they came back after the longest gap

Constraints & Traps:

> - Only consider customers who have placed **at least 2 orders**
> - Gap is measured between **consecutive orders** sorted by date
> - If a customer has **multiple gaps ≥ 60 days**, report only the **longest gap**
> - If two gaps are equal in length, pick the **earliest one**
> - Customers with **no gap ≥ 60 days** should not appear in the result
> - `orders_before_comeback` and `orders_after_comeback` are split at the longest gap
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH consecutive_orders AS (
    -- For each order, compute the gap from the previous order (per customer)
    SELECT
        order_id,
        customer_id,
        order_date,
        order_amount,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date,
        order_date - LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS gap_days
    FROM orders
),
longest_gap AS (
    -- Find the single longest gap >= 60 days per customer (earliest if tie)
    SELECT DISTINCT ON (customer_id)
        customer_id,
        gap_days,
        prev_order_date  AS gap_start_date,  -- last order before the gap
        order_date       AS comeback_date     -- first order after the gap
    FROM consecutive_orders
    WHERE gap_days >= 60
    ORDER BY customer_id, gap_days DESC, prev_order_date ASC
),
order_stats AS (
    -- Tag every order as before or after the comeback gap
    SELECT
        o.customer_id,
        o.order_date,
        o.order_amount,
        lg.gap_start_date,
        lg.comeback_date,
        lg.gap_days,
        CASE
            WHEN o.order_date <= lg.gap_start_date THEN 'before'
            WHEN o.order_date >= lg.comeback_date  THEN 'after'
        END AS period
    FROM orders o
    JOIN longest_gap lg ON o.customer_id = lg.customer_id
)
SELECT
    customer_id,
    gap_days,
    COUNT(*) FILTER (WHERE period = 'before')          AS orders_before_comeback,
    COUNT(*) FILTER (WHERE period = 'after')           AS orders_after_comeback,
    COALESCE(SUM(order_amount) FILTER (WHERE period = 'before'), 0) AS spend_before_comeback,
    COALESCE(SUM(order_amount) FILTER (WHERE period = 'after'),  0) AS spend_after_comeback,
    MAX(comeback_date)                                 AS comeback_date
FROM order_stats
GROUP BY customer_id, gap_days
ORDER BY customer_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Step 1: self-join to find consecutive orders and their gaps
WITH order_pairs AS (
    SELECT
        a.customer_id,
        a.order_date                              AS before_date,
        b.order_date                              AS after_date,
        (b.order_date - a.order_date)             AS gap_days
    FROM orders a
    JOIN orders b
        ON  a.customer_id = b.customer_id
        AND b.order_date  > a.order_date
        -- Ensure b is the IMMEDIATE next order after a (no order in between)
        AND NOT EXISTS (
            SELECT 1
            FROM orders m
            WHERE m.customer_id = a.customer_id
              AND m.order_date   > a.order_date
              AND m.order_date   < b.order_date
        )
),
-- Step 2: pick the longest gap >= 60 per customer (earliest if tie)
best_gap AS (
    SELECT
        customer_id,
        MAX(gap_days)  AS max_gap
    FROM order_pairs
    WHERE gap_days >= 60
    GROUP BY customer_id
),
longest_gap AS (
    SELECT
        op.customer_id,
        op.gap_days,
        op.before_date AS gap_start_date,
        op.after_date  AS comeback_date
    FROM order_pairs op
    JOIN best_gap bg
        ON  op.customer_id = bg.customer_id
        AND op.gap_days    = bg.max_gap
    WHERE op.gap_days >= 60
      -- if tie in gap length, pick the earliest gap (smallest before_date)
      AND op.before_date = (
            SELECT MIN(op2.before_date)
            FROM order_pairs op2
            WHERE op2.customer_id = op.customer_id
              AND op2.gap_days    = bg.max_gap
      )
),
-- Step 3: split orders into before / after for each comeback customer
orders_before AS (
    SELECT
        o.customer_id,
        COUNT(*)        AS orders_before_comeback,
        SUM(o.order_amount) AS spend_before_comeback
    FROM orders o
    JOIN longest_gap lg ON o.customer_id = lg.customer_id
    WHERE o.order_date <= lg.gap_start_date
    GROUP BY o.customer_id
),
orders_after AS (
    SELECT
        o.customer_id,
        COUNT(*)        AS orders_after_comeback,
        SUM(o.order_amount) AS spend_after_comeback
    FROM orders o
    JOIN longest_gap lg ON o.customer_id = lg.customer_id
    WHERE o.order_date >= lg.comeback_date
    GROUP BY o.customer_id
)
SELECT
    lg.customer_id,
    lg.gap_days,
    COALESCE(ob.orders_before_comeback, 0) AS orders_before_comeback,
    COALESCE(oa.orders_after_comeback,  0) AS orders_after_comeback,
    COALESCE(ob.spend_before_comeback,  0) AS spend_before_comeback,
    COALESCE(oa.spend_after_comeback,   0) AS spend_after_comeback,
    lg.comeback_date
FROM longest_gap     lg
LEFT JOIN orders_before ob ON lg.customer_id = ob.customer_id
LEFT JOIN orders_after  oa ON lg.customer_id = oa.customer_id
ORDER BY lg.customer_id;
