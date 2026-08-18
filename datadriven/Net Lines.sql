-- ======================================================================
-- Net Lines
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/net_lines
-- ======================================================================

/*
Engineering wants to see who is growing the codebase versus trimming it. Each commit records lines added and lines removed. For each author, compute their net line contribution (total added minus total removed).

Table: repo_commits(commit_id, repo_name, author, message, added, removed, commit_at)

Sample data - repo_commits ['commit_id', 'repo_name', 'author', 'message', 'added', 'removed', 'commit_at']:
  [3061, 'backend-api', 'bob', 'Add unit tests', 17, 7, '2026-02-02 01:09:00']
  [3122, 'infra', 'charlie', 'Refactor auth module', 34, 14, '2026-03-03 02:18:00']
  [3183, 'ml-pipeline', 'dana', 'Update deps', 51, 21, '2026-04-04 03:27:00']
  [3244, 'mobile-app', 'eve', 'Improve perf', 68, 28, '2026-05-05 04:36:00']
  [3305, 'data-platform', 'frank', 'Add caching layer', 85, 35, '2026-06-06 05:45:00']

Expected output ['author', 'SUM(added) - SUM(removed)']:
  ['Alice', 3400]
  ['Bob', 3640]
  ['alice', 3880]
  ['bob', 3140]
  ['charlie', 3800]
*/


-- Write your SQL solution below:

SELECT author, SUM(added) - SUM(removed) FROM repo_commits GROUP BY author
