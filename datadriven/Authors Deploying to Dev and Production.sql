-- ======================================================================
-- Authors Deploying to Dev and Production
-- ======================================================================
-- Difficulty : Medium
-- Company    : TripAdvisor
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/authors_deploying_to_dev_and_production
-- ======================================================================

/*
The release engineering team wants to identify authors who ship to both the dev and production environments (case-insensitive match). Show each qualifying author and how many of those two environments they have deployed to, listed alphabetically.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['author', 'env_count']:
  ['Alice', 2]
  ['alice', 2]
  ['charlie', 2]
  ['eve', 2]
*/


-- Write your SQL solution below:

SELECT author,
       COUNT(DISTINCT LOWER(env_name)) AS env_count
FROM deploy_logs
WHERE LOWER(env_name) IN ('dev', 'production')
GROUP BY author
HAVING COUNT(DISTINCT LOWER(env_name)) = 2
ORDER BY author;
