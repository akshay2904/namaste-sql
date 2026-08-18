-- ======================================================================
-- Prolific Authors in Largest Service Teams
-- ======================================================================
-- Difficulty : Medium
-- Company    : Zenefits
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/prolific_authors_in_largest_service_teams
-- ======================================================================

/*
Find authors whose name starts with 'a' (case-insensitive) who belong to the service(s) with the most unique authors. If multiple services tie for largest team, include matching authors from all of them. Return the service name and author.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['svc_name', 'author']:
  ['analytics', 'Alice']
  ['auth-svc', 'alice']
*/


-- Write your SQL solution below:

SELECT DISTINCT svc_name, author FROM deploy_logs WHERE LOWER(author) LIKE 'a%' AND svc_name IN (SELECT svc_name FROM deploy_logs GROUP BY svc_name HAVING COUNT(DISTINCT LOWER(author)) = (SELECT MAX(author_count) FROM (SELECT COUNT(DISTINCT LOWER(author)) AS author_count FROM deploy_logs GROUP BY svc_name))) ORDER BY svc_name, author
