-- ======================================================================
-- First Deploy Attribution
-- ======================================================================
-- Difficulty : Medium
-- Company    : Tesla
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/first_deploy_attribution
-- ======================================================================

/*
The release engineering team wants to measure onboarding velocity: how often are engineers deploying to a service for the very first time? For each service, show the total deployment count alongside how many of those were an author's first-ever deployment to that service.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['svc_name', 'total_deploys', 'first_time_deploys']:
  ['analytics', 24, 1]
  ['auth-svc', 24, 1]
  ['gateway', 26, 1]
  ['ml-serving', 24, 1]
  ['payment-api', 26, 1]
*/


-- Write your SQL solution below:

SELECT
  dl.svc_name,
  COUNT(*) AS total_deploys,
  SUM(CASE WHEN rn = 1 THEN 1 ELSE 0 END) AS first_time_deploys
FROM (
  SELECT
    deploy_logs.*,
    ROW_NUMBER() OVER (
      PARTITION BY author, svc_name
      ORDER BY deploy_at
    ) AS rn
  FROM deploy_logs
) dl
GROUP BY dl.svc_name
ORDER BY dl.svc_name;
