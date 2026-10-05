-- ======================================================================
-- Against the Clock
-- ======================================================================
-- Difficulty : Medium
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/yearly_build_duration_by_repo
-- ======================================================================

/*
The platform team is checking whether CI builds have crept slower across the years in each repository. Give the average build duration per repository and calendar year, slowest average first.

Table: ci_builds(build_id, repo_name, branch, status, dur_secs, trigger, built_at)

Sample data - ci_builds ['build_id', 'repo_name', 'branch', 'status', 'dur_secs', 'trigger', 'built_at']:
  [5047, 'backend-api', 'develop', 'failed', 34, 'pull_request', '2026-02-02 01:13:00']
  [5094, 'infra', 'feature/auth', 'canceled', 53, 'schedule', '2026-03-03 02:26:00']
  [5141, 'ml-pipeline', 'fix/login-bug', 'running', 72, 'manual', '2026-04-04 03:39:00']
  [5188, 'mobile-app', 'release/v2.0', 'queued', 91, 'tag', '2026-05-05 04:52:00']
  [5235, 'data-platform', 'hotfix/payment', 'success', 110, 'webhook', '2026-06-06 05:05:00']

Expected output ['repo_name', 'build_year', 'avg_duration']:
  ['data-platform', '2023', 608]
  ['mobile-app', '2022', 589]
  ['infra', '2025', 551]
  ['backend-api', '2024', 532]
  ['ml-pipeline', '2026', 471.9]
*/


-- Write your SQL solution below:

SELECT
    repo_name,
    STRFTIME('%Y', built_at) AS build_year,
    AVG(dur_secs) AS avg_duration
FROM ci_builds
GROUP BY repo_name, STRFTIME('%Y', built_at)
ORDER BY avg_duration DESC, repo_name, build_year
