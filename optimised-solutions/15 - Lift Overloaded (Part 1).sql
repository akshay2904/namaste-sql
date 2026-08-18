-- ======================================================================
-- 15 - Lift Overloaded (Part 1)
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Meta
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/15-lift-overloaded-part-1
-- ======================================================================

/*
You are given a table of list of lifts , their maximum capacity and people along with their weight who wants to enter into it. You need to make sure maximum people enter into the lift without lift getting overloaded.

For each lift find the comma separated list of people who can be accommodated. The comma separated list should have people in the order of their weight in increasing order, display the output in increasing order of id.

 
Table: lifts
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| capacity_kg | int       |
| id          | int       |
+-------------+-----------+Table: lift_passengers
+----------------+-------------+
| COLUMN_NAME    | DATA_TYPE   |
+----------------+-------------+
| passenger_name | varchar(10) |
| weight_kg      | int         |
| lift_id        | int         |
+----------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_passengers AS (
    -- Rank passengers by weight within each lift (lightest first = greedy optimal)
    SELECT
        lp.lift_id,
        lp.passenger_name,
        lp.weight_kg,
        SUM(lp.weight_kg) OVER (
            PARTITION BY lp.lift_id
            ORDER BY lp.weight_kg, lp.passenger_name  -- tie-break by name for determinism
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_weight
    FROM lift_passengers lp
),
filtered AS (
    -- Keep only passengers whose cumulative weight fits within capacity
    SELECT
        rp.lift_id,
        rp.passenger_name,
        rp.weight_kg
    FROM ranked_passengers rp
    JOIN lifts l ON l.id = rp.lift_id
    WHERE rp.cumulative_weight <= l.capacity_kg
)
SELECT
    l.id AS lift_id,
    STRING_AGG(f.passenger_name, ',' ORDER BY f.weight_kg, f.passenger_name) AS passengers
FROM lifts l
LEFT JOIN filtered f ON f.lift_id = l.id
GROUP BY l.id
ORDER BY l.id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    l.id AS lift_id,
    STRING_AGG(lp.passenger_name, ',' ORDER BY lp.weight_kg, lp.passenger_name) AS passengers
FROM lifts l
LEFT JOIN lift_passengers lp
    ON lp.lift_id = l.id
    -- Include passenger only if the total weight of all passengers
    -- who are lighter (or same weight but earlier alphabetically) <= capacity
    AND (
        SELECT COALESCE(SUM(lp2.weight_kg), 0)
        FROM lift_passengers lp2
        WHERE lp2.lift_id = l.id
          AND (
              lp2.weight_kg < lp.weight_kg
              OR (lp2.weight_kg = lp.weight_kg AND lp2.passenger_name <= lp.passenger_name)
          )
    ) <= l.capacity_kg
GROUP BY l.id
ORDER BY l.id;
