-- ======================================================================
-- Alert Response Breakdown
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/alert_response_breakdown
-- ======================================================================

/*
The incident response team is running a quarterly postmortem on alert handling. For every service, they need total alerts fired, how many were critical severity, how many were high severity, how many were never acknowledged, and the average number of alerts per status category. Normalize severity to lowercase before bucketing. Present services with the most total alerts first.

Table: alert_events(alert_id, svc_name, severity, status, fired_at, ack_by, resolved)

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Expected output ['svc_name', 'total_alerts', 'critical_count', 'high_count', 'unacked_count', 'avg_per_status']:
  ['user-svc', 26, 16, 0, 0, 26]
  ['search-api', 26, 0, 16, 0, 26]
  ['payment-api', 26, 0, 18, 0, 26]
  ['notif-svc', 24, 0, 16, 0, 24]
  ['db-primary', 24, 16, 0, 0, 24]
*/


-- Write your SQL solution below:

SELECT
  svc_name,
  COUNT(*) AS total_alerts,
  SUM(CASE WHEN LOWER(severity) = 'critical' THEN 1 ELSE 0 END) AS critical_count,
  SUM(CASE WHEN LOWER(severity) = 'high'     THEN 1 ELSE 0 END) AS high_count,
  SUM(CASE WHEN ack_by IS NULL              THEN 1 ELSE 0 END) AS unacked_count,
  ROUND(1.0 * COUNT(*) / COUNT(DISTINCT status), 2) AS avg_per_status
FROM alert_events
GROUP BY svc_name
ORDER BY total_alerts DESC;
