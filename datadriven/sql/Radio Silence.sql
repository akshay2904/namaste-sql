-- ======================================================================
-- Radio Silence
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/commit_cadence
-- ======================================================================

/*
An engineering manager is auditing repositories that have gone quiet, where a repository's longest silence is the widest stretch of days between two back-to-back commits. Commit timestamps are stored as text and the queries run on SQLite, so the day count has to come out of the stored timestamps. Surface the repositories whose longest silence runs past 5 days, ordered from the most silent down, and number the standings as you go.

Table: repo_commits(commit_id, repo_name, author, message, added, removed, commit_at)

Sample data - repo_commits ['commit_id', 'repo_name', 'author', 'message', 'added', 'removed', 'commit_at']:
  [3061, 'backend-api', 'bob', 'Add unit tests', 17, 7, '2026-02-02 01:09:00']
  [3122, 'infra', 'charlie', 'Refactor auth module', 34, 14, '2026-03-03 02:18:00']
  [3183, 'ml-pipeline', 'dana', 'Update deps', 51, 21, '2026-04-04 03:27:00']
  [3244, 'mobile-app', 'eve', 'Improve perf', 68, 28, '2026-05-05 04:36:00']
  [3305, 'data-platform', 'frank', 'Add caching layer', 85, 35, '2026-06-06 05:45:00']

Expected output ['repo_name', 'longest_silence', 'silence_rank']:
  ['backend-api', 189.24583333311602, 1]
  ['frontend', 188.2458333335817, 2]
  ['data-platform', 187.28750000009313, 3]
  ['mobile-app', 187.2458333335817, 4]
  ['ml-pipeline', 183.74583333311602, 5]
*/


-- Write your SQL solution below:

WITH gaps AS (
    SELECT
        repo_name,
        julianday(commit_at) - julianday(LAG(commit_at) OVER (PARTITION BY repo_name ORDER BY commit_at)) AS gap_days
    FROM repo_commits
)
SELECT
    repo_name,
    MAX(gap_days) AS longest_silence,
    DENSE_RANK() OVER (ORDER BY MAX(gap_days) DESC) AS silence_rank
FROM gaps
WHERE gap_days IS NOT NULL
GROUP BY repo_name
HAVING MAX(gap_days) > 5
ORDER BY longest_silence DESC, repo_name
