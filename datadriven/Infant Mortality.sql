-- ======================================================================
-- Infant Mortality
-- ======================================================================
-- Difficulty : Hard
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/new_services_with_poor_health
-- ======================================================================

/*
We run periodic health checks on every service and want to catch the ones that were troubled from birth. Among services whose earliest check falls in Q1 2026, surface those where more than 20% of all their checks came back as something other than healthy, along with that failure rate.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'negative_ratio']:
  ['auth-svc', 0.6111111111111112]
  ['edge-auth-svc', 0.5]
  ['event-bus', 0.5]
  ['feature-flag-svc', 0.5]
  ['notif-svc', 0.6666666666666666]
*/


-- Write your SQL solution below:

SELECT
  svc_name,
  CAST(SUM(CASE WHEN LOWER(status) <> 'healthy' THEN 1 ELSE 0 END) AS REAL)
    / COUNT(*) AS negative_ratio
FROM svc_health
WHERE status IS NOT NULL
GROUP BY svc_name
HAVING MIN(checked) >= '2026-01-01'
   AND MIN(checked) <  '2026-04-01'
   AND CAST(SUM(CASE WHEN LOWER(status) <> 'healthy' THEN 1 ELSE 0 END) AS REAL)
         / COUNT(*) > 0.2
