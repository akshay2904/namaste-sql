-- ======================================================================
-- Deployments per Environment
-- ======================================================================
-- Difficulty : Medium
-- Company    : ESPN
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/deployments_per_environment
-- ======================================================================

/*
Staging has been overloaded lately and the team suspects it's getting more deploys than production. Show the deployment count for each environment so they can confirm.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['env_name', 'deploy_count']:
  ['Production', 34]
  ['STAGING', 32]
  ['canary', 34]
  ['dev', 34]
  ['production', 32]
*/


-- Write your SQL solution below:

SELECT env_name, COUNT(*) AS deploy_count
FROM deploy_logs
GROUP BY env_name
