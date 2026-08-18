-- ======================================================================
-- Data Repo Fix Commits
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/data_repo_fix_commits
-- ======================================================================

/*
The data engineering manager is auditing how many bug-fix commits are going into data-related repos. Count commits that mention 'fix' in repos whose name contains 'data' (case-insensitive), excluding the analytics repo. Break down by repo and author, from most to fewest.

Table: repo_commits(commit_id, repo_name, author, message, added, removed, commit_at)

Sample data - repo_commits ['commit_id', 'repo_name', 'author', 'message', 'added', 'removed', 'commit_at']:
  [3061, 'backend-api', 'bob', 'Add unit tests', 17, 7, '2026-02-02 01:09:00']
  [3122, 'infra', 'charlie', 'Refactor auth module', 34, 14, '2026-03-03 02:18:00']
  [3183, 'ml-pipeline', 'dana', 'Update deps', 51, 21, '2026-04-04 03:27:00']
  [3244, 'mobile-app', 'eve', 'Improve perf', 68, 28, '2026-05-05 04:36:00']
  [3305, 'data-platform', 'frank', 'Add caching layer', 85, 35, '2026-06-06 05:45:00']

Expected output ['repo_name', 'author', 'fix_count']:
  ['data-platform', 'bob', 4]
  ['data-platform', 'Bob', 2]
  ['data-platform', 'dana', 2]
*/


-- Write your SQL solution below:

SELECT repo_name, author, COUNT(*) AS fix_count
FROM repo_commits
WHERE LOWER(repo_name) LIKE '%data%'
  AND LOWER(repo_name) NOT LIKE '%analytics%'
  AND LOWER(message) LIKE '%fix%'
GROUP BY repo_name, author
ORDER BY fix_count DESC
