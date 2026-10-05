-- ======================================================================
-- Super Reviewers
-- ======================================================================
-- Difficulty : Medium
-- Company    : Walmart
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/super_reviewers
-- ======================================================================

/*
The engineering manager is identifying super reviewers who carry a disproportionate review load. Find reviewers who have reviewed at least 7 pull requests, including cases where the author and reviewer are the same person.

Table: code_reviews(review_id, repo_name, author, reviewer, status, comments, opened_at, merged)

Sample data - code_reviews ['review_id', 'repo_name', 'author', 'reviewer', 'status', 'comments', 'opened_at', 'merged']:
  [1053, 'backend-api', 'bob', 'eve', 'changes_requested', 3, '2026-02-02', '2026-02-05']
  [1106, 'infra', 'charlie', 'frank', 'pending', 6, '2026-03-03', '2026-03-06']
  [1159, 'ml-pipeline', 'dana', 'grace', 'Approved', 9, '2026-04-04', '2026-04-07']
  [1212, 'mobile-app', 'eve', 'hank', 'PENDING', 12, '2026-05-05', None]
  [1265, 'data-platform', 'frank', 'alice', 'merged', 15, '2026-06-06', '2026-06-09']

Expected output ['reviewer', 'review_count']:
  ['hank', 26]
  ['grace', 26]
  ['frank', 26]
  ['charlie', 24]
  ['bob', 24]
*/


-- Write your SQL solution below:

SELECT reviewer, COUNT(*) AS review_count
FROM code_reviews
WHERE reviewer IS NOT NULL
GROUP BY reviewer
HAVING COUNT(*) >= 7
ORDER BY review_count DESC
