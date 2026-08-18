-- ======================================================================
-- Lowest Latency per Service
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/lowest_latency_per_service
-- ======================================================================

/*
For each service in the us-east-1 region, find the lowest latency recorded. Results should appear by latency descending, then alphabetically by service name.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'min_latency']:
  ['queue-worker', 521.7]
  ['search-api', 501.2]
  ['feature-flag-svc', 170]
  ['token-mint', 140]
  ['event-bus', 110]
*/


-- Write your SQL solution below:

SELECT svc_name, MIN(latency) AS min_latency
FROM svc_health
WHERE region = 'us-east-1'
GROUP BY svc_name
ORDER BY min_latency DESC, svc_name ASC
