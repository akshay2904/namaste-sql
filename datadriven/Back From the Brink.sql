-- ======================================================================
-- Back From the Brink
-- ======================================================================
-- Difficulty : Hard
-- Company    : LinkedIn
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/sequential_service_transitions
-- ======================================================================

/*
Each row in deploy_logs is one deployment by an engineer (author), with a status and a deploy_at timestamp. Treat author names case-insensitively (e.g. 'Alice' and 'alice' are the same engineer), and likewise normalize status casing. We want to find engineers who bounced back after a rollback: order each engineer's deployments by deploy_at, and find any deployment whose status is 'rolled_back' where that engineer's very next deployment (by timestamp) has status 'success'. Return a single number: the count of DISTINCT engineers who had at least one such rolled_back -> success transition.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['recovery_count']:
  [3]
*/


-- Write your SQL solution below:

WITH ordered_deploys AS (
    SELECT LOWER(author) AS author, LOWER(status) AS status, deploy_at,
           LEAD(LOWER(status)) OVER (PARTITION BY LOWER(author) ORDER BY deploy_at) AS next_status
    FROM deploy_logs
)
SELECT COUNT(DISTINCT author) AS recovery_count
FROM ordered_deploys
WHERE status = 'rolled_back' AND next_status = 'success'
