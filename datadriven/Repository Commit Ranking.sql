-- ======================================================================
-- Repository Commit Ranking
-- ======================================================================
-- Difficulty : Medium
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/repository_commit_ranking
-- ======================================================================

/*
Sum the lines added per repository across all commits, then rank them with no gaps in ranking. Show repo name, total lines added, and rank from highest to lowest.

Table: repo_commits(commit_id, repo_name, author, message, added, removed, commit_at)

Sample data - repo_commits ['commit_id', 'repo_name', 'author', 'message', 'added', 'removed', 'commit_at']:
  [3061, 'backend-api', 'bob', 'Add unit tests', 17, 7, '2026-02-02 01:09:00']
  [3122, 'infra', 'charlie', 'Refactor auth module', 34, 14, '2026-03-03 02:18:00']
  [3183, 'ml-pipeline', 'dana', 'Update deps', 51, 21, '2026-04-04 03:27:00']
  [3244, 'mobile-app', 'eve', 'Improve perf', 68, 28, '2026-05-05 04:36:00']
  [3305, 'data-platform', 'frank', 'Add caching layer', 85, 35, '2026-06-06 05:45:00']

Expected output ['repo_name', 'total_added', 'rank']:
  ['mobile-app', 9056, 1]
  ['ml-pipeline', 8478, 2]
  ['infra', 7900, 3]
  ['backend-api', 7322, 4]
  ['data-platform', 7200, 5]
*/


-- Write your SQL solution below:

SELECT repo_name, SUM(added) AS total_added, DENSE_RANK() OVER (ORDER BY SUM(added) DESC) AS rank
FROM repo_commits
GROUP BY repo_name
ORDER BY rank
