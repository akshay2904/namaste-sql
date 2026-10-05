-- ======================================================================
-- Deploy Author Performance Score
-- ======================================================================
-- Difficulty : Medium
-- Company    : Spotify
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/deploy_author_performance_score
-- ======================================================================

/*
The platform team wants a reliability scorecard for everyone who has shipped deploys, treating author names that differ only in capitalization as the same person. Score each author as (100 minus their average deploy duration) multiplied by their number of deploys, counting only deploys from the most recent calendar year present in the log and the year before it. Return each author with their average duration and score (both rounded to two decimals) plus their standing from the strongest score to the weakest.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['author', 'avg_duration', 'score', 'rnk']:
  ['dana', 253.8, -2768.4, 1]
  ['eve', 278.5, -3391.5, 2]
  ['charlie', 296.5, -3537, 3]
  ['frank', 316.6, -3682.2, 4]
  ['bob', 294.29, -6800.16, 5]
*/


-- Write your SQL solution below:

WITH author_stats AS (SELECT LOWER(author) AS author, ROUND(AVG(dur_secs), 2) AS avg_duration, COUNT(*) AS deploy_count, ROUND((100 - AVG(dur_secs)) * COUNT(*), 2) AS score FROM deploy_logs WHERE strftime('%Y', deploy_at) >= CAST((SELECT CAST(strftime('%Y', MAX(deploy_at)) AS INTEGER) - 1 FROM deploy_logs) AS TEXT) GROUP BY LOWER(author)) SELECT author, avg_duration, score, DENSE_RANK() OVER (ORDER BY score DESC) AS rnk FROM author_stats ORDER BY score DESC
