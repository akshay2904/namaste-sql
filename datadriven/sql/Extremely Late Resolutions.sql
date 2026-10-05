-- ======================================================================
-- Extremely Late Resolutions
-- ======================================================================
-- Difficulty : Medium
-- Company    : General Assembly
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/extremely_late_resolutions
-- ======================================================================

/*
Our alerting system logs resolution times. For each month, calculate the percentage of resolved alerts where resolution took more than 20 minutes beyond the predicted time. Format months as 'YYYY-MM'. Return the month and late percentage.

Table: alert_events(alert_id, svc_name, severity, status, fired_at, ack_by, resolved)

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Expected output ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved', 'rnk']:
  [10003016, 'auth-svc', 'Critical', 'firing', '2022-04-17 16:52:00', None, '2022-04-17 18:56:00', 1]
  [10003031, 'cache-01', 'high', 'silenced', '2022-07-04 07:37:00', 'bob', '2022-07-04 09:41:00', 1]
  [10003086, 'db-primary', 'medium', 'resolved', '2022-02-03 14:02:00', 'bob', '2022-02-03 16:46:00', 1]
  [10003076, 'gateway', 'Critical', 'firing', '2022-04-21 04:52:00', None, '2022-04-21 06:56:00', 1]
  [10003051, 'search-api', 'low', 'silenced', '2022-03-24 03:57:00', 'bob', None, 1]
*/


-- Write your SQL solution below:

SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY svc_name ORDER BY fired_at ASC) AS rnk
    FROM alert_events
) ranked
WHERE rnk = 1
ORDER BY svc_name
