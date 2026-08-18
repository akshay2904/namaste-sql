-- ======================================================================
-- Thirty Days of Shipping
-- ======================================================================
-- Difficulty : Easy
-- Company    : ZestFinance
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/monthly_deployment_count
-- ======================================================================

/*
For each month, count unique deployments where a deployment is identified by the combination of service name and version. Format months as 'YYYY-MM'. Return the month and the unique deployment count.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['month', 'unique_deployments']:
  ['2022-01', 2]
  ['2022-02', 2]
  ['2022-03', 1]
  ['2026-01', 4]
  ['2026-02', 3]
*/


-- Write your SQL solution below:

SELECT STRFTIME('%Y-%m', deploy_at) AS month,
    COUNT(DISTINCT svc_name || ':' || version) AS unique_deployments
FROM deploy_logs
GROUP BY STRFTIME('%Y-%m', deploy_at)
ORDER BY month
