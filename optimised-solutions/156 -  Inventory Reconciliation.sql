-- ======================================================================
-- 156 -  Inventory Reconciliation
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Bcg
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/156-inventory-reconciliation
-- ======================================================================

/*
A retail company tracks product scans using two systems:

 

System A (table1) logs scans when products arrive at the warehouse.
System B (table2) logs scans when products are shipped out.

 

Each scan logs only the product ids. Due to delays or duplicates, the number of scans per product can differ between systems.

Write a query to match scans from System A and System B by product ids and scan order (first from system A with first from first B, second from A with second from B, etc.). If a scan exists in only one system, show it with NULL in the unmatched column.
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_a AS (
    SELECT
        product_id,
        ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY (SELECT NULL)) AS rn
    FROM table1
),
ranked_b AS (
    SELECT
        product_id,
        ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY (SELECT NULL)) AS rn
    FROM table2
)
SELECT
    COALESCE(a.product_id, b.product_id) AS product_id,
    a.product_id                          AS system_a_product_id,
    b.product_id                          AS system_b_product_id,
    COALESCE(a.rn, b.rn)                  AS scan_order
FROM ranked_a a
FULL OUTER JOIN ranked_b b
    ON a.product_id = b.product_id
   AND a.rn        = b.rn
ORDER BY
    COALESCE(a.product_id, b.product_id),
    COALESCE(a.rn, b.rn);

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Generate a row number using a self-join count (simulates ROW_NUMBER)
SELECT
    COALESCE(a.product_id, b.product_id) AS product_id,
    a.product_id                          AS system_a_product_id,
    b.product_id                          AS system_b_product_id,
    COALESCE(a.rn, b.rn)                  AS scan_order
FROM (
    -- Brute-force row numbering for table1 via correlated subquery
    SELECT
        t1.product_id,
        (
            SELECT COUNT(*)
            FROM table1 t1b
            WHERE t1b.product_id = t1.product_id
              AND (
                  -- use ctid as a tie-breaker to assign a unique rank
                  t1b.ctid < t1.ctid
                  OR (t1b.ctid = t1.ctid)
              )
        ) AS rn
    FROM table1 t1
) a
FULL OUTER JOIN (
    -- Brute-force row numbering for table2 via correlated subquery
    SELECT
        t2.product_id,
        (
            SELECT COUNT(*)
            FROM table2 t2b
            WHERE t2b.product_id = t2.product_id
              AND (
                  t2b.ctid < t2.ctid
                  OR (t2b.ctid = t2.ctid)
              )
        ) AS rn
    FROM table2 t2
) b
    ON  a.product_id = b.product_id
    AND a.rn         = b.rn
ORDER BY
    COALESCE(a.product_id, b.product_id),
    COALESCE(a.rn, b.rn);
