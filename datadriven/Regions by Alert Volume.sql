-- ======================================================================
-- Regions by Alert Volume
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/regions_by_alert_volume
-- ======================================================================

/*
We want an incident heatmap by region. Count the number of alerts per region (based on the service's region), sorted from most incidents to least.

Table: alert_events(alert_id, svc_name, severity, status, fired_at, ack_by, resolved)

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['region', 'alert_count']:
  ['us-east-1', 688]
  ['eu-west-1', 644]
  ['us-west-2', 468]
  ['eu-central-1', 468]
  ['ap-south-1', 468]
*/


-- Write your SQL solution below:

SELECT sh.region, COUNT(*) AS alert_count
FROM alert_events ae
INNER
JOIN svc_health sh ON ae.svc_name = sh.svc_name
GROUP BY sh.region
ORDER BY alert_count DESC
