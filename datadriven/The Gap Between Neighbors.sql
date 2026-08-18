-- ======================================================================
-- The Gap Between Neighbors
-- ======================================================================
-- Difficulty : Hard
-- Company    : LinkedIn
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/intra_region_latency_diff
-- ======================================================================

/*
Each row in svc_health is a single health check, and the monitor logs status in mixed case ('Healthy', 'healthy', 'DEGRADED' and so on) where every spelling is treated as its own condition, so only checks marked exactly 'healthy' qualify. Within a region, pair every qualifying check with every other healthy check whose uptime reading sits within 5 percentage points of it, counting pairs between two different checks even when they belong to the same service. For each service (svc_name), report the average absolute latency gap across all the pairs its checks take part in.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'avg_latency_diff']:
  ['auth-svc', 183.05000000000004]
  ['cache-svc', 489.9200000000001]
  ['cron-svc', 523.7333333333332]
  ['edge-auth-svc', 201.21818181818182]
  ['event-bus', 208.95]
*/


-- Write your SQL solution below:

SELECT s1.svc_name,
       AVG(ABS(s1.latency - s2.latency)) AS avg_latency_diff
FROM svc_health s1
JOIN svc_health s2
  ON s1.region = s2.region
 AND s1.check_id != s2.check_id
WHERE s1.status = 'healthy'
  AND s2.status = 'healthy'
  AND ABS(s1.uptime - s2.uptime) <= 5
GROUP BY s1.svc_name;
