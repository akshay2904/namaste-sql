-- ======================================================================
-- Build Success Rate by Trigger
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/build_success_rate_by_trigger
-- ======================================================================

/*
The CI/CD team suspects that manual triggers fail more often than automated ones. For each trigger type, show the total number of builds and the fraction with a status of 'success', expressed as a decimal.

Table: ci_builds(build_id, repo_name, branch, status, dur_secs, trigger, built_at)

Sample data - ci_builds ['build_id', 'repo_name', 'branch', 'status', 'dur_secs', 'trigger', 'built_at']:
  [5047, 'backend-api', 'develop', 'failed', 34, 'pull_request', '2026-02-02 01:13:00']
  [5094, 'infra', 'feature/auth', 'canceled', 53, 'schedule', '2026-03-03 02:26:00']
  [5141, 'ml-pipeline', 'fix/login-bug', 'running', 72, 'manual', '2026-04-04 03:39:00']
  [5188, 'mobile-app', 'release/v2.0', 'queued', 91, 'tag', '2026-05-05 04:52:00']
  [5235, 'data-platform', 'hotfix/payment', 'success', 110, 'webhook', '2026-06-06 05:05:00']

Expected output ['trigger', 'total_builds', 'success_rate']:
  ['manual', 34, 0.17647058823529413]
  ['pull_request', 34, 0.17647058823529413]
  ['push', 32, 0.1875]
  ['schedule', 34, 0.17647058823529413]
  ['webhook', 32, 0.25]
*/


-- Write your SQL solution below:

SELECT
    trigger,
    COUNT(*) AS total_builds,
    CAST(SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) AS REAL)
      / COUNT(*) AS success_rate
FROM ci_builds
GROUP BY trigger
