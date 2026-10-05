-- ======================================================================
-- Top Alert Resolvers
-- ======================================================================
-- Difficulty : Medium
-- Company    : Netflix
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_alert_resolvers
-- ======================================================================

/*
The incident response team is recognizing top responders. An alert is considered resolved when its status is 'resolved', and the person who acknowledged it (the ack_by field) gets the credit. Exclude alerts with no acknowledger. Return each acknowledger and their count of resolved alerts, sorted from most resolved to least.

Table: alert_events(alert_id, svc_name, severity, status, fired_at, ack_by, resolved)

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Expected output ['svc_name', 'total_resolved']:
  ['user-svc', 36452]
  ['gateway', 36452]
  ['payment-api', 36450]
  ['notif-svc', 32401]
  ['auth-svc', 32400]
*/


-- Write your SQL solution below:

SELECT
    svc_name,
    SUM(resolved) AS total_resolved
FROM alert_events
GROUP BY svc_name
ORDER BY total_resolved DESC
LIMIT 10
