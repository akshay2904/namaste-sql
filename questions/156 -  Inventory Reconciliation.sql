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

```sql
WITH ranked_a AS (
  SELECT 
    product_id,
    scan_id,
    ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY scan_id) AS scan_order
  FROM table1
),
ranked_b AS (
  SELECT 
    product_id,
    scan_id,
    ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY scan_id) AS scan_order
  FROM table2
)
SELECT 
  COALESCE(a.product_id, b.product_id) AS product_id,
  a.scan_id AS system_a_scan_id,
  b.scan_id AS system_b_scan_id,
  COALESCE(a.scan_order, b.scan_order) AS scan_order
FROM ranked_a a
FULL OUTER JOIN ranked_b b
  ON a.product_id = b.product_id
  AND a.scan_order = b.scan_order
ORDER BY product_id, scan_order;
```
