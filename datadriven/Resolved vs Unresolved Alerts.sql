-- ======================================================================
-- Resolved vs Unresolved Alerts
-- ======================================================================
-- Difficulty : Hard
-- Company    : Meta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/resolved_vs_unresolved_alerts
-- ======================================================================

/*
For each alert severity level, show how many alerts are resolved versus unresolved as separate columns. Treat missing resolution status as unresolved.

Table: alert_events(alert_id, svc_name, severity, status, fired_at, ack_by, resolved)

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Expected output ['severity', 'resolved_count', 'unresolved_count']:
  ['Critical', 34, 0]
  ['HIGH', 32, 0]
  ['critical', 0, 32]
  ['high', 34, 0]
  ['low', 0, 34]
*/


-- Write your SQL solution below:

SELECT severity, SUM(CASE WHEN COALESCE(resolved, '0') != '0' THEN 1 ELSE 0 END) AS resolved_count, SUM(CASE WHEN COALESCE(resolved, '0') = '0' THEN 1 ELSE 0 END) AS unresolved_count
FROM alert_events
GROUP BY severity
