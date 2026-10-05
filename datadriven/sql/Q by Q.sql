-- ======================================================================
-- Q by Q
-- ======================================================================
-- Difficulty : Easy
-- Company    : Crunchbase
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/quarterly_deployment_count
-- ======================================================================

/*
The release engineering team is presenting deployment velocity trends at the all-hands. Show each quarter in YYYY-QN format alongside its deployment count, sorted from most deployments to fewest.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['quarter', 'deploy_count']:
  ['2026-Q2', 32]
  ['2026-Q1', 31]
  ['2026-Q4', 29]
  ['2026-Q3', 28]
  ['2024-Q1', 6]
*/


-- Write your SQL solution below:

SELECT
    strftime('%Y', deploy_at) || '-Q' || ((CAST(strftime('%m', deploy_at) AS INTEGER) - 1) / 3 + 1) AS quarter,
    COUNT(*) AS deploy_count
FROM deploy_logs
GROUP BY quarter
ORDER BY deploy_count DESC
