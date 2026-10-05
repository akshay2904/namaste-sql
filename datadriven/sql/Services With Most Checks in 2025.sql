-- ======================================================================
-- Services With Most Checks in 2025
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/services_with_most_checks
-- ======================================================================

/*
The compliance team wants to find services whose busiest year for health checks is 2026. For every service whose 2026 check count matches or beats every other year on record for that service, show the service name and its 2026 check count. Sort from highest count down, breaking ties alphabetically.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'check_count']:
  ['auth-svc', 18]
  ['notif-svc', 18]
  ['cache-svc', 10]
  ['cron-svc', 10]
  ['edge-auth-svc', 4]
*/


-- Write your SQL solution below:

WITH yearly_counts AS (
    SELECT
        svc_name,
        EXTRACT(YEAR FROM checked) AS chk_year,
        COUNT(*) AS chk_count
    FROM svc_health
    GROUP BY svc_name, EXTRACT(YEAR FROM checked)
)
SELECT
    y2026.svc_name,
    y2026.chk_count AS check_count
FROM yearly_counts y2026
WHERE y2026.chk_year = 2026
  AND y2026.chk_count >= ALL (
        SELECT other.chk_count
        FROM yearly_counts other
        WHERE other.svc_name = y2026.svc_name
          AND other.chk_year <> 2026
      )
ORDER BY check_count DESC, y2026.svc_name ASC;
