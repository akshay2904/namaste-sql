-- ======================================================================
-- 16 - Lift Overloaded (Part 2)
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Meta
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/16-lift-overloaded-part-2
-- ======================================================================

/*
You are given a table of list of lifts , their maximum capacity and people along with their weight and gender who wants to enter into it. You need to make sure maximum people enter into the lift without lift getting overloaded but you need to give preference to female passengers first.

For each lift find the comma separated list of people who can be accomodated. The comma separated list should have female first and then people in the order of their weight in increasing order, display the output in increasing order of id.

 
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
| gender         | varchar(1)  |
| lift_id        | int         |
+----------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_passengers AS (
    -- Rank passengers: females first (F < M alphabetically reversed, so use CASE),
    -- then by weight ascending within each lift
    SELECT
        lp.lift_id,
        lp.passenger_name,
        lp.weight_kg,
        lp.gender,
        -- Priority: females first (1), then males (2), then by weight
        ROW_NUMBER() OVER (
            PARTITION BY lp.lift_id
            ORDER BY
                CASE WHEN lp.gender = 'F' THEN 0 ELSE 1 END,
                lp.weight_kg
        ) AS rn
    FROM lift_passengers lp
),
cumulative_weights AS (
    -- Calculate running total of weight in priority order
    SELECT
        rp.lift_id,
        rp.passenger_name,
        rp.weight_kg,
        rp.gender,
        rp.rn,
        SUM(rp.weight_kg) OVER (
            PARTITION BY rp.lift_id
            ORDER BY rp.rn
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_weight
    FROM ranked_passengers rp
),
admitted AS (
    -- Keep only passengers whose cumulative weight doesn't exceed capacity
    SELECT
        cw.lift_id,
        cw.passenger_name,
        cw.weight_kg,
        cw.gender,
        cw.rn,
        cw.cumulative_weight
    FROM cumulative_weights cw
    JOIN lifts l ON l.id = cw.lift_id
    WHERE cw.cumulative_weight <= l.capacity_kg
)
SELECT
    l.id AS lift_id,
    STRING_AGG(a.passenger_name, ',' ORDER BY a.rn) AS passengers
FROM lifts l
LEFT JOIN admitted a ON a.lift_id = l.id
GROUP BY l.id
ORDER BY l.id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH ordered_passengers AS (
    -- Assign an explicit order: females first, then by weight
    SELECT
        lp.lift_id,
        lp.passenger_name,
        lp.weight_kg,
        lp.gender,
        -- Use a sequential row number via subquery count
        (
            SELECT COUNT(*)
            FROM lift_passengers lp2
            WHERE lp2.lift_id = lp.lift_id
              AND (
                    -- lp2 comes before lp in priority order
                    (CASE WHEN lp2.gender = 'F' THEN 0 ELSE 1 END) <
                    (CASE WHEN lp.gender  = 'F' THEN 0 ELSE 1 END)
                    OR
                    (
                      (CASE WHEN lp2.gender = 'F' THEN 0 ELSE 1 END) =
                      (CASE WHEN lp.gender  = 'F' THEN 0 ELSE 1 END)
                      AND lp2.weight_kg < lp.weight_kg
                    )
                    OR
                    (
                      (CASE WHEN lp2.gender = 'F' THEN 0 ELSE 1 END) =
                      (CASE WHEN lp.gender  = 'F' THEN 0 ELSE 1 END)
                      AND lp2.weight_kg = lp.weight_kg
                      AND lp2.passenger_name < lp.passenger_name  -- tiebreak by name
                    )
              )
        ) + 1 AS priority_rank
    FROM lift_passengers lp
),
cumulative_weights AS (
    -- For each passenger, sum weights of all passengers with equal or higher priority
    SELECT
        op.lift_id,
        op.passenger_name,
        op.weight_kg,
        op.gender,
        op.priority_rank,
        (
            SELECT SUM(op2.weight_kg)
            FROM ordered_passengers op2
            WHERE op2.lift_id = op.lift_id
              AND op2.priority_rank <= op.priority_rank
        ) AS cumulative_weight
    FROM ordered_passengers op
)
SELECT
    l.id AS lift_id,
    STRING_AGG(cw.passenger_name, ',' ORDER BY cw.priority_rank) AS passengers
FROM lifts l
LEFT JOIN cumulative_weights cw
    ON cw.lift_id = l.id
   AND cw.cumulative_weight <= l.capacity_kg
GROUP BY l.id
ORDER BY l.id;
