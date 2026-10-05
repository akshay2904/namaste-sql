-- ======================================================================
-- Commit Royalty
-- ======================================================================
-- Difficulty : Medium
-- Company    : Spotify
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/commit_royalty
-- ======================================================================

/*
Rank commits by lines added each month in 2025, then count how many times each author placed in the top 10. Show the author with the highest count.

Table: repo_commits(commit_id, repo_name, author, message, added, removed, commit_at)

Sample data - repo_commits ['commit_id', 'repo_name', 'author', 'message', 'added', 'removed', 'commit_at']:
  [3061, 'backend-api', 'bob', 'Add unit tests', 17, 7, '2026-02-02 01:09:00']
  [3122, 'infra', 'charlie', 'Refactor auth module', 34, 14, '2026-03-03 02:18:00']
  [3183, 'ml-pipeline', 'dana', 'Update deps', 51, 21, '2026-04-04 03:27:00']
  [3244, 'mobile-app', 'eve', 'Improve perf', 68, 28, '2026-05-05 04:36:00']
  [3305, 'data-platform', 'frank', 'Add caching layer', 85, 35, '2026-06-06 05:45:00']

Expected output ['author', 'top10_count']:
  ['Alice', 3]
*/


-- Write your SQL solution below:

WITH monthly_ranked AS (
  SELECT author, added,
         DENSE_RANK() OVER (PARTITION BY strftime('%Y-%m', commit_at) ORDER BY added DESC) AS rnk
  FROM repo_commits
  WHERE strftime('%Y', commit_at) = '2025'
)
SELECT author, COUNT(*) AS top10_count
FROM monthly_ranked
WHERE rnk <= 10
GROUP BY author
ORDER BY top10_count DESC, author ASC
LIMIT 1
