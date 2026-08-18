-- ======================================================================
-- Name Recognition
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/classify_services_by_name
-- ======================================================================

/*
We're assembling a service taxonomy from the health-check catalog, bucketing each service on what its name advertises: 'api' in the name makes it an 'api_service', 'cache' or 'redis' makes it a 'cache_service', 'db' or 'postgres' makes it a 'database', and a name matching none of those is 'other'. List each service once alongside the bucket it lands in.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'category']:
  ['payment-api', 'api_service']
  ['user-svc', 'other']
  ['search-api', 'api_service']
  ['gateway', 'other']
  ['cache-svc', 'cache_service']
*/


-- Write your SQL solution below:

SELECT DISTINCT
    svc_name,
    CASE
        WHEN svc_name LIKE '%api%' THEN 'api_service'
        WHEN svc_name LIKE '%cache%' OR svc_name LIKE '%redis%' THEN 'cache_service'
        WHEN svc_name LIKE '%db%' OR svc_name LIKE '%postgres%' THEN 'database'
        ELSE 'other'
    END AS category
FROM svc_health
LIMIT 100
