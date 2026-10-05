-- ======================================================================
-- Who Stayed
-- ======================================================================
-- Difficulty : Hard
-- Company    : Square
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/monthly_service_retention
-- ======================================================================

/*
We run periodic health checks across a fleet of services, and every check records the region it ran in. For December 2025 and January 2026, we want to know how much of each service's regional footprint holds up: of the regions a service was checked in during the month, what share get checked again for that same service in some later month. Return the service, the month, and that share as a percentage, treating a month whose regions never reappear as zero.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'month', 'retention_pct']:
  ['auth-svc', '2026-01', 100]
  ['edge-auth-svc', '2026-01', 0]
  ['gateway', '2025-12', 0]
  ['gateway', '2026-01', 100]
  ['ml-serving', '2026-01', 100]
*/


-- Write your SQL solution below:

WITH svc_region_month AS (
    SELECT DISTINCT
        svc_name,
        STRFTIME('%Y-%m', checked) AS month,
        region
    FROM svc_health
)
SELECT
    c.svc_name,
    c.month,
    ROUND(
        100.0 * COUNT(DISTINCT CASE WHEN f.region IS NOT NULL THEN c.region END)
        / COUNT(DISTINCT c.region),
    2) AS retention_pct
FROM svc_region_month c
LEFT JOIN svc_region_month f
    ON f.svc_name = c.svc_name
    AND f.region = c.region
    AND f.month > c.month
WHERE c.month IN ('2025-12', '2026-01')
GROUP BY c.svc_name, c.month
ORDER BY c.svc_name, c.month
