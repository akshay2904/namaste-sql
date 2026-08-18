-- ======================================================================
-- Sirens and Smoke
-- ======================================================================
-- Difficulty : Easy
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/sirens_and_smoke
-- ======================================================================

/*
Pull all alert event details (alert ID, service name, severity, status, fired-at time, acknowledged-by, and resolved status) from 2026 where the severity is either 'high' or 'critical' (case-insensitive).

Table: alert_events(alert_id, svc_name, severity, status, fired_at, ack_by, resolved)

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Expected output ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']
  [274, 'db-primary', 'critical', 'resolved', '2026-07-07 06:42:00', 'bob', None]
  [303, 'cache-01', 'high', 'silenced', '2026-08-08 07:49:00', 'charlie', '2026-08-08 09:17:00']
*/


-- Write your SQL solution below:

SELECT alert_id, svc_name, severity, status, fired_at, ack_by, resolved
FROM alert_events
WHERE LOWER(severity) IN ('high', 'critical') AND strftime('%Y', fired_at) = '2026'
