-- ======================================================================
-- The High and the Low
-- ======================================================================
-- Difficulty : Hard
-- Company    : KPMG
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/fastest_and_slowest_services_by_region
-- ======================================================================

/*
For each region, surface the highest and lowest latency services, excluding any region whose name contains 'test'. If services tie for the top or bottom spot, include all of them.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'region', 'latency', 'latency_type']:
  ['ml-serving', 'ap-south-1', 800.5, 'highest']
  ['cache-svc', 'eu-central-1', 804.6, 'highest']
  ['auth-svc', 'eu-west-1', 816.9, 'highest']
  ['queue-worker', 'us-east-1', 808.7, 'highest']
  ['gateway', 'us-west-2', 792.3, 'highest']
*/


-- Write your SQL solution below:

WITH ranked AS (
  SELECT svc_name, region, latency,
         DENSE_RANK() OVER (PARTITION BY region ORDER BY latency DESC) AS high_rank,
         DENSE_RANK() OVER (PARTITION BY region ORDER BY latency ASC)  AS low_rank
  FROM svc_health
  WHERE region NOT LIKE '%test%'
    AND latency IS NOT NULL
)
SELECT svc_name, region, latency,
       CASE WHEN high_rank = 1 THEN 'highest' WHEN low_rank = 1 THEN 'lowest' END AS latency_type
FROM ranked
WHERE high_rank = 1 OR low_rank = 1
ORDER BY region, latency_type, svc_name
