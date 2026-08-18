-- ======================================================================
-- Not All Fires Are Equal
-- ======================================================================
-- Difficulty : Medium
-- Company    : Affirm
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/avg_alerts_by_severity
-- ======================================================================

/*
The incident response team only trusts alert data from services that also appear in the health check system. Among those services, for any service-severity combination that fired more than once in 2026, first count the alerts per combination, then compute the average of those counts for each severity level, rounded to one decimal place.

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

Expected output ['severity', 'avg_alert_count']:
  ['Critical', 5.3]
  ['HIGH', 5]
  ['critical', 4.7]
  ['high', 5]
  ['medium', 5.3]
*/


-- Write your SQL solution below:

SELECT
  ae.severity,
  CAST(ROUND(AVG(alert_count), 1) AS REAL) AS avg_alert_count
FROM (
  SELECT
    svc_name,
    severity,
    COUNT(*) AS alert_count
  FROM alert_events
  WHERE strftime('%Y', fired_at) = '2026'
  GROUP BY svc_name, severity
  HAVING COUNT(*) > 1
) ae
INNER JOIN svc_health sh
  ON ae.svc_name = sh.svc_name
GROUP BY ae.severity
