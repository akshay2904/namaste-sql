-- ======================================================================
-- 123 - Perfect Score Candidates
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Epam
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/123-perfect-score-candidates
-- ======================================================================

/*
You are given a table named assessments that contains information about candidate evaluations for various technical tasks. Each row in the table represents a candidate and includes their years of experience, along with scores for three different tasks: SQL, Algorithms, and Bug Fixing. A NULL value in any of the task columns indicates that the candidate was not required to solve that specific task.

 

Your task is to analyze this data and determine, for each experience level, the total number of candidates and how many of them achieved a "perfect score." A candidate is considered to have achieved a "perfect score" if they score 100 in every task they were requested to solve.

 

The output should include the experience level, the total number of candidates for each level, and the count of candidates who achieved a "perfect score." The result should be ordered by experience level.
Table: assessments 
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| candidate_id | int      |
| experience   | int      |
| sql_score    | int      |
| algo         | int      |
| bug_fixing   | int      |
+--------------+----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
  experience,
  COUNT(*) AS total_candidates,
  SUM(CASE 
    WHEN (sql_score IS NULL OR sql_score = 100)
      AND (algo IS NULL OR algo = 100)
      AND (bug_fixing IS NULL OR bug_fixing = 100)
      AND (sql_score IS NOT NULL OR algo IS NOT NULL OR bug_fixing IS NOT NULL)
    THEN 1 
    ELSE 0 
  END) AS perfect_score_count
FROM assessments
GROUP BY experience
ORDER BY experience;
```
