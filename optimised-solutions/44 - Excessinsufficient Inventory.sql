-- ======================================================================
-- 44 - Excess/insufficient Inventory
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Flipkart
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/44-excess-insufficient-inventory
-- ======================================================================

/*
Suppose you are a data analyst working for Flipkart. Your task is to identify excess and insufficient inventory at various Flipkart warehouses in terms of no of units and cost.  Excess inventory is when inventory levels are greater than inventory targets else its insufficient inventory.

Write an SQL to derive excess/insufficient Inventory volume and value in cost for each location as well as at overall company level, display the results in ascending order of location id.

 
Table: inventory
+------------------+-----------+
| COLUMN_NAME      | DATA_TYPE |
+------------------+-----------+
| inventory_level  | int       |
| inventory_target | int       |
| location_id      | int       |
| product_id       | int       |
+------------------+-----------+Table: products
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| product_id  | int          |
| unit_cost   | decimal(5,2) |
+-------------+--------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    i.location_id,
    SUM(i.inventory_level - i.inventory_target) AS inventory_volume,
    SUM((i.inventory_level - i.inventory_target) * p.unit_cost) AS inventory_cost
FROM inventory i
JOIN products p ON i.product_id = p.product_id
GROUP BY i.location_id

UNION ALL

SELECT 
    NULL AS location_id,
    SUM(i.inventory_level - i.inventory_target) AS inventory_volume,
    SUM((i.inventory_level - i.inventory_target) * p.unit_cost) AS inventory_cost
FROM inventory i
JOIN products p ON i.product_id = p.product_id

ORDER BY location_id ASC;
```
