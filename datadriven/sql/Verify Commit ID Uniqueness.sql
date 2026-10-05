-- ======================================================================
-- Verify Commit ID Uniqueness
-- ======================================================================
-- Difficulty : Easy
-- Company    : Vesta Innovations
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/verify_commit_id_uniqueness
-- ======================================================================

/*
You suspect duplicate commit IDs crept into the repo metadata table. Show the total count of commit IDs next to the count of unique commit IDs so you can verify at a glance.

Table: repo_commits(commit_id, repo_name, author, message, added, removed, commit_at)

Sample data - repo_commits ['commit_id', 'repo_name', 'author', 'message', 'added', 'removed', 'commit_at']:
  [3061, 'backend-api', 'bob', 'Add unit tests', 17, 7, '2026-02-02 01:09:00']
  [3122, 'infra', 'charlie', 'Refactor auth module', 34, 14, '2026-03-03 02:18:00']
  [3183, 'ml-pipeline', 'dana', 'Update deps', 51, 21, '2026-04-04 03:27:00']
  [3244, 'mobile-app', 'eve', 'Improve perf', 68, 28, '2026-05-05 04:36:00']
  [3305, 'data-platform', 'frank', 'Add caching layer', 85, 35, '2026-06-06 05:45:00']

Expected output ['total_count', 'unique_count']:
  [200, 200]
*/


-- Write your SQL solution below:

SELECT
    COUNT(commit_id) AS total_count,
    COUNT(DISTINCT commit_id) AS unique_count
FROM repo_commits
