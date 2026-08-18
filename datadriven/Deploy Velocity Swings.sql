-- ======================================================================
-- Deploy Velocity Swings
-- ======================================================================
-- Difficulty : Medium
-- Company    : Walmart
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/daily_metric_percentage_change
-- ======================================================================

/*
After a release retro, the manager wants month-over-month deployment velocity per service. For each service and month, give the percentage change in deployment count from the prior month, leaving out each service's first month since it has no baseline. Round to 2 decimals.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['svc_name', 'deploy_month', 'deploy_count', 'prev_count', 'pct_change']:
  ['analytics', '2022-06', 1, 1, 0]
  ['analytics', '2022-10', 1, 1, 0]
  ['analytics', '2026-03', 4, 1, 300]
  ['analytics', '2026-07', 4, 1, 300]
  ['gateway', '2026-05', 5, 1, 400]
*/


-- Write your SQL solution below:

WITH monthly AS (SELECT svc_name, strftime('%Y-%m', deploy_at) AS deploy_month, COUNT(*) AS deploy_count FROM deploy_logs GROUP BY svc_name, deploy_month), with_lag AS (SELECT svc_name, deploy_month, deploy_count, LAG(deploy_count) OVER (PARTITION BY svc_name ORDER BY deploy_month) AS prev_count FROM monthly) SELECT svc_name, deploy_month, deploy_count, prev_count, ROUND((deploy_count - prev_count)*100.0/prev_count,2) AS pct_change FROM with_lag WHERE prev_count IS NOT NULL ORDER BY svc_name, deploy_month
