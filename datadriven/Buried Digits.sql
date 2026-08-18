-- ======================================================================
-- Buried Digits
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/extract_deploy_versions
-- ======================================================================

/*
The release team wants to compare deploy versions as plain numbers, but each log records the version with a leading 'v' and dots or dashes between the parts, like 'v1.2-3'. The environment field was typed with inconsistent capitalization, and only the deploys whose environment is stored as the exact lowercase word 'staging' should count, so 'STAGING' and 'Staging' fall outside the set. For those rows, drop the 'v' and the dot and dash separators so the digits run together, and return that value as an integer beside the service name.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['svc_name', 'version_num']:
  ['payment-api', 102]
  ['ml-serving', 103]
  ['notif-svc', 211]
  ['search-api', 200]
  ['payment-api', 102]
*/


-- Write your SQL solution below:

SELECT svc_name,
       CAST(REPLACE(REPLACE(REPLACE(version, 'v', ''), '.', ''), '-', '') AS INTEGER) AS version_num
FROM deploy_logs
WHERE env_name = 'staging'
