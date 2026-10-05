-- ======================================================================
-- The Vital Signs
-- ======================================================================
-- Difficulty : Easy
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/health_check_distribution
-- ======================================================================

/*
We run periodic health checks against auth-svc, and ops wants to see the spread of outcomes. Report how many of its checks landed at each status value.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['status', 'check_count']:
  ['DEGRADED', 3]
  ['Healthy', 4]
  ['degraded', 2]
  ['healthy', 3]
  ['timeout', 3]
*/


-- Write your SQL solution below:

SELECT
  status,
  COUNT(*) AS check_count
FROM svc_health
WHERE svc_name = 'auth-svc'
GROUP BY status
