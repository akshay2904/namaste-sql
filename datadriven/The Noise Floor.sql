-- ======================================================================
-- The Noise Floor
-- ======================================================================
-- Difficulty : Medium
-- Company    : CrowdStrike
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the-noise-floor
-- ======================================================================

/*
For each service, we want to know what percentage of its alerts are high or critical severity. Surface only the services where more than half of the alerts qualify, report that percentage rounded to one decimal, worst first with ties broken by service name.

Table: alert_events(alert_id, svc_name, severity, status, fired_at, ack_by, resolved)

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Expected output ['svc_name', 'high_urgency_pct']:
  ['gateway', 69.2]
  ['payment-api', 69.2]
  ['auth-svc', 66.7]
  ['cache-01', 66.7]
  ['search-api', 61.5]
*/


-- Write your SQL solution below:

SELECT
  svc_name,
  ROUND(100.0 * SUM(CASE WHEN LOWER(severity) IN ('critical', 'high') THEN 1 ELSE 0 END) / COUNT(*), 1) AS high_urgency_pct
FROM alert_events
GROUP BY svc_name
HAVING SUM(CASE WHEN LOWER(severity) IN ('critical', 'high') THEN 1 ELSE 0 END) * 1.0 / COUNT(*) > 0.5
ORDER BY high_urgency_pct DESC, svc_name
