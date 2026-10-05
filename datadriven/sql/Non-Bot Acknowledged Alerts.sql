-- ======================================================================
-- Non-Bot Acknowledged Alerts
-- ======================================================================
-- Difficulty : Easy
-- Company    : TransUnion
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/non_bot_acknowledged_alerts
-- ======================================================================

/*
During on-call incident review, pull all alerts that were not acknowledged by 'alice', including alerts that were never acknowledged at all. Show all fields, by the time the alert was fired.

Table: alert_events(alert_id, svc_name, severity, status, fired_at, ack_by, resolved)

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Expected output ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [10003001, 'payment-api', 'high', 'acknowledged', '2022-01-02 01:07:00', 'bob', '2022-01-02 03:11:00']
  [10003061, 'notif-svc', 'high', 'acknowledged', '2022-01-06 13:07:00', 'bob', '2022-01-06 15:11:00']
  [10003086, 'db-primary', 'medium', 'resolved', '2022-02-03 14:02:00', 'bob', '2022-02-03 16:46:00']
  [10003051, 'search-api', 'low', 'silenced', '2022-03-24 03:57:00', 'bob', None]
  [10003016, 'auth-svc', 'Critical', 'firing', '2022-04-17 16:52:00', None, '2022-04-17 18:56:00']
*/


-- Write your SQL solution below:

SELECT *
FROM alert_events
WHERE ack_by != 'alice' OR ack_by IS NULL
ORDER BY fired_at
