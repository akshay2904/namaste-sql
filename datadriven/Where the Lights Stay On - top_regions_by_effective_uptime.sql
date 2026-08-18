-- ======================================================================
-- Where the Lights Stay On
-- ======================================================================
-- Difficulty : Medium
-- Company    : Capital One
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_regions_by_effective_uptime
-- ======================================================================

/*
An SRE team is compiling a reliability leaderboard by region, where a probe's effective hours is its uptime minus a tenth of its latency, and a probe with no recorded latency counts as having zero latency. Total each region's effective hours and surface the three most reliable regions, with equal totals sharing a place.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['region', 'total_effective_hours']:
  ['eu-central-1', 2393.13]
  ['us-west-2', 2388.9]
  ['eu-west-1', 2371.74]
*/


-- Write your SQL solution below:

WITH effective AS (
  SELECT region,
         SUM(uptime - COALESCE(latency, 0) / 10.0) AS total_effective_hours
  FROM svc_health
  GROUP BY region
),
ranked AS (
  SELECT region,
         total_effective_hours,
         DENSE_RANK() OVER (ORDER BY total_effective_hours DESC) AS rnk
  FROM effective
)
SELECT region, ROUND(total_effective_hours, 2) AS total_effective_hours
FROM ranked
WHERE rnk <= 3
ORDER BY total_effective_hours DESC
