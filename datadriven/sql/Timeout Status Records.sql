-- ======================================================================
-- Timeout Status Records
-- ======================================================================
-- Difficulty : Easy
-- Company    : Yelp
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/timeout_status_records
-- ======================================================================

/*
During an incident investigation, you suspect some service health records have a timeout status. Find all rows with that status value and return all available fields for each matching row.

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [433, 'cron-svc', 'timeout', 28.4, 93.27, '2026-10-10 09:45:00', 'eu-central-1']
  [655, 'notif-svc', 'timeout', 47, 95.45, '2026-04-16 15:15:00', 'us-east-1']
  [877, 'payment-api', 'timeout', None, 97.63, '2026-10-22 21:45:00', 'us-west-2']
  [1099, 'cache-svc', 'timeout', 84.2, 99.81, '2026-04-28 03:15:00', 'eu-west-1']
*/


-- Write your SQL solution below:

SELECT *
FROM svc_health
WHERE status = 'timeout'
