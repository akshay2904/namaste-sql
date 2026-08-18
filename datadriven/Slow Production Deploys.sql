-- ======================================================================
-- Slow Production Deploys
-- ======================================================================
-- Difficulty : Easy
-- Company    : LinkedIn
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/slow_production_deploys
-- ======================================================================

/*
Find production deployments that took longer than 150 seconds. Show the service name, version, duration in seconds, and deployment timestamp, listed reverse-alphabetically by service name.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['svc_name', 'version', 'dur_secs', 'deploy_at']:
  ['user-svc', 'v1.1.0', 580, '2026-07-07 18:30:00']
  ['user-svc', 'v1.1.0', 580, '2026-06-07 18:30:00']
  ['gateway', 'v2.1.0', 478, '2026-01-09 12:36:00']
  ['analytics', 'v3.0.0-rc1', 424, '2026-07-23 06:18:00']
  ['auth-svc', 'v1.0.1', 346, '2026-01-17 00:12:00']
*/


-- Write your SQL solution below:

SELECT svc_name, version, dur_secs, deploy_at
FROM deploy_logs
WHERE env_name = 'production' AND dur_secs > 150
ORDER BY dur_secs DESC
