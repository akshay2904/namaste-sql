-- ======================================================================
-- Deployment Duration by Status
-- ======================================================================
-- Difficulty : Easy
-- Company    : Uber
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/deployment_duration_by_status
-- ======================================================================

/*
During an incident retro, the SRE lead asked how much wall-clock time each service spends deploying, split by outcome. Show the total deployment duration in seconds for every service-status combination, listed alphabetically by service.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['svc_name', 'status', 'total_duration']:
  ['analytics', 'Success', 1872]
  ['analytics', 'rolled_back', 2496]
  ['analytics', 'success', 2048]
  ['auth-svc', 'Success', 3088]
  ['auth-svc', 'rolled_back', 1980]
*/


-- Write your SQL solution below:

SELECT svc_name, status, SUM(dur_secs) AS total_duration
FROM deploy_logs
GROUP BY svc_name, status
ORDER BY svc_name
