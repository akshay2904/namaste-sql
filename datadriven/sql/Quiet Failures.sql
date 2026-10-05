-- ======================================================================
-- Quiet Failures
-- ======================================================================
-- Difficulty : Medium
-- Company    : Wells Fargo
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/quiet-failures-production-deploy-reliability
-- ======================================================================

/*
A payments platform's release team is auditing how reliably each service ships to production, where the deploy log records that environment inconsistently as both 'Production' and 'production'. For each service with at least three production deployments, report its total deployments, how many carried a 'success' status, and the resulting success rate, least reliable first.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['svc_name', 'deploy_count', 'success_count', 'success_pct']:
  ['analytics', 16, 16, 100]
  ['auth-svc', 16, 16, 100]
  ['gateway', 18, 18, 100]
  ['user-svc', 16, 16, 100]
*/


-- Write your SQL solution below:

SELECT
  svc_name,
  COUNT(*) AS deploy_count,
  SUM(CASE WHEN LOWER(status) = 'success' THEN 1 ELSE 0 END) AS success_count,
  ROUND(100.0 * SUM(CASE WHEN LOWER(status) = 'success' THEN 1 ELSE 0 END) / COUNT(*), 1) AS success_pct
FROM deploy_logs
WHERE LOWER(env_name) = 'production'
GROUP BY svc_name
HAVING COUNT(*) >= 3
ORDER BY success_pct ASC, svc_name
