-- ======================================================================
-- Latest Version Per Service
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/latest_version_per_service
-- ======================================================================

/*
The release dashboard needs to reflect the current state of every service. Show each service alongside the latest version that was deployed to it.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['svc_name', 'version']:
  ['analytics', 'v3.0.0-rc1']
  ['auth-svc', 'v1.0.1']
  ['gateway', 'v2.1.0']
  ['ml-serving', 'v1.0.3']
  ['notif-svc', '2.1.1']
*/


-- Write your SQL solution below:

SELECT svc_name, version
FROM (
    SELECT svc_name, version,
        ROW_NUMBER() OVER (PARTITION BY svc_name ORDER BY deploy_at DESC) AS rn
    FROM deploy_logs
) sub
WHERE rn = 1
