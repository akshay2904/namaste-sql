-- ======================================================================
-- The Usual Suspects
-- ======================================================================
-- Difficulty : Hard
-- Company    : Vesta Innovations
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_usual_suspects
-- ======================================================================

/*
We run health-check monitoring across several cloud regions, and every region has one service that dominates the check volume. For 2025, find that leading service in each region with its check count, and include any services tied at the top of a region.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['region', 'svc_name', 'check_count']:
  ['us-west-2', 'cron-svc', 8]
  ['us-west-2', 'gateway', 8]
*/


-- Write your SQL solution below:

WITH regional_counts AS (
  SELECT region, svc_name, COUNT(*) AS check_count
  FROM svc_health
  WHERE strftime('%Y', checked) = '2025'
  GROUP BY region, svc_name
)
SELECT region, svc_name, check_count
FROM regional_counts rc
WHERE check_count = (
  SELECT MAX(check_count)
  FROM regional_counts rc2
  WHERE rc2.region = rc.region
)
ORDER BY region ASC, check_count DESC, svc_name ASC
