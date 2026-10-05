-- ======================================================================
-- The Green Light
-- ======================================================================
-- Difficulty : Easy
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/authors_with_successful_deploys
-- ======================================================================

/*
The release team wants the roster of engineers who have landed at least one successful deployment. Return one entry per author, skipping any record with a blank author.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['author']:
  ['alice']
  ['charlie']
  ['eve']
*/


-- Write your SQL solution below:

SELECT LOWER(author) AS author
FROM deploy_logs
WHERE LOWER(status) = 'success'
  AND author IS NOT NULL
  AND TRIM(author) <> ''
GROUP BY LOWER(author)
ORDER BY author
