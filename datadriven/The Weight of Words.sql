-- ======================================================================
-- The Weight of Words
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/message_length
-- ======================================================================

/*
An engineering manager wants to test a hunch that authors who write longer commit messages tend to ship riskier changes. For each author, find the average commit message length, the number of commits, and the average lines added per commit, ignoring commits that have no message. Keep only authors with more than two commits, longest average message first.

Table: repo_commits(commit_id, repo_name, author, message, added, removed, commit_at)

Sample data - repo_commits ['commit_id', 'repo_name', 'author', 'message', 'added', 'removed', 'commit_at']:
  [3061, 'backend-api', 'bob', 'Add unit tests', 17, 7, '2026-02-02 01:09:00']
  [3122, 'infra', 'charlie', 'Refactor auth module', 34, 14, '2026-03-03 02:18:00']
  [3183, 'ml-pipeline', 'dana', 'Update deps', 51, 21, '2026-04-04 03:27:00']
  [3244, 'mobile-app', 'eve', 'Improve perf', 68, 28, '2026-05-05 04:36:00']
  [3305, 'data-platform', 'frank', 'Add caching layer', 85, 35, '2026-06-06 05:45:00']

Expected output ['author', 'avg_msg_len', 'commit_count', 'avg_lines_added']:
  ['alice', 14.65, 40, 230.6]
  ['charlie', 14.55, 22, 238.73]
  ['dana', 14.55, 22, 243]
  ['bob', 14.33, 42, 234.33]
  ['frank', 14.1, 20, 251.4]
*/


-- Write your SQL solution below:

SELECT
    LOWER(author) AS author,
    ROUND(AVG(LENGTH(message)), 2) AS avg_msg_len,
    COUNT(*) AS commit_count,
    ROUND(AVG(added), 2) AS avg_lines_added
FROM repo_commits
WHERE message IS NOT NULL AND LENGTH(message) > 0
GROUP BY LOWER(author)
HAVING COUNT(*) > 2
ORDER BY avg_msg_len DESC, author;
