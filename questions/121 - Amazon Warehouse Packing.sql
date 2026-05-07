-- ======================================================================
-- 121 - Amazon Warehouse Packing 
-- ======================================================================
-- Difficulty : Extreme Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/121-amazon-warehouse-packing
-- ======================================================================

/*
During a warehouse packaging process, items of various weights (1 kg to 5 kg) need to be packed sequentially into boxes. Each box can hold a maximum of 5 kg in total. The items are presented in a table according to their arrival order, and the goal is to pack them into boxes, keeping the order (based on id) while ensuring each box’s total weight does not exceed 5 kg.

 

**Requirements**:
1. Pack items into boxes in their given order based on id.
2. Each box should not exceed 5 kg in total weight.
3. Once a box reaches the 5 kg limit or would exceed it by adding the next item, start packing into a new box.
4. Assign a box number to each item based on its position in the sequence, so that items within each box do not exceed the 5 kg limit.

 

**Example**:
Given the items with weights `[1, 3, 5, 3, 2]`, we need to pack them into boxes as follows:

- **Box 1**: Items with weights `[1, 3]` — Total weight = 4 kg
- **Box 2**: Item with weight `[5]` — Total weight = 5 kg
- **Box 3**: Items with weights `[3, 2]` — Total weight = 5 kg

The result should display each item , weight and its assigned box number starting from 1.

 
Table: items 
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| id          | int       |
| weight      | int       |
+-------------+-----------+
*/


-- Write your SQL solution below:

```sql
WITH box_assignment AS (
  SELECT 
    id,
    weight,
    SUM(CASE 
      WHEN SUM(weight) OVER (ORDER BY id ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) + weight > 5 
      THEN 1 
      ELSE 0 
    END) OVER (ORDER BY id) + 1 AS box_number
  FROM items
)
SELECT 
  id,
  weight,
  box_number
FROM box_assignment
ORDER BY id;
```
