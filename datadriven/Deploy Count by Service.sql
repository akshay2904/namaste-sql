-- ======================================================================
-- Deploy Count by Service
-- ======================================================================
-- Difficulty : Easy
-- Company    : Asana
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/deploy_count_by_service
-- ======================================================================

/*
The team is scoping a deployment automation project and wants to target the services that deploy most often first. Show each service's total deployment count, from the most frequently deployed down.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['svc_name', 'deploy_count']:
  ['user-svc', 26]
  ['search-api', 26]
  ['payment-api', 26]
  ['notif-svc', 24]
  ['ml-serving', 24]
*/


-- Write your SQL solution below:

SELECT svc_name, COUNT(*) AS deploy_count
FROM deploy_logs
GROUP BY svc_name
ORDER BY deploy_count DESC
