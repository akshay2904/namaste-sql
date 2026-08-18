-- ======================================================================
-- Fresh Ink
-- ======================================================================
-- Difficulty : Medium
-- Company    : Spotify
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/most_active_recent_committers
-- ======================================================================

/*
We keep a table of repository commits, each stamped with its author and commit date. Counting only commits from the three most recent calendar years present in the data (the year of the latest commit and the two years before it), find the ten authors with the most commits. Return each author with their commit count, most active first.

Table: repo_commits(commit_id, repo_name, author, message, added, removed, commit_at)

Sample data - repo_commits ['commit_id', 'repo_name', 'author', 'message', 'added', 'removed', 'commit_at']:
  [3061, 'backend-api', 'bob', 'Add unit tests', 17, 7, '2026-02-02 01:09:00']
  [3122, 'infra', 'charlie', 'Refactor auth module', 34, 14, '2026-03-03 02:18:00']
  [3183, 'ml-pipeline', 'dana', 'Update deps', 51, 21, '2026-04-04 03:27:00']
  [3244, 'mobile-app', 'eve', 'Improve perf', 68, 28, '2026-05-05 04:36:00']
  [3305, 'data-platform', 'frank', 'Add caching layer', 85, 35, '2026-06-06 05:45:00']

Expected output ['author', 'commit_count']:
  ['eve', 21]
  ['dana', 21]
  ['frank', 20]
  ['bob', 20]
  ['alice', 19]
*/


-- Write your SQL solution below:

SELECT author, COUNT(*) AS commit_count FROM repo_commits WHERE CAST(strftime('%Y', commit_at) AS INTEGER) >= (SELECT CAST(strftime('%Y', MAX(commit_at)) AS INTEGER) - 2 FROM repo_commits) GROUP BY author ORDER BY commit_count DESC LIMIT 10
