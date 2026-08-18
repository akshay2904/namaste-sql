-- ======================================================================
-- The Merge Counter
-- ======================================================================
-- Difficulty : Easy
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/the_merge_counter
-- ======================================================================

/*
The platform team wants to compare automated build activity on main against the release branch for 2026. Treat any build whose trigger isn't 'manual' as a merge build. For each branch, show how many merge builds happened, expressed both as a whole number and as a decimal, plus the average build duration.

Table: ci_builds(build_id, repo_name, branch, status, dur_secs, trigger, built_at)

Sample data - ci_builds ['build_id', 'repo_name', 'branch', 'status', 'dur_secs', 'trigger', 'built_at']:
  [5047, 'backend-api', 'develop', 'failed', 34, 'pull_request', '2026-02-02 01:13:00']
  [5094, 'infra', 'feature/auth', 'canceled', 53, 'schedule', '2026-03-03 02:26:00']
  [5141, 'ml-pipeline', 'fix/login-bug', 'running', 72, 'manual', '2026-04-04 03:39:00']
  [5188, 'mobile-app', 'release/v2.0', 'queued', 91, 'tag', '2026-05-05 04:52:00']
  [5235, 'data-platform', 'hotfix/payment', 'success', 110, 'webhook', '2026-06-06 05:05:00']

Expected output ['branch', 'build_count', 'build_count_decimal', 'avg_duration']:
  ['main', 14, 14, 412.5]
  ['release', 0, 0, None]
*/


-- Write your SQL solution below:

SELECT 'main' AS branch,
       COUNT(*) AS build_count,
       CAST(COUNT(*) AS REAL) AS build_count_decimal,
       AVG(dur_secs) AS avg_duration
FROM ci_builds
WHERE trigger != 'manual'
  AND strftime('%Y', built_at) = '2026'
  AND branch = 'main'
UNION
SELECT 'release' AS branch,
       COUNT(*) AS build_count,
       CAST(COUNT(*) AS REAL) AS build_count_decimal,
       AVG(dur_secs) AS avg_duration
FROM ci_builds
WHERE trigger != 'manual'
  AND strftime('%Y', built_at) = '2026'
  AND branch = 'release'
