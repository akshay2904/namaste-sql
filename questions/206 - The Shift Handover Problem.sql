-- ======================================================================
-- 206 - The Shift Handover Problem
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Doordash
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/206-the-shift-handover-problem
-- ======================================================================

/*
You work at a 24/7 logistics company that operates in shifts. Each shift has an opening stock count and a closing stock count for a warehouse. The closing stock of one shift should match the opening stock of the next shift. When they don't match, it indicates a handover discrepancy — stock went missing or was incorrectly recorded during the shift change.

The operations team wants to identify all discrepancies, understand their impact, and flag the worst handover per warehouse.

---

Table: shifts
One row per shift at a warehouse.
+-------------------+-----------+
| COLUMN_NAME       | DATA_TYPE |
+-------------------+-----------+
| shift_id          | INT       |
| warehouse_id      | INT       |
| shift_start       | DATETIME  |
| shift_end         | DATETIME  |
| opening_stock     | INT       |
| closing_stock     | INT       |
+-------------------+-----------+
---

The Ask

Find all handover discrepancies and return one row per discrepancy:

- `warehouse_id`
- `outgoing_shift_id` — the shift that closed
- `incoming_shift_id` — the shift that opened next
- `closing_stock` — closing stock of outgoing shift
- `opening_stock` — opening stock of incoming shift
- `discrepancy` — difference (`opening_stock - closing_stock`), negative means stock missing
- `gap_minutes` — minutes between shift_end and next shift_start
- `discrepancy_type` — `'shortage'` if discrepancy < 0, `'surplus'` if discrepancy > 0
- `is_worst_handover` — `'Y'` if this is the largest absolute discrepancy in the warehouse, `'N'` otherwise

Constraints & Traps:

> - Only compare shifts **consecutive** within the same warehouse
> - Skip terminal shifts (no next shift)
> - Skip clean handovers (`closing_stock = opening_stock`)
> - `gap_minutes` can be 0 or positive
*/


-- Write your SQL solution below:

```sql
WITH numbered_shifts AS (
  -- Add row number partitioned by warehouse ordered by shift_end to identify consecutive shifts
  SELECT 
    shift_id,
    warehouse_id,
    shift_start,
    shift_end,
    opening_stock,
    closing_stock,
    ROW_NUMBER() OVER (PARTITION BY warehouse_id ORDER BY shift_end) AS shift_order,
    LEAD(shift_id) OVER (PARTITION BY warehouse_id ORDER BY shift_end) AS next_shift_id,
    LEAD(shift_start) OVER (PARTITION BY warehouse_id ORDER BY shift_end) AS next_shift_start,
    LEAD(opening_stock) OVER (PARTITION BY warehouse_id ORDER BY shift_end) AS next_opening_stock
  FROM shifts
),
handover_pairs AS (
  -- Join consecutive shifts to identify discrepancies
  SELECT 
    warehouse_id,
    shift_id AS outgoing_shift_id,
    next_shift_id AS incoming_shift_id,
    closing_stock,
    next_opening_stock AS opening_stock,
    next_opening_stock - closing_stock AS discrepancy,
    EXTRACT(EPOCH FROM (next_shift_start - shift_end)) / 60 AS gap_minutes,
    CASE 
      WHEN next_opening_stock - closing_stock < 0 THEN 'shortage'
      WHEN next_opening_stock - closing_stock > 0 THEN 'surplus'
    END AS discrepancy_type
  FROM numbered_shifts
  WHERE next_shift_id IS NOT NULL -- Skip terminal shifts
    AND closing_stock != next_opening_stock -- Skip clean handovers
),
ranked_discrepancies AS (
  -- Rank discrepancies by absolute value within each warehouse
  SELECT 
    *,
    ROW_NUMBER() OVER (PARTITION BY warehouse_id ORDER BY ABS(discrepancy) DESC) AS discrepancy_rank
  FROM handover_pairs
)
SELECT 
  warehouse_id,
  outgoing_shift_id,
  incoming_shift_id,
  closing_stock,
  opening_stock,
  discrepancy,
  gap_minutes,
  discrepancy_type,
  CASE WHEN discrepancy_rank = 1 THEN 'Y' ELSE 'N' END AS is_worst_handover
FROM ranked_discrepancies
ORDER BY warehouse_id, outgoing_shift_id;
```
