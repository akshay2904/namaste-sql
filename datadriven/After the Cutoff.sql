-- ======================================================================
-- After the Cutoff
-- ======================================================================
-- Difficulty : Easy
-- Company    : Microsoft
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/production_deploys_from_april_onward
-- ======================================================================

/*
Our release team is auditing production deploys from April onward, regardless of year, to see which services stayed active late in the cycle. Break those deploys down by service, showing how many each had and the longest deployment duration, busiest services first.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['svc_name', 'deploy_count', 'max_duration']:
  ['analytics', 8, 424]
  ['user-svc', 8, 580]
  ['auth-svc', 4, 346]
  ['gateway', 4, 478]
*/


-- Write your SQL solution below:

SELECT svc_name,
       COUNT(*) AS deploy_count,
       MAX(dur_secs) AS max_duration
FROM deploy_logs
WHERE env_name = 'production'
  AND CAST(strftime('%m', deploy_at) AS INTEGER) >= 4
GROUP BY svc_name
ORDER BY deploy_count DESC, svc_name
