-- ======================================================================
-- Rollback Roulette
-- ======================================================================
-- Difficulty : Easy
-- Company    : Virgin Group
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/failed_payment_deployments
-- ======================================================================

/*
The platform team is auditing release stability for the payment-api service before its next on-call rotation. Deployment outcomes are logged in deploy_logs, but the status column was populated by several different CI tools over the years, so the same outcome appears in mixed casing (for example 'FAILED' and 'failed'). Count how many deployments of the service named 'payment-api' ended with a failed status. Treat status values case-insensitively so no failed deploy is missed.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['failed_deployments']:
  [18]
*/


-- Write your SQL solution below:

SELECT COUNT(*) AS failed_deployments
FROM deploy_logs
WHERE LOWER(status) = 'failed'
  AND LOWER(svc_name) = 'payment-api'
