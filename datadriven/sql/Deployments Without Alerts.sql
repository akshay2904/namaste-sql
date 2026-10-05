-- ======================================================================
-- Deployments Without Alerts
-- ======================================================================
-- Difficulty : Easy
-- Company    : Fidelity Investments
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/deployments_without_alerts
-- ======================================================================

/*
Which services deployed with no corresponding alert record? Pull every deployment that has no matching alert for its service. Show the service name, version, environment, and deployment status, with the most recent deployment first.

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

Expected output ['svc_name', 'version', 'env_name', 'status']:
  ['ml-serving', 'v1.0.3', 'STAGING', 'FAILED']
  ['ml-serving', 'v1.0.3', 'STAGING', 'FAILED']
  ['ml-serving', 'v1.0.3', 'STAGING', 'FAILED']
  ['analytics', 'v3.0.0-rc1', 'Production', 'Success']
  ['analytics', 'v3.0.0-rc1', 'Production', 'Success']
*/


-- Write your SQL solution below:

SELECT dl.svc_name, dl.version, dl.env_name, dl.status
FROM deploy_logs dl
LEFT JOIN alert_events ae ON dl.svc_name = ae.svc_name
WHERE ae.alert_id IS NULL
ORDER BY dl.deploy_at DESC
