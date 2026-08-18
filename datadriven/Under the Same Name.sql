-- ======================================================================
-- Under the Same Name
-- ======================================================================
-- Difficulty : Easy
-- Company    : Vesta Innovations
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_latency_by_health_status
-- ======================================================================

/*
Service agents record a status for every health check, but different agents write the same state in different letter casing, so 'Healthy' and 'healthy' both land in the table as separate labels. Report the average check latency for each health status, treating casing differences as the same state, with the slowest states listed first.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['status', 'avg_latency']:
  ['timeout', 401.1310344827586]
  ['degraded', 373.892]
  ['healthy', 353.31538461538463]
  ['unhealthy', 273.8121212121212]
*/


-- Write your SQL solution below:

SELECT
    LOWER(status) AS status,
    AVG(latency) AS avg_latency
FROM svc_health
GROUP BY LOWER(status)
ORDER BY avg_latency DESC
