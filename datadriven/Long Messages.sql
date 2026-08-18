-- ======================================================================
-- Long Messages
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/long_messages
-- ======================================================================

/*
The code quality team suspects some commits are low-effort one-liners. Find every commit whose message is longer than 10 characters, skipping rows with no message. Return the author, message, and its length.

Table: repo_commits(commit_id, repo_name, author, message, added, removed, commit_at)

Sample data - repo_commits ['commit_id', 'repo_name', 'author', 'message', 'added', 'removed', 'commit_at']:
  [3061, 'backend-api', 'bob', 'Add unit tests', 17, 7, '2026-02-02 01:09:00']
  [3122, 'infra', 'charlie', 'Refactor auth module', 34, 14, '2026-03-03 02:18:00']
  [3183, 'ml-pipeline', 'dana', 'Update deps', 51, 21, '2026-04-04 03:27:00']
  [3244, 'mobile-app', 'eve', 'Improve perf', 68, 28, '2026-05-05 04:36:00']
  [3305, 'data-platform', 'frank', 'Add caching layer', 85, 35, '2026-06-06 05:45:00']

Expected output ['author', 'message', 'message_length']:
  ['Alice', 'Refactor auth module', 20]
  ['Alice', 'Add search endpoint', 19]
  ['Alice', 'Fix typo in readme', 18]
  ['Alice', 'Add caching layer', 17]
  ['Alice', 'Add unit tests', 14]
*/


-- Write your SQL solution below:

WITH cleaned AS (
    SELECT
        author,
        message,
        NULLIF(TRIM(message), '') AS effective_message
    FROM repo_commits
)
SELECT
    author,
    message,
    LENGTH(message) AS message_length
FROM cleaned
WHERE effective_message IS NOT NULL
  AND LENGTH(effective_message) > 10
ORDER BY message_length DESC, author ASC, message ASC;
