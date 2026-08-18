-- ======================================================================
-- 65 - Service Downtime
-- ======================================================================
-- Difficulty : Extreme Hard
-- Category   : Analytics
-- Companies  : Microsoft
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/65-service-downtime
-- ======================================================================

/*
You are a DevOps engineer responsible for monitoring the health and status of various services in your organization's infrastructure. Your team conducts canary tests on each service every minute to ensure their reliability and performance. As part of your responsibilities, you need to develop a SQL to identify any service that experiences continuous downtime for at least 5 minutes so that team can find the root cause and fix the issue. Display the output in descending order of service down minutes.

 
Table:service_status 
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| service_name | varchar(4) |
| status       | varchar(4)  |
| updated_time | datetime    |
+--------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    -- Assign row number per service ordered by time
    SELECT
        service_name,
        status,
        updated_time,
        ROW_NUMBER() OVER (PARTITION BY service_name ORDER BY updated_time) AS rn
    FROM service_status
),
grouped AS (
    -- Classic gaps-and-islands: subtract row number from time-based rank
    -- to identify consecutive blocks of same status per service
    SELECT
        service_name,
        status,
        updated_time,
        rn,
        ROW_NUMBER() OVER (PARTITION BY service_name, status ORDER BY updated_time) AS status_rn,
        rn - ROW_NUMBER() OVER (PARTITION BY service_name, status ORDER BY updated_time) AS grp
    FROM ranked
),
downtime_blocks AS (
    -- Aggregate each consecutive 'down' block
    SELECT
        service_name,
        grp,
        MIN(updated_time) AS down_start,
        MAX(updated_time) AS down_end,
        COUNT(*)          AS consecutive_down_minutes
    FROM grouped
    WHERE status = 'down'
    GROUP BY service_name, grp
    HAVING COUNT(*) >= 5   -- at least 5 continuous minutes
)
SELECT
    service_name,
    SUM(consecutive_down_minutes) AS service_down_minutes
FROM downtime_blocks
GROUP BY service_name
ORDER BY service_down_minutes DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    d.service_name,
    COUNT(*) AS service_down_minutes
FROM service_status d
WHERE d.status = 'down'
  AND (
      -- Count how many consecutive 'down' rows exist starting from this row
      -- by checking that the next 4 minutes are also 'down' for the same service
      SELECT COUNT(*)
      FROM service_status d2
      WHERE d2.service_name = d.service_name
        AND d2.status       = 'down'
        AND d2.updated_time >= d.updated_time
        AND d2.updated_time <  d.updated_time + INTERVAL '5 minutes'
  ) >= 5  -- this row is part of a block with at least 5 down minutes ahead
  AND (
      -- Ensure we only count rows that are part of a qualifying streak
      -- by verifying the row belongs to a window of 5 consecutive down minutes
      SELECT COUNT(*)
      FROM service_status d3
      WHERE d3.service_name = d.service_name
        AND d3.status       = 'down'
        AND d3.updated_time <= d.updated_time
        AND d3.updated_time >  d.updated_time - INTERVAL '5 minutes'
  ) >= 1
GROUP BY d.service_name
HAVING
    -- Confirm there is at least one 5-minute consecutive down window
    EXISTS (
        SELECT 1
        FROM service_status s1
        WHERE s1.service_name = d.service_name
          AND s1.status       = 'down'
          AND (
              SELECT COUNT(*)
              FROM service_status s2
              WHERE s2.service_name = s1.service_name
                AND s2.status       = 'down'
                AND s2.updated_time >= s1.updated_time
                AND s2.updated_time <  s1.updated_time + INTERVAL '5 minutes'
          ) >= 5
    )
ORDER BY service_down_minutes DESC;
