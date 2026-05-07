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

```sql
WITH ordered_events AS (
  -- Order events by user and time
  SELECT 
    userid,
    event_type,
    event_time,
    LAG(event_time) OVER (PARTITION BY userid ORDER BY event_time) AS prev_event_time
  FROM events
),
session_groups AS (
  -- Identify session breaks: when gap > 30 minutes or first event for user
  SELECT 
    userid,
    event_type,
    event_time,
    SUM(CASE 
      WHEN prev_event_time IS NULL THEN 1
      WHEN EXTRACT(EPOCH FROM (event_time - prev_event_time)) > 1800 THEN 1
      ELSE 0
    END) OVER (PARTITION BY userid ORDER BY event_time) AS session_group
  FROM ordered_events
),
sessions AS (
  -- Create session_id and calculate metrics
  SELECT 
    CONCAT(userid, '_', session_group) AS session_id,
    userid,
    MIN(event_time) AS session_start_time,
    MAX(event_time) AS session_end_time,
    MAX(event_time) - MIN(event_time) AS session_duration,
    COUNT(*) AS event_count
  FROM session_groups
  GROUP BY userid, session_group
)
SELECT 
  session_id,
  session_start_time,
  session_end_time,
  session_duration,
  event_count
FROM sessions
ORDER BY session_start_time;
```
