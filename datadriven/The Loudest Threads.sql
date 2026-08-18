-- ======================================================================
-- The Loudest Threads
-- ======================================================================
-- Difficulty : Medium
-- Company    : Yelp
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/most_commented_code_review
-- ======================================================================

/*
A platform team is reviewing which code reviews sparked the most back-and-forth this cycle. Return the repo name and author for the three reviews that drew the most comments, most discussed first.

Table: code_reviews(review_id, repo_name, author, reviewer, status, comments, opened_at, merged)

Sample data - code_reviews ['review_id', 'repo_name', 'author', 'reviewer', 'status', 'comments', 'opened_at', 'merged']:
  [1053, 'backend-api', 'bob', 'eve', 'changes_requested', 3, '2026-02-02', '2026-02-05']
  [1106, 'infra', 'charlie', 'frank', 'pending', 6, '2026-03-03', '2026-03-06']
  [1159, 'ml-pipeline', 'dana', 'grace', 'Approved', 9, '2026-04-04', '2026-04-07']
  [1212, 'mobile-app', 'eve', 'hank', 'PENDING', 12, '2026-05-05', None]
  [1265, 'data-platform', 'frank', 'alice', 'merged', 15, '2026-06-06', '2026-06-09']

Expected output ['repo_name', 'author']:
  ['infra', 'grace']
  ['data-platform', 'frank']
  ['data-platform', 'dana']
*/


-- Write your SQL solution below:

SELECT repo_name, author
FROM code_reviews
ORDER BY comments DESC, review_id
LIMIT 3
