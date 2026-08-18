-- ======================================================================
-- Deploy Cadence
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/deploy_cadence
-- ======================================================================

/*
The platform engineering team is benchmarking deployment frequency across environments and wants a breakdown. For each environment, show the number of deployments, the average deployment duration in seconds, and the number of unique services that have been deployed there. Present environments from the highest deployment tally to the lowest.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['env_name', 'deploy_count', 'avg_duration', 'unique_services']:
  ['staging', 34, 304.14285714285717, 4]
  ['dev', 34, 343.2857142857143, 4]
  ['canary', 34, 288.6, 4]
  ['production', 32, 265, 4]
  ['STAGING', 32, 263.14285714285717, 4]
*/


-- Write your SQL solution below:

SELECT
    env_name,
    COUNT(*) AS deploy_count,
    AVG(dur_secs) AS avg_duration,
    COUNT(DISTINCT svc_name) AS unique_services
FROM deploy_logs
GROUP BY env_name
ORDER BY deploy_count DESC
