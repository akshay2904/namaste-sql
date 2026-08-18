-- ======================================================================
-- Top Committers in 2025
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_committers
-- ======================================================================

/*
The engineering analytics team is identifying the developer who most consistently lands big commits. Within 2025, group commits by month, then within each month rank them by lines added (largest first, no skipped ranks). For each author, count how many times they appear in a month's top ten across the year. Return the single author with the highest count, with ties broken alphabetically.

Table: repo_commits(commit_id, repo_name, author, message, added, removed, commit_at)

Sample data - repo_commits ['commit_id', 'repo_name', 'author', 'message', 'added', 'removed', 'commit_at']:
  [3061, 'backend-api', 'bob', 'Add unit tests', 17, 7, '2026-02-02 01:09:00']
  [3122, 'infra', 'charlie', 'Refactor auth module', 34, 14, '2026-03-03 02:18:00']
  [3183, 'ml-pipeline', 'dana', 'Update deps', 51, 21, '2026-04-04 03:27:00']
  [3244, 'mobile-app', 'eve', 'Improve perf', 68, 28, '2026-05-05 04:36:00']
  [3305, 'data-platform', 'frank', 'Add caching layer', 85, 35, '2026-06-06 05:45:00']

Expected output ['author', 'top10_count']:
  ['eve', 3]
*/


-- Write your SQL solution below:

WITH monthly_ranked AS (
    SELECT
        author,
        DATE_TRUNC('month', commit_at) AS commit_month,
        DENSE_RANK() OVER (
            PARTITION BY DATE_TRUNC('month', commit_at)
            ORDER BY added DESC
        ) AS month_rank
    FROM repo_commits
    WHERE EXTRACT(YEAR FROM commit_at) = 2025
),
top10_appearances AS (
    SELECT DISTINCT author, commit_month
    FROM monthly_ranked
    WHERE month_rank <= 10
)
SELECT
    author,
    COUNT(*) AS top10_count
FROM top10_appearances
GROUP BY author
ORDER BY top10_count DESC, author ASC
LIMIT 1;
