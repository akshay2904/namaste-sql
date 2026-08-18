-- ======================================================================
-- 129 - Uber Active Drivers
-- ======================================================================
-- Difficulty : Extreme Hard
-- Category   : Analytics
-- Companies  : Uber
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/129-uber-active-drivers
-- ======================================================================

/*
We have a driver table which has driver id and join date for each Uber drivers. We have another table rides where we have ride id, ride date and driver id.  A driver becomes inactive if he doesn't have any ride for consecutive 28 days after joining the company. Driver can become active again once he takes a new ride. We need to find number of active drivers for uber at the end of each month for year 2023.

For example if a driver joins Uber on Jan 15th and takes his first ride on March 15th. He will be considered active for Jan month end , Not active for Feb month end but active for March month end.
Table: drivers 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| driver_id     | int      |
| join_date     | date     |
+-------------+------------+Table: rides 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| ride_id       | int      |
| ride_date     | date     |
| driver_id     | date     |
+-------------+------------+Table: calendar_dim (Contains all dates of 2023) 
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| cal_date      | date     |
+-------------+------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH month_ends AS (
    -- Get last day of each month in 2023
    SELECT MAX(cal_date) AS month_end_date
    FROM calendar_dim
    WHERE EXTRACT(YEAR FROM cal_date) = 2023
    GROUP BY EXTRACT(YEAR FROM cal_date), EXTRACT(MONTH FROM cal_date)
),

driver_ride_windows AS (
    -- For each driver and each ride, calculate the next ride date using LEAD
    -- This gives us the "active window" between consecutive rides
    SELECT
        driver_id,
        ride_date AS window_start,
        LEAD(ride_date) OVER (PARTITION BY driver_id ORDER BY ride_date) AS next_ride_date
    FROM rides
),

driver_status_per_month AS (
    SELECT
        me.month_end_date,
        d.driver_id,
        -- A driver is active at month end if:
        -- 1) They joined on or before the month end date AND
        -- 2) Either:
        --    a) They took a ride within 28 days before/on month end (last ride was recent), OR
        --    b) They just joined and have 28 days grace period still active
        CASE
            WHEN d.join_date > me.month_end_date THEN 0  -- Hasn't joined yet
            WHEN (me.month_end_date - d.join_date) <= 28 THEN 1  -- Within 28-day grace period after joining (active)
            ELSE
                -- Check if driver has any ride such that:
                -- The ride occurred on or before month_end_date AND
                -- (next ride is null OR next ride > month_end_date) AND
                -- ride_date is within 28 days of month_end_date
                -- OR: ride_date <= month_end_date and month_end_date < ride_date + 28
                CASE WHEN EXISTS (
                    SELECT 1
                    FROM rides r
                    WHERE r.driver_id = d.driver_id
                      AND r.ride_date <= me.month_end_date
                      AND (me.month_end_date - r.ride_date) < 28
                ) THEN 1
                ELSE 0
                END
        END AS is_active
    FROM month_ends me
    CROSS JOIN drivers d
)

SELECT
    month_end_date,
    SUM(is_active) AS active_drivers
FROM driver_status_per_month
GROUP BY month_end_date
ORDER BY month_end_date;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    me.month_end_date,
    COUNT(DISTINCT d.driver_id) AS active_drivers
FROM (
    -- Get last day of each month in 2023
    SELECT MAX(cal_date) AS month_end_date
    FROM calendar_dim
    WHERE EXTRACT(YEAR FROM cal_date) = 2023
    GROUP BY EXTRACT(YEAR FROM cal_date), EXTRACT(MONTH FROM cal_date)
) me
CROSS JOIN drivers d
WHERE
    -- Driver must have joined on or before month end
    d.join_date <= me.month_end_date
    AND (
        -- Condition 1: Driver joined within last 28 days (grace period) — still active
        (me.month_end_date - d.join_date) <= 28
        OR
        -- Condition 2: Driver has at least one ride within 28 days before (exclusive) of month end
        -- i.e., most recent ride before month_end is less than 28 days ago
        EXISTS (
            SELECT 1
            FROM rides r
            WHERE r.driver_id = d.driver_id
              AND r.ride_date <= me.month_end_date
              AND (me.month_end_date - r.ride_date) < 28
        )
    )
GROUP BY me.month_end_date
ORDER BY me.month_end_date;
