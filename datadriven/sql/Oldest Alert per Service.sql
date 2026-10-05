-- ======================================================================
-- Oldest Alert per Service
-- ======================================================================
-- Difficulty : Hard
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/oldest_alert_per_service
-- ======================================================================

/*
During an incident review, the on-call team needs the oldest unresolved alert for each service. Show the service name, alert ID, severity, status, and the time the alert was fired, by service name.

Table: alert_events(alert_id, svc_name, severity, status, fired_at, ack_by, resolved)

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Expected output ['svc_name', 'alert_id', 'severity', 'status', 'fired_at']:
  ['auth-svc', 10003096, 'critical', 'firing', '2022-12-13 00:12:00']
  ['cache-01', 10003087, 'low', 'silenced', '2023-03-04 15:09:00']
  ['db-primary', 10003006, 'critical', 'resolved', '2022-06-07 06:42:00']
  ['gateway', 10003036, 'critical', 'firing', '2022-12-09 12:12:00']
  ['notif-svc', 10003021, 'low', 'acknowledged', '2022-09-22 21:27:00']
*/


-- Write your SQL solution below:

SELECT svc_name, alert_id, severity, status, fired_at
FROM (
    SELECT
        svc_name, alert_id, severity, status, fired_at,
        ROW_NUMBER() OVER (PARTITION BY svc_name ORDER BY fired_at ASC) AS rn
    FROM alert_events
    WHERE resolved IS NULL
) sub
WHERE rn = 1
ORDER BY svc_name
