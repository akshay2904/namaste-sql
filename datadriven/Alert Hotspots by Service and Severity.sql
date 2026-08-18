-- ======================================================================
-- Alert Hotspots by Service and Severity
-- ======================================================================
-- Difficulty : Easy
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/alert_hotspots_by_service_and_severity
-- ======================================================================

/*
The on-call team wants to identify which service and severity combinations generate the most noise. For each pairing, show the alert count, sorted from most alerts to fewest.

Table: alert_events(alert_id, svc_name, severity, status, fired_at, ack_by, resolved)

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Expected output ['svc_name', 'severity', 'alert_count']:
  ['gateway', 'Critical', 10]
  ['payment-api', 'high', 10]
  ['search-api', 'low', 10]
  ['auth-svc', 'Critical', 8]
  ['auth-svc', 'critical', 8]
*/


-- Write your SQL solution below:

SELECT svc_name, severity, COUNT(*) AS alert_count
FROM alert_events
GROUP BY svc_name, severity
ORDER BY alert_count DESC, svc_name, severity
