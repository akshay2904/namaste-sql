-- ======================================================================
-- Services at Median Uptime
-- ======================================================================
-- Difficulty : Medium
-- Company    : General Assembly
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/services_at_median_uptime
-- ======================================================================

/*
The SRE team is profiling services that sit exactly at the median uptime level, since those are the best candidates for targeted improvement. Find any services whose uptime matches the median uptime value exactly.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'uptime']:
  ['user-svc', 94.86]
*/


-- Write your SQL solution below:

WITH ranked AS (
    SELECT svc_name, uptime, NTILE(2) OVER (ORDER BY uptime) AS half
    FROM svc_health
)
SELECT svc_name, uptime
FROM ranked
WHERE half = 1 AND uptime = (SELECT MAX(uptime) FROM ranked WHERE half = 1)
