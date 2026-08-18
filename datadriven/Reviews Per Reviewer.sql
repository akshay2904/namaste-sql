-- ======================================================================
-- Reviews Per Reviewer
-- ======================================================================
-- Difficulty : Easy
-- Company    : General Assembly
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/reviews_per_reviewer
-- ======================================================================

/*
The engineering manager is balancing review workloads and needs to see how many code reviews each reviewer is currently carrying.

Table: code_reviews(review_id, repo_name, author, reviewer, status, comments, opened_at, merged)

Sample data - code_reviews ['review_id', 'repo_name', 'author', 'reviewer', 'status', 'comments', 'opened_at', 'merged']:
  [1053, 'backend-api', 'bob', 'eve', 'changes_requested', 3, '2026-02-02', '2026-02-05']
  [1106, 'infra', 'charlie', 'frank', 'pending', 6, '2026-03-03', '2026-03-06']
  [1159, 'ml-pipeline', 'dana', 'grace', 'Approved', 9, '2026-04-04', '2026-04-07']
  [1212, 'mobile-app', 'eve', 'hank', 'PENDING', 12, '2026-05-05', None]
  [1265, 'data-platform', 'frank', 'alice', 'merged', 15, '2026-06-06', '2026-06-09']

Expected output ['reviewer', 'review_count']:
  [None, 24]
  ['alice', 24]
  ['bob', 24]
  ['eve', 26]
  ['frank', 26]
*/


-- Write your SQL solution below:

SELECT reviewer, COUNT(*) AS review_count
FROM code_reviews
GROUP BY reviewer
