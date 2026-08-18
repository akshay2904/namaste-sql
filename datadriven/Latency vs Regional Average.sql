-- ======================================================================
-- Latency vs Regional Average
-- ======================================================================
-- Difficulty : Easy
-- Company    : Glassdoor
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/latency_vs_regional_average
-- ======================================================================

/*
Engineers want to compare each service's latency against the regional baseline. For each health check record, show the service name, region, latency, and the average latency across all services in the same region.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'region', 'latency', 'avg_region_latency']:
  ['edge-auth-svc', 'ap-south-1', 170, 345.9457142857143]
  ['feature-flag-svc', 'ap-south-1', 110, 345.9457142857143]
  ['cache-svc', 'eu-central-1', None, 355.42]
  ['cache-svc', 'eu-central-1', 558.6, 355.42]
  ['auth-svc', 'eu-west-1', None, 355.14285714285717]
*/


-- Write your SQL solution below:

SELECT svc_name, region, latency, AVG(latency) OVER (PARTITION BY region) AS avg_region_latency FROM svc_health ORDER BY region, svc_name, latency
