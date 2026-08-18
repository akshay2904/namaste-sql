-- ======================================================================
-- The Blast Radius
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/deploy_reliability_scores
-- ======================================================================

/*
Every deploy record carries an author and a service, and matching a deploy to its service's health checks turns each check into a latency score for that deploy. Find the average score per author, highest first.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Table: svc_health(check_id, svc_name, status, latency, uptime, checked, region)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Sample data - svc_health ['check_id', 'svc_name', 'status', 'latency', 'uptime', 'checked', 'region']:
  [137, 'payment-api', 'degraded', 3.6, 97.03, '2026-02-02 01:05:00', 'us-west-2']
  [174, 'user-svc', 'unhealthy', 6.7, 94.06, '2026-03-03 02:10:00', 'eu-west-1']
  [211, 'search-api', 'timeout', 9.8, 91.09, '2026-04-04 03:15:00', 'ap-south-1']
  [248, 'gateway', 'Healthy', 12.9, 98.12, '2026-05-05 04:20:00', 'eu-central-1']
  [285, 'notif-svc', 'DEGRADED', 16, 95.15, '2026-06-06 05:25:00', 'us-east-1']

Expected output ['author', 'avg_score']:
  ['eve', 385.42]
  ['alice', 381.49]
  ['frank', 379.86]
  ['bob', 372.16]
  ['dana', 361.85]
*/


-- Write your SQL solution below:

SELECT
    LOWER(dl.author) AS author,
    ROUND(AVG(sh.latency), 2) AS avg_score
FROM deploy_logs dl
JOIN svc_health sh ON dl.svc_name = sh.svc_name
GROUP BY LOWER(dl.author)
ORDER BY avg_score DESC, author ASC
