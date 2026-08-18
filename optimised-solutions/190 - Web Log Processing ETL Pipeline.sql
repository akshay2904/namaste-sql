-- ======================================================================
-- 190 - Web Log Processing ETL Pipeline
-- ======================================================================
-- Difficulty : Hard
-- Category   : ETL & Data Pipelines
-- Companies  : Practice question
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/190-web-log-processing-etl-pipeline
-- ======================================================================

/*
A company collects website activity logs from multiple device types. You are provided two datasets:

web_logs.csv – raw website activity
ip_address, url, event_timestamp, response_code, device_type

 

users.csv – mapping of IP addresses to registered users
ip_address, user_id

 

Your goal is to build an ETL pipeline that cleans the log data, identifies user sessions, and computes session-level metrics.

 

Perform the following operations to achieve the same:

1.Extract
Read both CSV files into DataFrames.
2.Transform

A. Data Cleaning
• Convert event_timestamp column to timestamp datatype
• Remove duplicate log entries (same ip_address, url, event_timestamp)
• Keep only valid response codes: 200, 301, 302, 404
• Drop all rows with other response codes
B. User Mapping
Join the logs with the users on ip_address to attach user_id to each log.
If an IP does not exist in users.csv, keep user_id as null (anonymous user).
C. Session Identification
A new session begins whenever a user has no activity for more than 30 minutes irrespective of device type.
Steps:
• Sort logs by user_id and event_timestamp
• For each user, compare the timestamp of the current log with the previous log
• If the time gap is greater than 30 minutes, start a new session
• Assign a session_id that restarts from 1 for each user.
For example, a user may have session_id values 1, 2, 3 based on their activity pattern.
D. Session Metrics
For each user session, compute:
session_start_time = minimum event_timestamp
session_end_time = maximum event_timestamp
session_duration = difference between end and start in seconds
total_events = number of log entries in the session
unique_pages_visited = distinct url count in the session
device_type = first device used in that session (based on earliest event_timestamp within the session)
3.Output
Print the final session-level DataFrame with the following columns in this order:
user_id
session_id
session_start_time
session_end_time
session_duration
total_events
unique_pages_visited
device_type
Sort the final output by user_id and session_id.
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH cleaned_logs AS (
    -- Step A: Data Cleaning
    SELECT DISTINCT
        ip_address,
        url,
        event_timestamp::timestamp AS event_timestamp,
        response_code,
        device_type
    FROM web_logs
    WHERE response_code IN (200, 301, 302, 404)
),

user_mapped AS (
    -- Step B: User Mapping (left join to keep anonymous users)
    SELECT
        cl.ip_address,
        cl.url,
        cl.event_timestamp,
        cl.response_code,
        cl.device_type,
        u.user_id
    FROM cleaned_logs cl
    LEFT JOIN users u ON cl.ip_address = u.ip_address
),

session_flags AS (
    -- Step C: Session Identification
    -- Compare each event's timestamp with the previous event per user
    SELECT
        ip_address,
        url,
        event_timestamp,
        response_code,
        device_type,
        user_id,
        CASE
            WHEN EXTRACT(EPOCH FROM (
                    event_timestamp - LAG(event_timestamp) OVER (
                        PARTITION BY COALESCE(user_id::text, ip_address)
                        ORDER BY event_timestamp
                    )
                 )) > 1800   -- 30 minutes = 1800 seconds
              OR LAG(event_timestamp) OVER (
                        PARTITION BY COALESCE(user_id::text, ip_address)
                        ORDER BY event_timestamp
                 ) IS NULL   -- first event for this user always starts session 1
            THEN 1
            ELSE 0
        END AS new_session_flag
    FROM user_mapped
),

session_numbers AS (
    -- Cumulative sum of new_session_flag gives a per-user session number
    SELECT
        ip_address,
        url,
        event_timestamp,
        response_code,
        device_type,
        user_id,
        SUM(new_session_flag) OVER (
            PARTITION BY COALESCE(user_id::text, ip_address)
            ORDER BY event_timestamp
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS session_id
    FROM session_flags
),

session_metrics AS (
    -- Step D: Compute session-level metrics
    SELECT
        user_id,
        session_id,
        MIN(event_timestamp)                                        AS session_start_time,
        MAX(event_timestamp)                                        AS session_end_time,
        EXTRACT(EPOCH FROM (MAX(event_timestamp) - MIN(event_timestamp)))
                                                                    AS session_duration,
        COUNT(*)                                                    AS total_events,
        COUNT(DISTINCT url)                                         AS unique_pages_visited,
        -- First device used in the session (earliest timestamp)
        FIRST_VALUE(device_type) OVER (
            PARTITION BY user_id, session_id
            ORDER BY event_timestamp
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        )                                                           AS device_type
    FROM session_numbers
    GROUP BY user_id, session_id, event_timestamp, device_type   -- device_type needed for FIRST_VALUE
)

-- Final aggregation to collapse the FIRST_VALUE expansion
SELECT
    user_id,
    session_id,
    session_start_time,
    session_end_time,
    session_duration,
    total_events,
    unique_pages_visited,
    device_type
FROM (
    SELECT
        user_id,
        session_id,
        MIN(session_start_time)      AS session_start_time,
        MAX(session_end_time)        AS session_end_time,
        EXTRACT(EPOCH FROM (MAX(session_end_time) - MIN(session_start_time)))
                                     AS session_duration,
        SUM(total_events)            AS total_events,
        MAX(unique_pages_visited)    AS unique_pages_visited,
        -- Pick the device_type value associated with the session_start_time row
        MIN(device_type) FILTER (
            WHERE session_start_time = (
                SELECT MIN(s2.session_start_time)
                FROM session_metrics s2
                WHERE s2.user_id    = session_metrics.user_id
                  AND s2.session_id = session_metrics.session_id
            )
        )                            AS device_type
    FROM session_metrics
    GROUP BY user_id, session_id
) agg
ORDER BY user_id, session_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Step A: Clean the raw logs
CREATE TEMP TABLE cleaned_logs_bf AS
SELECT DISTINCT
    ip_address,
    url,
    event_timestamp::timestamp AS event_timestamp,
    response_code,
    device_type
FROM web_logs
WHERE response_code IN (200, 301, 302, 404);

-- Step B: Attach user_id via left join
CREATE TEMP TABLE user_mapped_bf AS
SELECT
    cl.ip_address,
    cl.url,
    cl.event_timestamp,
    cl.response_code,
    cl.device_type,
    u.user_id
FROM cleaned_logs_bf cl
LEFT JOIN users u ON cl.ip_address = u.ip_address;

-- Step C: Identify sessions using a self-join to find the previous timestamp
-- For each event, find the latest prior event for the same user (within 30 min check)
CREATE TEMP TABLE session_boundaries_bf AS
SELECT
    curr.ip_address,
    curr.url,
    curr.event_timestamp,
    curr.response_code,
    curr.device_type,
    curr.user_id,
    -- previous event timestamp for this user (NULL if first event)
    (
        SELECT MAX(prev.event_timestamp)
        FROM user_mapped_bf prev
        WHERE COALESCE(prev.user_id::text, prev.ip_address)
              = COALESCE(curr.user_id::text, curr.ip_address)
          AND prev.event_timestamp < curr.event_timestamp
    ) AS prev_timestamp
FROM user_mapped_bf curr;

-- Flag rows that start a new session
CREATE TEMP TABLE session_flagged_bf AS
SELECT
    ip_address,
    url,
    event_timestamp,
    response_code,
    device_type,
    user_id,
    prev_timestamp,
    CASE
        WHEN prev_timestamp IS NULL THEN 1                              -- first event
        WHEN EXTRACT(EPOCH FROM (event_timestamp - prev_timestamp)) > 1800 THEN 1  -- gap > 30 min
        ELSE 0
    END AS new_session_flag
FROM session_boundaries_bf;

-- Assign session_id by counting how many session-starts occurred at or before each event
CREATE TEMP TABLE session_numbered_bf AS
SELECT
    sf.ip_address,
    sf.url,
    sf.event_timestamp,
    sf.response_code,
    sf.device_type,
    sf.user_id,
    (
        -- Count session-start flags up to and including this event = cumulative session number
        SELECT COUNT(*)
        FROM session_flagged_bf sf2
        WHERE COALESCE(sf2.user_id::text, sf2.ip_address)
              = COALESCE(sf.user_id::text, sf.ip_address)
          AND sf2.event_timestamp <= sf.event_timestamp
          AND sf2.new_session_flag = 1
    ) AS session_id
FROM session_flagged_bf sf;

-- Step D: Compute session metrics with basic GROUP BY
-- Get first device per session via a subquery
SELECT
    sn.user_id,
    sn.session_id,
    MIN(sn.event_timestamp)                                              AS session_start_time,
    MAX(sn.event_timestamp)                                              AS session_end_time,
    EXTRACT(EPOCH FROM (MAX(s
