-- ======================================================================
-- Deploy Outcomes by Service
-- ======================================================================
-- Difficulty : Hard
-- Company    : City and County of San Francisco
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/monthly_deploy_counts_pivoted
-- ======================================================================

/*
For each service, pivot its deployment outcomes into columns: successful, failed, and rolled-back deploy counts. Status values may vary in casing. Return one row per service, ordered by service name.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['svc_name', 'success_count', 'failed_count', 'rolled_back_count']:
  ['analytics', 16, 0, 8]
  ['auth-svc', 16, 0, 8]
  ['gateway', 18, 0, 8]
  ['ml-serving', 0, 16, 0]
  ['notif-svc', 0, 16, 0]
*/


-- Write your SQL solution below:

SELECT svc_name, SUM(CASE WHEN LOWER(status) LIKE '%success%' THEN 1 ELSE 0 END) AS success_count, SUM(CASE WHEN LOWER(status)='failed' THEN 1 ELSE 0 END) AS failed_count, SUM(CASE WHEN status='rolled_back' THEN 1 ELSE 0 END) AS rolled_back_count FROM deploy_logs GROUP BY svc_name ORDER BY svc_name
