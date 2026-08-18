-- ======================================================================
-- 63 - Prime Subscription
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/63-prime-subscription
-- ======================================================================

/*
Amazon, the world's largest online retailer, offers various services to its customers, including Amazon Prime membership, Video streaming, Amazon Music, Amazon Pay, and more. The company is interested in analyzing which of its services are most effective at converting regular customers into Amazon Prime members.
You are given a table of events which consists services accessed by each users along with service access date. This table also contains the event when customer bought the prime membership (type='prime').

 

Write an SQL to get date when each customer became prime member, last service used and last service access date (just before becoming prime member). If a customer never became prime member, then populate only the last service used and last service access date by the customer, display the output in ascending order of last service access date.

 
Table: users
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| name        | varchar(15) |
| user_id     | int         |
+-------------+-------------+Table : events
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| user_id     | int         |
| type        | varchar(15) |
| access_date | date        |
+-------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH prime_dates AS (
    -- Get the date each user became a prime member
    SELECT user_id, MIN(access_date) AS prime_date
    FROM events
    WHERE type = 'prime'
    GROUP BY user_id
),
last_service_before_prime AS (
    -- For each user, get the last non-prime service used before (or without) prime membership
    SELECT
        e.user_id,
        e.type AS last_service,
        e.access_date AS last_service_date,
        ROW_NUMBER() OVER (
            PARTITION BY e.user_id
            ORDER BY e.access_date DESC
        ) AS rn
    FROM events e
    LEFT JOIN prime_dates pd ON e.user_id = pd.user_id
    WHERE e.type != 'prime'
      AND (pd.prime_date IS NULL OR e.access_date < pd.prime_date)
)
SELECT
    u.name,
    u.user_id,
    pd.prime_date,
    ls.last_service,
    ls.last_service_date
FROM users u
LEFT JOIN prime_dates pd ON u.user_id = pd.user_id
LEFT JOIN last_service_before_prime ls
    ON u.user_id = ls.user_id AND ls.rn = 1
ORDER BY ls.last_service_date ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH prime_dates AS (
    -- Get the date each user became a prime member
    SELECT user_id, MIN(access_date) AS prime_date
    FROM events
    WHERE type = 'prime'
    GROUP BY user_id
),
last_service_date_per_user AS (
    -- For each user, find the MAX service date before becoming prime (or ever if no prime)
    SELECT
        e.user_id,
        MAX(e.access_date) AS last_service_date
    FROM events e
    LEFT JOIN prime_dates pd ON e.user_id = pd.user_id
    WHERE e.type != 'prime'
      AND (pd.prime_date IS NULL OR e.access_date < pd.prime_date)
    GROUP BY e.user_id
),
last_service_per_user AS (
    -- Match back to get the service type on that last date
    SELECT
        e.user_id,
        e.type AS last_service,
        e.access_date AS last_service_date
    FROM events e
    INNER JOIN last_service_date_per_user ls
        ON e.user_id = ls.user_id
       AND e.access_date = ls.last_service_date
    WHERE e.type != 'prime'
    -- In case of tie (same date, multiple services), pick one deterministically
    GROUP BY e.user_id, e.type, e.access_date
    HAVING e.type = MIN(e.type)  -- deterministic tie-break by alphabetical order
)
SELECT
    u.name,
    u.user_id,
    pd.prime_date,
    ls.last_service,
    ls.last_service_date
FROM users u
LEFT JOIN prime_dates pd ON u.user_id = pd.user_id
LEFT JOIN last_service_per_user ls ON u.user_id = ls.user_id
ORDER BY ls.last_service_date ASC;
