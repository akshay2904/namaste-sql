-- ======================================================================
-- 118 - User Session Activity
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Tredence
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/118-user-session-activity
-- ======================================================================

/*
You are given a table user events that tracks user activity with the following schema:

 
Table: events
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| userid     | int      |    
| event_type  | varchar  |
| event_time  | timestamp|
+-------------+----------+
Task:

1. Identify user sessions. A session is defined as a sequence of activities by a user where the time difference between consecutive events is less than or equal to 30 minutes. If the time between two events exceeds 30 minutes, it's considered the start of a new session.

 

2. For each session, calculate the following metrics:

session_id : a unique identifier for each session.

session_start_time : the timestamp of the first event in the session.

session_end_time : the timestamp of the last event in the session.

session_duration : the difference between session_end_time and session_start_time.

event_count : the number of events in the session.
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ordered_events AS (
    -- Assign row numbers and get previous event time per user
    SELECT
        userid,
        event_type,
        event_time,
        LAG(event_time) OVER (PARTITION BY userid ORDER BY event_time) AS prev_event_time
    FROM events
),
session_flags AS (
    -- Flag the start of a new session (1 = new session, 0 = same session)
    SELECT
        userid,
        event_type,
        event_time,
        CASE
            WHEN prev_event_time IS NULL
              OR EXTRACT(EPOCH FROM (event_time - prev_event_time)) / 60 > 30
            THEN 1
            ELSE 0
        END AS is_new_session
    FROM ordered_events
),
session_numbers AS (
    -- Cumulative sum of new session flags gives a unique session number per user
    SELECT
        userid,
        event_type,
        event_time,
        SUM(is_new_session) OVER (PARTITION BY userid ORDER BY event_time
                                   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS user_session_num
    FROM session_flags
),
session_metrics AS (
    SELECT
        userid,
        user_session_num,
        MIN(event_time)                                          AS session_start_time,
        MAX(event_time)                                          AS session_end_time,
        MAX(event_time) - MIN(event_time)                        AS session_duration,
        COUNT(*)                                                 AS event_count
    FROM session_numbers
    GROUP BY userid, user_session_num
)
SELECT
    -- Generate a globally unique session_id using dense_rank over all sessions
    ROW_NUMBER() OVER (ORDER BY userid, user_session_num)        AS session_id,
    userid,
    session_start_time,
    session_end_time,
    session_duration,
    event_count
FROM session_metrics
ORDER BY userid, session_start_time;


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Step 1: Self-join to find previous event per user (brute force, no LAG)
-- Step 2: Determine session boundaries manually

-- Tag each event with its immediately preceding event time using a correlated subquery
WITH prev_times AS (
    SELECT
        e1.userid,
        e1.event_type,
        e1.event_time,
        -- Get the latest event before the current one for the same user
        (
            SELECT MAX(e2.event_time)
            FROM events e2
            WHERE e2.userid    = e1.userid
              AND e2.event_time < e1.event_time
        ) AS prev_event_time
    FROM events e1
),
session_flags AS (
    -- Mark start of a new session
    SELECT
        userid,
        event_type,
        event_time,
        CASE
            WHEN prev_event_time IS NULL
              OR EXTRACT(EPOCH FROM (event_time - prev_event_time)) / 60 > 30
            THEN 1
            ELSE 0
        END AS is_new_session
    FROM prev_times
),
-- Assign session boundaries: each session start gets a unique marker
session_starts AS (
    SELECT
        userid,
        event_time AS session_boundary
    FROM session_flags
    WHERE is_new_session = 1
),
-- Map every event to its session start (the latest session boundary <= event_time)
event_session_map AS (
    SELECT
        sf.userid,
        sf.event_time,
        (
            SELECT MAX(ss.session_boundary)
            FROM session_starts ss
            WHERE ss.userid         = sf.userid
              AND ss.session_boundary <= sf.event_time
        ) AS session_start_key
    FROM session_flags sf
),
session_metrics AS (
    SELECT
        userid,
        session_start_key                             AS session_start_time,
        MAX(event_time)                               AS session_end_time,
        MAX(event_time) - MIN(event_time)             AS session_duration,
        COUNT(*)                                      AS event_count
    FROM event_session_map
    GROUP BY userid, session_start_key
)
SELECT
    ROW_NUMBER() OVER (ORDER BY userid, session_start_time) AS session_id,
    userid,
    session_start_time,
    session_end_time,
    session_duration,
    event_count
FROM session_metrics
ORDER BY userid, session_start_time;
