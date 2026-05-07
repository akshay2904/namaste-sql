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

```sql
-- Extract and Transform: Read CSV files and perform all cleaning and transformations

WITH web_logs_raw AS (
  -- Read web_logs.csv
  SELECT 
    ip_address,
    url,
    CAST(event_timestamp AS TIMESTAMP) AS event_timestamp,
    response_code,
    device_type
  FROM web_logs
),

cleaned_logs AS (
  -- Data Cleaning: Remove duplicates and filter valid response codes
  SELECT DISTINCT
    ip_address,
    url,
    event_timestamp,
    response_code,
    device_type
  FROM web_logs_raw
  WHERE response_code IN (200, 301, 302, 404)
),

logs_with_users AS (
  -- User Mapping: Join with users table (left join to keep anonymous users)
  SELECT 
    COALESCE(u.user_id, NULL) AS user_id,
    cl.ip_address,
    cl.url,
    cl.event_timestamp,
    cl.response_code,
    cl.device_type
  FROM cleaned_logs cl
  LEFT JOIN users u ON cl.ip_address = u.ip_address
),

logs_sorted AS (
  -- Sort by user_id and event_timestamp for session identification
  SELECT 
    user_id,
    ip_address,
    url,
    event_timestamp,
    response_code,
    device_type,
    LAG(event_timestamp) OVER (PARTITION BY user_id ORDER BY event_timestamp) AS prev_event_timestamp
  FROM logs_with_users
),

session_boundaries AS (
  -- Session Identification: Detect new sessions when gap > 30 minutes
  SELECT 
    user_id,
    ip_address,
    url,
    event_timestamp,
    response_code,
    device_type,
    CASE 
      WHEN prev_event_timestamp IS NULL THEN 1
      WHEN EXTRACT(EPOCH FROM (event_timestamp - prev_event_timestamp)) > 1800 THEN 1
      ELSE 0
    END AS new_session_flag
  FROM logs_sorted
),

sessions_with_ids AS (
  -- Assign session_id by counting new_session_flag cumulative sum
  SELECT 
    user_id,
    ip_address,
    url,
    event_timestamp,
    response_code,
    device_type,
    SUM(new_session_flag) OVER (PARTITION BY user_id ORDER BY event_timestamp) AS session_id
  FROM session_boundaries
),

session_metrics AS (
  -- Compute session-level metrics
  SELECT 
    user_id,
    session_id,
    MIN(event_timestamp) AS session_start_time,
    MAX(event_timestamp) AS session_end_time,
    EXTRACT(EPOCH FROM (MAX(event_timestamp) - MIN(event_timestamp)))::INTEGER AS session_duration,
    COUNT(*) AS total_events,
    COUNT(DISTINCT url) AS unique_pages_visited,
    FIRST_VALUE(device_type) OVER (PARTITION BY user_id, session_id ORDER BY event_timestamp) AS device_type
  FROM sessions_with_ids
  GROUP BY user_id, session_id
)

-- Output: Final session-level metrics sorted by user_id and session_id
SELECT 
  user_id,
  session_id,
  session_start_time,
  session_end_time,
  session_duration,
  total_events,
  unique_pages_visited,
  device_type
FROM session_metrics
ORDER BY user_id, session_id;
```
