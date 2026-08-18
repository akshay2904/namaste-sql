-- ======================================================================
-- Streak Status Changes
-- ======================================================================
-- Difficulty : Hard
-- Company    : Robinhood
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/streak_status_changes
-- ======================================================================

/*
We monitor daily user status records for unauthorized state changes. Surface every row where the status changed from the previous day, with both the old and new status side by side so the team can audit the transitions.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'checked', 'previous_status', 'current_status']:
  ['auth-svc', '2026-02-06 07:13:00', 'healthy', 'timeout']
  ['auth-svc', '2026-03-23 02:10:00', 'timeout', 'unhealthy']
  ['auth-svc', '2026-04-08 21:03:00', 'unhealthy', 'DEGRADED']
  ['auth-svc', '2026-05-13 16:20:00', 'DEGRADED', 'Healthy']
  ['auth-svc', '2026-06-10 11:53:00', 'Healthy', 'degraded']
*/


-- Write your SQL solution below:

WITH with_prev AS (
    SELECT svc_name, checked, status AS current_status, LAG(status) OVER (PARTITION BY svc_name ORDER BY checked) AS previous_status
    FROM svc_health
)
SELECT svc_name, checked, previous_status, current_status
FROM with_prev
WHERE previous_status IS NOT NULL AND previous_status != current_status
