-- ======================================================================
-- Top Commit Authors by Repo
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_commit_authors_by_repo
-- ======================================================================

/*
Find the top 3 commit authors in each repo by average lines added. In case of a tie, break by author name alphabetically. Show each repo with its best, second-best, and third-best authors. If a position is unfilled, label it accordingly (e.g., 'No second author'). Format each entry as 'author (avg_added)'. Round to 1 decimal place.

Table: repo_commits(commit_id, repo_name, author, message, added, removed, commit_at)

Sample data - repo_commits ['commit_id', 'repo_name', 'author', 'message', 'added', 'removed', 'commit_at']:
  [3061, 'backend-api', 'bob', 'Add unit tests', 17, 7, '2026-02-02 01:09:00']
  [3122, 'infra', 'charlie', 'Refactor auth module', 34, 14, '2026-03-03 02:18:00']
  [3183, 'ml-pipeline', 'dana', 'Update deps', 51, 21, '2026-04-04 03:27:00']
  [3244, 'mobile-app', 'eve', 'Improve perf', 68, 28, '2026-05-05 04:36:00']
  [3305, 'data-platform', 'frank', 'Add caching layer', 85, 35, '2026-06-06 05:45:00']

Expected output ['repo_name', 'best_author', 'second_best_author', 'third_best_author']:
  ['backend-api', 'bob (233.0)', 'Bob (231.0)', 'frank (208.0)']
  ['data-platform', 'frank (322.0)', 'Bob (253.0)', 'dana (174.0)']
  ['frontend', 'alice (270.0)', 'Alice (214.0)', 'eve (191.0)']
  ['infra', 'charlie (250.0)', 'alice (248.0)', 'Alice (225.0)']
  ['ml-pipeline', 'dana (267.0)', 'bob (265.0)', 'Bob (242.0)']
*/


-- Write your SQL solution below:

WITH author_stats AS (
  SELECT repo_name, author, AVG(added) AS avg_added,
         ROW_NUMBER() OVER (PARTITION BY repo_name
                            ORDER BY AVG(added) DESC, author ASC) AS rn
  FROM repo_commits
  GROUP BY repo_name, author
)
SELECT repo_name,
       COALESCE(MAX(CASE WHEN rn = 1 THEN author || ' (' || CAST(ROUND(avg_added, 1) AS TEXT) || ')' END), 'No first author')  AS best_author,
       COALESCE(MAX(CASE WHEN rn = 2 THEN author || ' (' || CAST(ROUND(avg_added, 1) AS TEXT) || ')' END), 'No second author') AS second_best_author,
       COALESCE(MAX(CASE WHEN rn = 3 THEN author || ' (' || CAST(ROUND(avg_added, 1) AS TEXT) || ')' END), 'No third author') AS third_best_author
FROM author_stats
WHERE rn <= 3
GROUP BY repo_name
