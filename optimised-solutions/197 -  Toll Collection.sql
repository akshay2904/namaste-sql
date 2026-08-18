-- ======================================================================
-- 197 -  Toll Collection
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Uber
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/197-toll-collection
-- ======================================================================

/*
You are given a table toll_log that records vehicle crossings at a toll plaza. Each row represents one crossing event. Write a SQL query to calculate the total toll amount collected per day for each vehicle type.
The output should contain: crossing_date , vehicle_type, total_amount. Sort the result by crossing_date , vehicle_type.

 

Toll pricing rules

Base Toll:

Motorcycle → 0

Car → 40

Bus → 70

Truck → 80

Return same day rule:

If the same vehicle crosses again same day , apply discounted toll:

Car → 20

Bus → 30

Truck → 40

Motorcycle → 0

 

If a vehicle crosses more than twice on the same day, the toll should alternate between full toll and discounted toll for each crossing.

Example:
If a vehicle crosses 3 times on the same day,
1st crossing → Full toll
2nd crossing → Discounted toll
3rd crossing → Full toll

 
Table: vehicles
+--------------+------------+
| COLUMN_NAME  | DATA_TYPE  |
+--------------+------------+
| id           | INT        |
| vehicle_no   | VARCHAR    |
| vehicle_type | VARCHAR    |
+--------------+------------+Table: toll_log
+--------------+------------+
| COLUMN_NAME  | DATA_TYPE  |
+--------------+------------+
| txn_id       | INT        |
| vehicle_id   | INT        |
| crossing_time| TIMESTAMP  |
+--------------+------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH crossing_ranked AS (
    -- Rank each crossing per vehicle per day
    SELECT
        tl.txn_id,
        tl.vehicle_id,
        v.vehicle_type,
        DATE(tl.crossing_time) AS crossing_date,
        ROW_NUMBER() OVER (
            PARTITION BY tl.vehicle_id, DATE(tl.crossing_time)
            ORDER BY tl.crossing_time
        ) AS crossing_rank
    FROM toll_log tl
    JOIN vehicles v ON v.id = tl.vehicle_id
),
toll_per_crossing AS (
    -- Apply full toll on odd crossings, discounted on even crossings
    SELECT
        crossing_date,
        vehicle_type,
        CASE
            WHEN crossing_rank % 2 = 1 THEN  -- odd → full toll
                CASE vehicle_type
                    WHEN 'Motorcycle' THEN 0
                    WHEN 'Car'        THEN 40
                    WHEN 'Bus'        THEN 70
                    WHEN 'Truck'      THEN 80
                    ELSE 0
                END
            ELSE  -- even → discounted toll
                CASE vehicle_type
                    WHEN 'Motorcycle' THEN 0
                    WHEN 'Car'        THEN 20
                    WHEN 'Bus'        THEN 30
                    WHEN 'Truck'      THEN 40
                    ELSE 0
                END
        END AS toll_amount
    FROM crossing_ranked
)
SELECT
    crossing_date,
    vehicle_type,
    SUM(toll_amount) AS total_amount
FROM toll_per_crossing
GROUP BY crossing_date, vehicle_type
ORDER BY crossing_date, vehicle_type;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    crossing_date,
    vehicle_type,
    SUM(toll_amount) AS total_amount
FROM (
    SELECT
        tl.txn_id,
        v.vehicle_type,
        DATE(tl.crossing_time) AS crossing_date,
        -- Determine rank via a correlated subquery (count earlier crossings same day)
        (
            SELECT COUNT(*)
            FROM toll_log tl2
            WHERE tl2.vehicle_id = tl.vehicle_id
              AND DATE(tl2.crossing_time) = DATE(tl.crossing_time)
              AND (
                  tl2.crossing_time < tl.crossing_time
                  OR (tl2.crossing_time = tl.crossing_time AND tl2.txn_id <= tl.txn_id)
              )
        ) AS crossing_rank,
        v.vehicle_type AS vt  -- alias reuse for CASE below
    FROM toll_log tl
    JOIN vehicles v ON v.id = tl.vehicle_id
) ranked
CROSS JOIN LATERAL (
    -- Compute toll based on whether rank is odd (full) or even (discounted)
    SELECT
        CASE
            WHEN crossing_rank % 2 = 1 THEN
                CASE vehicle_type
                    WHEN 'Motorcycle' THEN 0
                    WHEN 'Car'        THEN 40
                    WHEN 'Bus'        THEN 70
                    WHEN 'Truck'      THEN 80
                    ELSE 0
                END
            ELSE
                CASE vehicle_type
                    WHEN 'Motorcycle' THEN 0
                    WHEN 'Car'        THEN 20
                    WHEN 'Bus'        THEN 30
                    WHEN 'Truck'      THEN 40
                    ELSE 0
                END
        END AS toll_amount
) toll_calc
GROUP BY crossing_date, vehicle_type
ORDER BY crossing_date, vehicle_type;
