-- ======================================================================
-- Tenure Mentorship Match
-- ======================================================================
-- Difficulty : Medium
-- Company    : Stitch Fix
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/tenure_mentorship_match
-- ======================================================================

/*
The engineering org is piloting a mentorship program that pairs each engineer with the most tenured colleague on the same service, using the earliest deployment timestamp as a proxy for tenure. For each author, show them alongside their service's most tenured deployer.

Table: deploy_logs(log_id, svc_name, version, env_name, status, deploy_at, dur_secs, author)

Sample data - deploy_logs ['log_id', 'svc_name', 'version', 'env_name', 'status', 'deploy_at', 'dur_secs', 'author']:
  [131, 'payment-api', 'v1.0.2', 'staging', 'failed', '2026-02-02 01:11:00', 23, 'bob']
  [162, 'user-svc', 'v1.1.0', 'dev', 'rolled_back', '2026-03-03 02:22:00', 36, 'charlie']
  [193, 'search-api', '2.0.0', 'canary', 'in_progress', '2026-04-04 03:33:00', 49, 'dana']
  [224, 'gateway', 'v2.1.0', 'Production', 'Success', '2026-05-05 04:44:00', 62, 'eve']
  [255, 'notif-svc', '2.1.1', 'STAGING', 'FAILED', '2026-06-06 05:55:00', 75, 'frank']

Expected output ['author', 'svc_name', 'most_tenured_author']:
  ['Alice', 'analytics', 'Alice']
  ['alice', 'auth-svc', 'alice']
  ['eve', 'gateway', 'eve']
  ['BOB', 'ml-serving', 'BOB']
  ['frank', 'notif-svc', 'frank']
*/


-- Write your SQL solution below:

WITH svc_senior AS (
    SELECT
        svc_name,
        author AS most_tenured_author,
        ROW_NUMBER() OVER (PARTITION BY svc_name ORDER BY deploy_at ASC) AS rn
    FROM deploy_logs
)
SELECT
    e.author,
    e.svc_name,
    s.most_tenured_author
FROM deploy_logs e
JOIN svc_senior s
    ON e.svc_name = s.svc_name
    AND s.rn = 1
ORDER BY e.svc_name, e.author, e.log_id
