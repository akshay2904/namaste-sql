-- ======================================================================
-- Alert Count by Severity Tier
-- ======================================================================
-- Difficulty : Medium
-- Company    : City and County of San Francisco
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/alert_count_by_severity_tier
-- ======================================================================

/*
The incident response team needs alert volume broken down by severity tier for the postmortem review. If a severity value is missing, label it as 'unknown'. Present the tiers from most alerts to fewest.

Table: alert_events(alert_id, svc_name, severity, status, fired_at, ack_by, resolved)

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Expected output ['severity_tier', 'alert_count']:
  ['medium', 34]
  ['low', 34]
  ['high', 34]
  ['critical', 32]
  ['HIGH', 32]
*/


-- Write your SQL solution below:

SELECT
  COALESCE(severity, 'unknown') AS severity_tier,
  COUNT(*) AS alert_count
FROM alert_events
GROUP BY severity_tier
ORDER BY alert_count DESC
