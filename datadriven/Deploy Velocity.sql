-- ======================================================================
-- Deploy Velocity
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/deploy_velocity
-- ======================================================================

/*
The release manager is benchmarking how often each service ships. For each service, look at the gaps in days between consecutive deploys and take the average. Show the service name and its average gap.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['svc_name', 'avg_gap_days']:
  ['analytics', 76.27403381643008]
  ['auth-svc', 70.50676328502595]
  ['gateway', 67.57177777778357]
  ['ml-serving', 71.07161835749108]
  ['notif-svc', 76.10265700484666]
*/


-- Write your SQL solution below:

WITH gaps AS (
    SELECT
        svc_name,
        julianday(deploy_at) - julianday(LAG(deploy_at) OVER (PARTITION BY svc_name ORDER BY deploy_at)) AS gap_days
    FROM deploy_logs
)
SELECT
    svc_name,
    AVG(gap_days) AS avg_gap_days
FROM gaps
WHERE gap_days IS NOT NULL
GROUP BY svc_name
ORDER BY svc_name
