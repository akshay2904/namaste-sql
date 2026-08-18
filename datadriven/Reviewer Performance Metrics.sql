-- ======================================================================
-- Reviewer Performance Metrics
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/reviewer_performance_metrics
-- ======================================================================

/*
For each reviewer who has reviewed at least one merged pull request (a PR with a non-null merged date), show the total number of unique repos reviewed, total repos where the PR was merged, and the latest review date.

Table: code_reviews(review_id, repo_name, author, reviewer, status, comments, opened_at, merged)

Sample data - code_reviews ['review_id', 'repo_name', 'author', 'reviewer', 'status', 'comments', 'opened_at', 'merged']:
  [1053, 'backend-api', 'bob', 'eve', 'changes_requested', 3, '2026-02-02', '2026-02-05']
  [1106, 'infra', 'charlie', 'frank', 'pending', 6, '2026-03-03', '2026-03-06']
  [1159, 'ml-pipeline', 'dana', 'grace', 'Approved', 9, '2026-04-04', '2026-04-07']
  [1212, 'mobile-app', 'eve', 'hank', 'PENDING', 12, '2026-05-05', None]
  [1265, 'data-platform', 'frank', 'alice', 'merged', 15, '2026-06-06', '2026-06-09']

Expected output ['reviewer', 'reviewed_count', 'merged_count', 'latest_review_date']:
  ['alice', 3, 3, '2026-10-22']
  ['bob', 3, 3, '2026-11-23']
  ['charlie', 3, 3, '2026-12-24']
  ['eve', 3, 3, '2026-10-26']
  ['frank', 3, 3, '2026-11-27']
*/


-- Write your SQL solution below:

SELECT reviewer, COUNT(DISTINCT repo_name) AS reviewed_count,
    COUNT(DISTINCT CASE WHEN merged IS NOT NULL THEN repo_name END) AS merged_count,
    MAX(opened_at) AS latest_review_date
FROM code_reviews
WHERE reviewer IS NOT NULL
GROUP BY reviewer
HAVING SUM(CASE WHEN merged IS NOT NULL THEN 1 ELSE 0 END) >= 1
ORDER BY reviewer
