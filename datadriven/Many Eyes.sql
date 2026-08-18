-- ======================================================================
-- Many Eyes
-- ======================================================================
-- Difficulty : Medium
-- Company    : BuzzFeed
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/reviewers_per_repo_per_year
-- ======================================================================

/*
We're mapping how review attention spread across each codebase year over year. For every repo in a given year, find how many different people reviewed its code, and surface the pairings with the most reviewers first.

Table: code_reviews(review_id, repo_name, author, reviewer, status, comments, opened_at, merged)

Sample data - code_reviews ['review_id', 'repo_name', 'author', 'reviewer', 'status', 'comments', 'opened_at', 'merged']:
  [1053, 'backend-api', 'bob', 'eve', 'changes_requested', 3, '2026-02-02', '2026-02-05']
  [1106, 'infra', 'charlie', 'frank', 'pending', 6, '2026-03-03', '2026-03-06']
  [1159, 'ml-pipeline', 'dana', 'grace', 'Approved', 9, '2026-04-04', '2026-04-07']
  [1212, 'mobile-app', 'eve', 'hank', 'PENDING', 12, '2026-05-05', None]
  [1265, 'data-platform', 'frank', 'alice', 'merged', 15, '2026-06-06', '2026-06-09']

Expected output ['repo_name', 'review_year', 'reviewer_count']:
  ['backend-api', 2022, 4]
  ['backend-api', 2023, 4]
  ['backend-api', 2026, 4]
  ['ml-pipeline', 2024, 4]
  ['ml-pipeline', 2025, 4]
*/


-- Write your SQL solution below:

SELECT repo_name, CAST(strftime('%Y', opened_at) AS INTEGER) AS review_year, COUNT(DISTINCT reviewer) AS reviewer_count
FROM code_reviews
GROUP BY repo_name, review_year
ORDER BY reviewer_count DESC
