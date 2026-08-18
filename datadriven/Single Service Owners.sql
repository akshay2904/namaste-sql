-- ======================================================================
-- Single Service Owners
-- ======================================================================
-- Difficulty : Medium
-- Company    : Vesta Innovations
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/single_service_owners
-- ======================================================================

/*
An infrastructure audit needs to identify owners responsible for exactly one service. Show the service name and how many services that owner manages (which will be 1), listed alphabetically by service name. Limit to the top 10.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'service_count']:
  ['auth-svc', 1]
  ['cache-svc', 1]
  ['cron-svc', 1]
  ['edge-auth-svc', 1]
  ['event-bus', 1]
*/


-- Write your SQL solution below:

SELECT svc_name, CAST(COUNT(DISTINCT svc_name) AS DOUBLE) AS service_count
FROM svc_health
GROUP BY svc_name
HAVING COUNT(DISTINCT svc_name) = 1
ORDER BY svc_name
LIMIT 10
