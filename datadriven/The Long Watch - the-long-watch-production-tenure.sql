-- ======================================================================
-- The Long Watch
-- ======================================================================
-- Difficulty : Medium
-- Company    : NVIDIA
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the-long-watch-production-tenure
-- ======================================================================

/*
We're auditing our release cadence, where each successful production deploy of a service stays live until the next successful production deploy of that same service replaces it. The environment and status labels were recorded with inconsistent casing over the years, so match them case-insensitively. For every release that was eventually replaced, report the service, the version, and how many calendar days it stayed live, longest-lived first; when two releases held for the same number of days, list them alphabetically by service and then the earlier deploy first.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['svc_name', 'version', 'days_live']:
  ['analytics', 'v3.0.0-rc1', 369]
  ['analytics', 'v3.0.0-rc1', 369]
  ['auth-svc', 'v1.0.1', 369]
  ['gateway', 'v2.1.0', 369]
  ['user-svc', 'v1.1.0', 369]
*/


-- Write your SQL solution below:

SELECT
  svc_name,
  version,
  CAST(julianday(date(next_deploy_at)) - julianday(date(deploy_at)) AS INTEGER) AS days_live
FROM (
  SELECT
    svc_name,
    version,
    deploy_at,
    LEAD(deploy_at) OVER (PARTITION BY svc_name ORDER BY deploy_at) AS next_deploy_at
  FROM (
    SELECT svc_name, version, deploy_at
    FROM deploy_logs
    WHERE LOWER(env_name) = 'production' AND LOWER(status) = 'success'
  ) prod_deploys
) lifespans
WHERE next_deploy_at IS NOT NULL
ORDER BY days_live DESC, svc_name, deploy_at
