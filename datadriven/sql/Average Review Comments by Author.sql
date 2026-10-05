-- ======================================================================
-- Average Review Comments by Author
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_review_comments_by_author
-- ======================================================================

/*
Engineering leadership is comparing review burden against tenure, treating each author handle as a case-sensitive identifier that must be matched exactly as it is stored. For every author who shows up in both the review log and the commit history, return the average number of comments across their code reviews alongside the date of their first commit. Present the authors starting from the longest-tenured (earliest first commit) down to the newest.

Table: code_reviews(review_id, repo_name, author, reviewer, status, comments, opened_at, merged)

Table: repo_commits(commit_id, repo_name, author, message, added, removed, commit_at)

Sample data - code_reviews ['review_id', 'repo_name', 'author', 'reviewer', 'status', 'comments', 'opened_at', 'merged']:
  [1053, 'backend-api', 'bob', 'eve', 'changes_requested', 3, '2026-02-02', '2026-02-05']
  [1106, 'infra', 'charlie', 'frank', 'pending', 6, '2026-03-03', '2026-03-06']
  [1159, 'ml-pipeline', 'dana', 'grace', 'Approved', 9, '2026-04-04', '2026-04-07']
  [1212, 'mobile-app', 'eve', 'hank', 'PENDING', 12, '2026-05-05', None]
  [1265, 'data-platform', 'frank', 'alice', 'merged', 15, '2026-06-06', '2026-06-09']

Sample data - repo_commits ['commit_id', 'repo_name', 'author', 'message', 'added', 'removed', 'commit_at']:
  [3061, 'backend-api', 'bob', 'Add unit tests', 17, 7, '2026-02-02 01:09:00']
  [3122, 'infra', 'charlie', 'Refactor auth module', 34, 14, '2026-03-03 02:18:00']
  [3183, 'ml-pipeline', 'dana', 'Update deps', 51, 21, '2026-04-04 03:27:00']
  [3244, 'mobile-app', 'eve', 'Improve perf', 68, 28, '2026-05-05 04:36:00']
  [3305, 'data-platform', 'frank', 'Add caching layer', 85, 35, '2026-06-06 05:45:00']

Expected output ['author', 'avg_comments', 'earliest_commit']:
  ['bob', 23.5, '2022-01-02 01:09:00']
  ['frank', 20.727272727272727, '2022-01-06 13:09:00']
  ['charlie', 22.25, '2022-02-27 02:54:00']
  ['dana', 19.90909090909091, '2022-03-24 03:39:00']
  ['alice', 19.363636363636363, '2022-04-17 16:24:00']
*/


-- Write your SQL solution below:

WITH review_stats AS (
    SELECT author, AVG(comments) AS avg_comments
    FROM code_reviews
    GROUP BY author
),
commit_stats AS (
    SELECT author, MIN(commit_at) AS earliest_commit
    FROM repo_commits
    GROUP BY author
)
SELECT r.author,
       r.avg_comments,
       c.earliest_commit
FROM review_stats r
JOIN commit_stats c ON r.author = c.author
ORDER BY c.earliest_commit ASC, r.author ASC;
