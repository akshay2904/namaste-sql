-- ======================================================================
-- Longest Uptime Streak
-- ======================================================================
-- Difficulty : Hard
-- Company    : AXA
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/longest_uptime_streak
-- ======================================================================

/*
Find the longest consecutive streak of 'healthy' statuses (case-insensitive) for any single service. A streak ends when the service records a non-healthy check. Return the service name and streak length.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'streak_len']:
  ['ml-serving', 4]
*/


-- Write your SQL solution below:

WITH ordered AS (
  SELECT svc_name, status, checked, ROW_NUMBER() OVER (PARTITION BY svc_name ORDER BY checked) AS rn FROM svc_health
),
healthy_only AS (
  SELECT svc_name, rn, ROW_NUMBER() OVER (PARTITION BY svc_name ORDER BY rn) AS pass_rn
  FROM ordered WHERE LOWER(status) = 'healthy'
),
streaks AS (
  SELECT svc_name, rn - pass_rn AS grp, COUNT(*) AS streak_len
  FROM healthy_only GROUP BY svc_name, rn - pass_rn
)
SELECT svc_name, streak_len FROM streaks
ORDER BY streak_len DESC, svc_name ASC
LIMIT 1
