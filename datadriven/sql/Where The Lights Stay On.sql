-- ======================================================================
-- Where The Lights Stay On
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/region_with_best_uptime
-- ======================================================================

/*
The SRE team is setting uptime SLA targets and needs to compare regions: give each region's average service uptime, most reliable first.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['region', 'avg_uptime']:
  ['eu-west-1', 95.63459459459459]
  ['eu-central-1', 95.36783783783784]
  ['us-west-2', 95.02810810810811]
  ['ap-south-1', 94.01166666666667]
  ['us-east-1', 93.4828947368421]
*/


-- Write your SQL solution below:

SELECT region, AVG(uptime) AS avg_uptime
FROM svc_health
GROUP BY region
ORDER BY avg_uptime DESC
