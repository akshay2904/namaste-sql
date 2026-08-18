-- ======================================================================
-- 10 Lowest Uptime Services
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/10_lowest_uptime_services
-- ======================================================================

/*
The SRE team is preparing a reliability review for the quarterly infrastructure meeting. Each service has multiple health check records, and the team needs to surface the 10 worst-performing services based on their lowest recorded uptime. If multiple services are tied at the 10th position, include all of them. Return the service name and its lowest uptime value.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['svc_name', 'min_uptime']:
  ['payment-api', 88]
  ['notif-svc', 88.2]
  ['cron-svc', 88.4]
  ['search-api', 88.6]
  ['queue-worker', 89.35]
*/


-- Write your SQL solution below:

SELECT svc_name, min_uptime
FROM (
    SELECT
        svc_name,
        MIN(uptime) AS min_uptime,
        DENSE_RANK() OVER (ORDER BY MIN(uptime) ASC) AS rnk
    FROM svc_health
    GROUP BY svc_name
) ranked
WHERE rnk <= 10
ORDER BY min_uptime ASC
