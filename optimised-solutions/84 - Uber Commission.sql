-- ======================================================================
-- 84 - Uber Commission
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Uber
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/84-uber-commission
-- ======================================================================

/*
In a bustling city, Uber operates a fleet of drivers who provide transportation services to passengers. As part of Uber's policy, drivers are subject to a commission deduction from their total earnings. The commission rate is determined based on the average rating received by the driver over their recent trips. This ensures that drivers delivering exceptional service are rewarded with lower commission rates, while those with lower ratings are subject to higher commission rates. 

Commission Calculation: For the first 3 trips of each driver, a standard commission rate of 24% is applied.
After the first 3 trips, the commission rate is determined based on the average rating of the driver's last 3 trips before the current trip:
If the average rating is between 4.7 and 5 (inclusive), the commission rate is 20%.
If the average rating is between 4.5 and 4.7 (inclusive), the commission rate is 23%.
For any other average rating, the default commission rate remains at 24%.

Write an SQL query to calculate the total earnings for each driver after deducting Uber's commission, considering the commission rates as per the given criteria, display the output in ascending order of driver id.

 

Table: trips 
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| trip_id     | int          |
| driver_id   | int          |
| fare        | int          |
| rating      | decimal(3,2) |
+-------------+--------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH trip_numbered AS (
    -- Assign row number per driver ordered by trip_id
    SELECT
        trip_id,
        driver_id,
        fare,
        rating,
        ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY trip_id) AS trip_num
    FROM trips
),
trip_with_avg AS (
    SELECT
        t.trip_id,
        t.driver_id,
        t.fare,
        t.trip_num,
        -- Average rating of the last 3 trips BEFORE the current trip
        AVG(prev.rating) OVER (
            PARTITION BY t.driver_id
            ORDER BY t.trip_num
            ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING
        ) AS avg_last3_rating
    FROM trip_numbered t
),
trip_with_commission AS (
    SELECT
        driver_id,
        fare,
        trip_num,
        avg_last3_rating,
        CASE
            -- First 3 trips: standard 24% commission
            WHEN trip_num <= 3 THEN 0.24
            -- After first 3 trips, based on avg of last 3 trips
            WHEN avg_last3_rating >= 4.7 AND avg_last3_rating <= 5.0 THEN 0.20
            WHEN avg_last3_rating >= 4.5 AND avg_last3_rating <  4.7 THEN 0.23
            ELSE 0.24
        END AS commission_rate
    FROM trip_with_avg
)
SELECT
    driver_id,
    ROUND(SUM(fare * (1 - commission_rate)), 2) AS total_earnings
FROM trip_with_commission
GROUP BY driver_id
ORDER BY driver_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH trip_numbered AS (
    -- Assign sequential trip number per driver
    SELECT
        t1.trip_id,
        t1.driver_id,
        t1.fare,
        t1.rating,
        COUNT(t2.trip_id) + 1 AS trip_num
    FROM trips t1
    LEFT JOIN trips t2
        ON t1.driver_id = t2.driver_id
        AND t2.trip_id < t1.trip_id
    GROUP BY t1.trip_id, t1.driver_id, t1.fare, t1.rating
),
trip_with_prev_avg AS (
    SELECT
        t.trip_id,
        t.driver_id,
        t.fare,
        t.trip_num,
        -- Subquery to get avg rating of up to 3 trips immediately before current
        (
            SELECT AVG(p.rating)
            FROM trip_numbered p
            WHERE p.driver_id = t.driver_id
              AND p.trip_num < t.trip_num
              AND p.trip_num >= t.trip_num - 3
        ) AS avg_last3_rating
    FROM trip_numbered t
),
trip_with_commission AS (
    SELECT
        driver_id,
        fare,
        trip_num,
        avg_last3_rating,
        CASE
            WHEN trip_num <= 3 THEN 0.24
            WHEN avg_last3_rating >= 4.7 AND avg_last3_rating <= 5.0 THEN 0.20
            WHEN avg_last3_rating >= 4.5 AND avg_last3_rating <  4.7 THEN 0.23
            ELSE 0.24
        END AS commission_rate
    FROM trip_with_prev_avg
)
SELECT
    driver_id,
    ROUND(SUM(fare * (1 - commission_rate)), 2) AS total_earnings
FROM trip_with_commission
GROUP BY driver_id
ORDER BY driver_id;
