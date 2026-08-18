-- ======================================================================
-- Service Uptime Minutes
-- ======================================================================
-- Difficulty : Medium
-- Company    : Samsara
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/service_uptime_minutes
-- ======================================================================

/*
Each alert has a fired_at timestamp and a resolved timestamp (NULL if still open). For each service, calculate the total minutes spent in an active alert state. Only consider alerts that were resolved within the first year after the service's earliest health check.

Table: svc_health(check_id, svc_name, checked)

Table: alert_events(alert_id, svc_name, fired_at, resolved)

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Expected output ['svc_name', 'total_downtime_minutes']:
  ['auth-svc', 1862]
  ['gateway', 851]
  ['notif-svc', 1908]
  ['payment-api', 226]
  ['search-api', 577]
*/


-- Write your SQL solution below:

WITH svc_start AS (
    SELECT svc_name, MIN(checked) AS first_check
    FROM svc_health
    GROUP BY svc_name
)
SELECT a.svc_name, SUM(CAST((julianday(a.resolved) - julianday(a.fired_at)) * 1440 AS INTEGER)) AS total_downtime_minutes
FROM alert_events a
JOIN svc_start s ON a.svc_name = s.svc_name
WHERE a.resolved IS NOT NULL AND a.fired_at <= datetime(s.first_check, '+365 days')
GROUP BY a.svc_name
