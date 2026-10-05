-- ======================================================================
-- Service With Most Critical Alerts
-- ======================================================================
-- Difficulty : Hard
-- Company    : City and County of San Francisco
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/service_with_most_critical_alerts
-- ======================================================================

/*
During an active incident, the incident commander needs full details for the service that has received the most alerts where severity contains the word 'critical'. Return all columns for every alert belonging to that service, ordered by fired_at.

Table: alert_events(alert_id, svc_name, severity, status, fired_at, ack_by, resolved)

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Expected output ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [10003076, 'gateway', 'Critical', 'firing', '2022-04-21 04:52:00', None, '2022-04-21 06:56:00']
  [10003036, 'gateway', 'critical', 'firing', '2022-12-09 12:12:00', None, None]
  [10003052, 'gateway', 'Critical', 'firing', '2023-04-25 04:04:00', None, '2023-04-25 06:32:00']
  [10003092, 'gateway', 'medium', 'firing', '2023-08-09 20:44:00', None, '2023-08-09 22:52:00']
  [10003012, 'gateway', 'critical', 'firing', '2023-12-13 12:24:00', None, None]
*/


-- Write your SQL solution below:

WITH critical_counts AS (
    SELECT svc_name, COUNT(*) AS critical_count
    FROM alert_events
    WHERE severity LIKE '%critical%'
    GROUP BY svc_name
    ORDER BY critical_count DESC
    LIMIT 1
)
SELECT ae.*
FROM alert_events ae
WHERE ae.svc_name IN (SELECT svc_name FROM critical_counts)
ORDER BY ae.fired_at
