-- ======================================================================
-- Longest Deploy With Full Identifier
-- ======================================================================
-- Difficulty : Easy
-- Company    : Visa
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/longest_deploy_with_full_identifier
-- ======================================================================

/*
We need full identification for the deployment(s) with the longest duration. Show a label combining the service name and version, along with the duration in seconds. If multiple deployments tie for the longest, include all of them.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['full_identifier', 'dur_secs']:
  ['analytics:v3.0.0-rc1 (deploy #1526)', 608]
  ['analytics:v3.0.0-rc1 (deploy #10003246)', 608]
*/


-- Write your SQL solution below:

SELECT svc_name || ':' || version || ' (deploy #' || log_id || ')' AS full_identifier, dur_secs
FROM deploy_logs
WHERE dur_secs = (SELECT MAX(dur_secs) FROM deploy_logs)
ORDER BY log_id;
