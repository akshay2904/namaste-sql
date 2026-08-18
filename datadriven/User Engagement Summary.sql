-- ======================================================================
-- User Engagement Summary
-- ======================================================================
-- Difficulty : Medium
-- Company    : IBM
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/user_engagement_summary
-- ======================================================================

/*
Show total sessions and total search queries per user. Include users who may have activity in only one of those areas. Count only activity tied to a real user (exclude rows with no user_id).

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Table: search_queries(query_id, user_id, search_term, results_count, clicked_result, query_time)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Sample data - search_queries ['query_id', 'user_id', 'search_term', 'results_count', 'clicked_result', 'query_time']:
  [2071, 100, 'laptop deals', 17, 2, '2026-02-02 01:11:00']
  [2142, 197, 'phone case iphone 15', 34, 3, '2026-03-03 02:22:00']
  [2213, 294, 'usb-c cable 6ft', 51, None, '2026-04-04 03:33:00']
  [2284, None, 'gaming mouse', 68, 5, '2026-05-05 04:44:00']
  [2355, 488, 'mechanical keyboard', 85, 6, '2026-06-06 05:55:00']

Expected output ['user_id', 'total_sessions', 'total_queries']:
  [100, 8, 2]
  [197, 5, 2]
  [294, 5, 2]
  [391, 5, 0]
  [779, 5, 0]
*/


-- Write your SQL solution below:

WITH session_counts AS (
  SELECT user_id, COUNT(*) AS total_sessions
  FROM user_sessions
  WHERE user_id IS NOT NULL
  GROUP BY user_id
),
query_counts AS (
  SELECT user_id, COUNT(*) AS total_queries
  FROM search_queries
  WHERE user_id IS NOT NULL
  GROUP BY user_id
),
all_users AS (
  SELECT user_id FROM session_counts
  UNION
  SELECT user_id FROM query_counts
)
SELECT au.user_id,
       COALESCE(sc.total_sessions, 0) AS total_sessions,
       COALESCE(qc.total_queries,  0) AS total_queries
FROM all_users au
LEFT JOIN session_counts sc ON au.user_id = sc.user_id
LEFT JOIN query_counts   qc ON au.user_id = qc.user_id
ORDER BY au.user_id;
