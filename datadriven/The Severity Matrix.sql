-- ======================================================================
-- The Severity Matrix
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/alert_severity_pivot_by_service
-- ======================================================================

/*
The on-call lead is prepping the weekly reliability review and needs one table showing, for each service, how its alerts split across the severity levels plus a total count. Severity is typed in by hand and the same level turns up in different capitalizations, so treat those as one; put the busiest services at the top.

Table: alert_events(alert_id, svc_name, severity, status, fired_at, ack_by, resolved)

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Expected output ['svc_name', 'critical_count', 'high_count', 'medium_count', 'low_count', 'total_count']:
  ['gateway', 18, 0, 8, 0, 26]
  ['payment-api', 0, 18, 0, 8, 26]
  ['search-api', 0, 16, 0, 10, 26]
  ['user-svc', 16, 0, 10, 0, 26]
  ['auth-svc', 16, 0, 8, 0, 24]
*/


-- Write your SQL solution below:

SELECT svc_name,
       SUM(CASE WHEN LOWER(severity) = 'critical' THEN 1 ELSE 0 END) AS critical_count,
       SUM(CASE WHEN LOWER(severity) = 'high' THEN 1 ELSE 0 END) AS high_count,
       SUM(CASE WHEN LOWER(severity) = 'medium' THEN 1 ELSE 0 END) AS medium_count,
       SUM(CASE WHEN LOWER(severity) = 'low' THEN 1 ELSE 0 END) AS low_count,
       COUNT(*) AS total_count
FROM alert_events
GROUP BY svc_name
ORDER BY total_count DESC, svc_name ASC
