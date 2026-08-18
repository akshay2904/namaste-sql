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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ordered_items AS (
    SELECT
        id,
        weight,
        -- Running sum of weights in arrival order
        SUM(weight) OVER (ORDER BY id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
    FROM items
),
box_boundaries AS (
    SELECT
        id,
        weight,
        running_total,
        -- Determine how many complete "5 kg buckets" have been filled before this item
        -- by looking at (running_total - weight) to get sum before current item
        -- We use integer division: floor((running_total - 1) / 5) gives 0-based box index
        -- But this only works when items are exactly fitting; instead we need a gap-based approach.
        -- 
        -- Key insight: a new box starts whenever adding the current item would cross a 5kg boundary
        -- relative to the previous item's running total.
        -- Mark start of a new box: when floor((prev_running - 0) / 5) < floor((running_total) / 5)
        -- Actually: box changes when current item doesn't fit in the current box.
        -- We detect: prev_running mod 5 + weight > 5 OR prev_running mod 5 = 0 (new box already)
        -- 
        -- Simpler: box number = 1 + number of times a "box reset" happened before current row
        -- A reset happens at row i if (running_total_i-1 mod 5) + weight_i > 5
        -- i.e., the space left in current box < weight of current item
        CASE
            WHEN (LAG(running_total, 1, 0) OVER (ORDER BY id)) % 5 + weight > 5
              OR (LAG(running_total, 1, 0) OVER (ORDER BY id)) % 5 = 0
                 AND LAG(running_total, 1, 0) OVER (ORDER BY id) > 0
            THEN 1
            ELSE 0
        END AS new_box_flag
    FROM ordered_items
),
-- Recompute properly: new box starts when remaining capacity in current box < item weight
flagged AS (
    SELECT
        id,
        weight,
        running_total,
        -- remaining capacity before placing this item = 5 - (prev_running_total mod 5), unless prev mod 5 = 0
        -- new box if: prev_running mod 5 != 0 AND (5 - prev_running mod 5) < weight  => doesn't fit
        -- OR prev_running mod 5 = 0 AND prev_running > 0                              => previous box just filled exactly
        CASE
            WHEN LAG(running_total, 1, 0) OVER (ORDER BY id) = 0 THEN 0  -- first item, no new box flag
            WHEN (5 - (LAG(running_total, 1, 0) OVER (ORDER BY id) % 5)) % 5 = 0 THEN 1  -- prev box exactly full
            WHEN (5 - (LAG(running_total, 1, 0) OVER (ORDER BY id) % 5)) < weight THEN 1  -- doesn't fit
            ELSE 0
        END AS new_box_flag
    FROM ordered_items
)
SELECT
    id,
    weight,
    SUM(new_box_flag) OVER (ORDER BY id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) + 1 AS box_number
FROM flagged
ORDER BY id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (recursive CTE to simulate sequential bin-packing)
-- ============================================================

WITH RECURSIVE
item_sequence AS (
    -- Number items sequentially to allow recursive stepping
    SELECT
        id,
        weight,
        ROW_NUMBER() OVER (ORDER BY id) AS rn
    FROM items
),
packing AS (
    -- Base case: first item goes into box 1
    SELECT
        rn,
        id,
        weight,
        1           AS box_number,
        weight      AS box_current_weight
    FROM item_sequence
    WHERE rn = 1

    UNION ALL

    -- Recursive case: process each subsequent item
    SELECT
        i.rn,
        i.id,
        i.weight,
        CASE
            -- If current item fits in the current box, keep same box number
            WHEN p.box_current_weight + i.weight <= 5 THEN p.box_number
            -- Otherwise, start a new box
            ELSE p.box_number + 1
        END AS box_number,
        CASE
            WHEN p.box_current_weight + i.weight <= 5 THEN p.box_current_weight + i.weight
            ELSE i.weight
        END AS box_current_weight
    FROM packing p
    JOIN item_sequence i ON i.rn = p.rn + 1
)
SELECT
    id,
    weight,
    box_number
FROM packing
ORDER BY id;
