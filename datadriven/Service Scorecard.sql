-- ======================================================================
-- Service Scorecard
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/service_scorecard
-- ======================================================================

/*
The VP of Engineering wants a single dashboard row per service tying deploys to alerts. For each service in deploy_logs, count its deploys and then count how many rows in alert_events match on svc_name, keeping services with zero alerts. Return the svc_name, deploy count, and alert count.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Table: alert_events(alert_id, svc_name, severity, status, fired_at, ack_by, resolved)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Expected output ['svc_name', 'deploy_count', 'alert_count']:
  ['analytics', 24, 0]
  ['auth-svc', 24, 24]
  ['gateway', 26, 26]
  ['ml-serving', 24, 0]
  ['payment-api', 26, 26]
*/


-- Write your SQL solution below:

WITH deploy_counts AS (
    SELECT svc_name, COUNT(*) AS deploy_count
    FROM deploy_logs
    GROUP BY svc_name
)
SELECT dc.svc_name, dc.deploy_count, COUNT(a.alert_id) AS alert_count
FROM deploy_counts dc
LEFT
JOIN alert_events a ON dc.svc_name = a.svc_name
GROUP BY dc.svc_name, dc.deploy_count
