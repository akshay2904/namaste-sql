-- ======================================================================
-- Still Climbing
-- ======================================================================
-- Difficulty : Easy
-- Company    : Instacart
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/service_user_growth_rate
-- ======================================================================

/*
As the first quarter wraps up, the SRE team is comparing each service's March 2026 health-check volume against February. Report each service's growth as its March check count divided by its February count.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'growth_rate']:
  ['auth-svc', 0.5]
  ['cache-svc', 0]
  ['cron-svc', 0]
  ['feature-flag-svc', None]
  ['notif-svc', 1]
*/


-- Write your SQL solution below:

SELECT svc_name, CAST(SUM(CASE WHEN strftime('%Y-%m', checked) = '2026-03' THEN 1 ELSE 0 END) AS DOUBLE) / CAST(NULLIF(SUM(CASE WHEN strftime('%Y-%m', checked) = '2026-02' THEN 1 ELSE 0 END), 0) AS DOUBLE) AS growth_rate
FROM svc_health
WHERE strftime('%Y-%m', checked) IN ('2026-02', '2026-03')
GROUP BY svc_name
