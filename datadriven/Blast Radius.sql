-- ======================================================================
-- Blast Radius
-- ======================================================================
-- Difficulty : Medium
-- Company    : IBM
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/deployment_failure_impact
-- ======================================================================

/*
After a string of rollbacks, leadership asked how much deployment capacity each service is losing to failures. For every service, show the share of its deployments that failed and the share of its total deployment time those failures consumed.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['svc_name', 'failure_pct', 'failure_time_pct']:
  ['analytics', 33.33, 38.9]
  ['auth-svc', 33.33, 30.05]
  ['gateway', 30.77, 54.04]
  ['ml-serving', 66.67, 57.13]
  ['notif-svc', 66.67, 67.91]
*/


-- Write your SQL solution below:

SELECT
    svc_name,
    ROUND(100.0 * SUM(CASE WHEN LOWER(status) IN ('failed', 'rolled_back') THEN 1 ELSE 0 END) / COUNT(*), 2) AS failure_pct,
    ROUND(100.0 * SUM(CASE WHEN LOWER(status) IN ('failed', 'rolled_back') THEN dur_secs ELSE 0 END) / NULLIF(SUM(dur_secs), 0), 2) AS failure_time_pct
FROM deploy_logs
GROUP BY svc_name
ORDER BY svc_name
