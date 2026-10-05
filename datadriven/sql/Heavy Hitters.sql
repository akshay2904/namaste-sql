-- ======================================================================
-- Heavy Hitters
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/heavy_hitters
-- ======================================================================

/*
The eng director wants to spot repos with higher-than-average activity. Count commits per repo in repo_commits, compare against the overall average commits per repo across the table, and keep repos that exceed it. Return the repo_name and its commit count.

Table: repo_commits(commit_id, repo_name, author, message, added, removed, commit_at)

Sample data - repo_commits ['commit_id', 'repo_name', 'author', 'message', 'added', 'removed', 'commit_at']:
  [3061, 'backend-api', 'bob', 'Add unit tests', 17, 7, '2026-02-02 01:09:00']
  [3122, 'infra', 'charlie', 'Refactor auth module', 34, 14, '2026-03-03 02:18:00']
  [3183, 'ml-pipeline', 'dana', 'Update deps', 51, 21, '2026-04-04 03:27:00']
  [3244, 'mobile-app', 'eve', 'Improve perf', 68, 28, '2026-05-05 04:36:00']
  [3305, 'data-platform', 'frank', 'Add caching layer', 85, 35, '2026-06-06 05:45:00']

Expected output ['repo_name', 'commit_count']:
  ['backend-api', 34]
  ['infra', 34]
  ['ml-pipeline', 34]
  ['mobile-app', 34]
*/


-- Write your SQL solution below:

WITH repo_counts AS (
    SELECT repo_name, COUNT(*) AS commit_count
    FROM repo_commits
    GROUP BY repo_name
)
SELECT repo_name, commit_count
FROM repo_counts
WHERE commit_count > (SELECT AVG(commit_count) FROM repo_counts)
ORDER BY commit_count DESC
