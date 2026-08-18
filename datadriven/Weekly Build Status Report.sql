-- ======================================================================
-- Weekly Build Status Report
-- ======================================================================
-- Difficulty : Hard
-- Company    : Amazon
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/weekly_order_status_report
-- ======================================================================

/*
The platform reliability team wants a weekly build health summary. For each week in 2026 (starting Sunday), count CI builds by final status: success, failed, and canceled. Show the week start date and counts for each status.

Table: ci_builds(build_id, repo_name, branch, status, dur_secs, trigger, built_at)

Sample data - ci_builds ['build_id', 'repo_name', 'branch', 'status', 'dur_secs', 'trigger', 'built_at']:
  [5047, 'backend-api', 'develop', 'failed', 34, 'pull_request', '2026-02-02 01:13:00']
  [5094, 'infra', 'feature/auth', 'canceled', 53, 'schedule', '2026-03-03 02:26:00']
  [5141, 'ml-pipeline', 'fix/login-bug', 'running', 72, 'manual', '2026-04-04 03:39:00']
  [5188, 'mobile-app', 'release/v2.0', 'queued', 91, 'tag', '2026-05-05 04:52:00']
  [5235, 'data-platform', 'hotfix/payment', 'success', 110, 'webhook', '2026-06-06 05:05:00']

Expected output ['week_start', 'success_count', 'failed_count', 'canceled_count']:
  ['2025-12-29', 1, 0, 0]
  ['2026-01-05', 1, 1, 0]
  ['2026-01-12', 0, 1, 2]
  ['2026-02-23', 2, 0, 0]
  ['2026-04-13', 3, 0, 0]
*/


-- Write your SQL solution below:

WITH weekly AS (
    SELECT
        date(built_at, 'weekday 0', '-6 days') AS week_start,
        status
    FROM ci_builds
    WHERE built_at BETWEEN '2026-01-01' AND '2026-12-31'
      AND status IN ('success', 'failed', 'canceled')
)
SELECT
    week_start,
    SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) AS success_count,
    SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) AS failed_count,
    SUM(CASE WHEN status = 'canceled' THEN 1 ELSE 0 END) AS canceled_count
FROM weekly
GROUP BY week_start
ORDER BY week_start
