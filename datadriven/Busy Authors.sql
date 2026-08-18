-- ======================================================================
-- Busy Authors
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/busy_authors
-- ======================================================================

/*
The engineering manager values developers who contribute across multiple codebases rather than siloing in one repo. Find every author who has committed to more than one repository and show how many repos they've touched.

Table: repo_commits(commit_id, repo_name, author, message, added, removed, commit_at)

Sample data - repo_commits ['commit_id', 'repo_name', 'author', 'message', 'added', 'removed', 'commit_at']:
  [3061, 'backend-api', 'bob', 'Add unit tests', 17, 7, '2026-02-02 01:09:00']
  [3122, 'infra', 'charlie', 'Refactor auth module', 34, 14, '2026-03-03 02:18:00']
  [3183, 'ml-pipeline', 'dana', 'Update deps', 51, 21, '2026-04-04 03:27:00']
  [3244, 'mobile-app', 'eve', 'Improve perf', 68, 28, '2026-05-05 04:36:00']
  [3305, 'data-platform', 'frank', 'Add caching layer', 85, 35, '2026-06-06 05:45:00']

Expected output ['author', 'repo_count']:
  ['alice', 3]
  ['bob', 3]
  ['charlie', 3]
  ['dana', 3]
  ['eve', 3]
*/


-- Write your SQL solution below:

SELECT LOWER(author) AS author,
       COUNT(DISTINCT repo_name) AS repo_count
FROM repo_commits
WHERE author IS NOT NULL AND TRIM(author) <> ''
GROUP BY LOWER(author)
HAVING COUNT(DISTINCT repo_name) > 1
ORDER BY repo_count DESC, author ASC
