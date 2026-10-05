-- ======================================================================
-- Low Uptime Services
-- ======================================================================
-- Difficulty : Easy
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/low_uptime_services
-- ======================================================================

/*
The SRE team set a 95% uptime SLA and needs to surface every health check that fell short. Show the service name, check date, and uptime for each violation.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'checked', 'uptime']:
  ['payment-api', '2022-01-05 00:00:00', 88]
  ['payment-api', '2022-01-21 12:00:00', 88]
  ['notif-svc', '2026-01-17 00:48:00', 88.2]
  ['cron-svc', '2025-01-01 00:36:00', 88.4]
  ['search-api', '2024-01-13 00:24:00', 88.6]
*/


-- Write your SQL solution below:

SELECT svc_name, checked, uptime
FROM svc_health
WHERE uptime < 95
ORDER BY uptime ASC, checked ASC
