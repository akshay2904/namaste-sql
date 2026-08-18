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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH shift_pairs AS (
    SELECT
        s.warehouse_id,
        s.shift_id                                              AS outgoing_shift_id,
        LEAD(s.shift_id)    OVER w                             AS incoming_shift_id,
        s.closing_stock,
        LEAD(s.opening_stock) OVER w                           AS next_opening_stock,
        LEAD(s.shift_start)   OVER w                           AS next_shift_start,
        s.shift_end
    FROM shifts s
    WINDOW w AS (PARTITION BY s.warehouse_id ORDER BY s.shift_start)
),
discrepancies AS (
    SELECT
        warehouse_id,
        outgoing_shift_id,
        incoming_shift_id,
        closing_stock,
        next_opening_stock                                      AS opening_stock,
        (next_opening_stock - closing_stock)                   AS discrepancy,
        EXTRACT(EPOCH FROM (next_shift_start - shift_end)) / 60 AS gap_minutes
    FROM shift_pairs
    WHERE incoming_shift_id IS NOT NULL                        -- skip terminal shifts
      AND next_opening_stock <> closing_stock                  -- skip clean handovers
),
ranked AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY warehouse_id
            ORDER BY ABS(discrepancy) DESC
        )                                                       AS rnk
    FROM discrepancies
)
SELECT
    warehouse_id,
    outgoing_shift_id,
    incoming_shift_id,
    closing_stock,
    opening_stock,
    discrepancy,
    gap_minutes,
    CASE WHEN discrepancy < 0 THEN 'shortage' ELSE 'surplus' END AS discrepancy_type,
    CASE WHEN rnk = 1        THEN 'Y'         ELSE 'N'       END AS is_worst_handover
FROM ranked
ORDER BY warehouse_id, outgoing_shift_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Step 1: For each shift, find the very next shift in the same warehouse
--         by picking the incoming shift whose start time is the minimum
--         start time that is still >= the outgoing shift's end time.
SELECT
    out_s.warehouse_id,
    out_s.shift_id                                                   AS outgoing_shift_id,
    in_s.shift_id                                                    AS incoming_shift_id,
    out_s.closing_stock,
    in_s.opening_stock,
    (in_s.opening_stock - out_s.closing_stock)                       AS discrepancy,
    EXTRACT(EPOCH FROM (in_s.shift_start - out_s.shift_end)) / 60    AS gap_minutes,
    CASE
        WHEN (in_s.opening_stock - out_s.closing_stock) < 0 THEN 'shortage'
        ELSE 'surplus'
    END                                                              AS discrepancy_type,
    -- flag worst: abs discrepancy equals the max abs discrepancy for that warehouse
    CASE
        WHEN ABS(in_s.opening_stock - out_s.closing_stock) = (
            -- subquery: max abs discrepancy in this warehouse (dirty handovers only)
            SELECT MAX(ABS(in2.opening_stock - out2.closing_stock))
            FROM shifts out2
            JOIN shifts in2
              ON in2.warehouse_id  = out2.warehouse_id
             AND in2.shift_start   = (
                 -- same consecutive-next logic repeated for the subquery
                 SELECT MIN(in3.shift_start)
                 FROM shifts in3
                 WHERE in3.warehouse_id = out2.warehouse_id
                   AND in3.shift_start  > out2.shift_start  -- next shift starts after current one starts
             )
            WHERE out2.warehouse_id = out_s.warehouse_id
              AND in2.opening_stock <> out2.closing_stock   -- only dirty handovers
        ) THEN 'Y'
        ELSE 'N'
    END                                                              AS is_worst_handover
FROM shifts out_s
JOIN shifts in_s
  ON in_s.warehouse_id = out_s.warehouse_id
 -- incoming shift is the one with the earliest start after the outgoing shift's start
 AND in_s.shift_start  = (
     SELECT MIN(nxt.shift_start)
     FROM shifts nxt
     WHERE nxt.warehouse_id = out_s.warehouse_id
       AND nxt.shift_start  > out_s.shift_start
 )
WHERE in_s.opening_stock <> out_s.closing_stock              -- skip clean handovers
ORDER BY out_s.warehouse_id, out_s.shift_id;
