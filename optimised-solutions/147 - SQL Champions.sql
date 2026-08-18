-- ======================================================================
-- 147 - SQL Champions
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Walmart
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/147-sql-champions
-- ======================================================================

/*
You are given a table named students with the following structure:

 
Table: students
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| student_id   | INT      |
| skill        | VARCHAR  |  
+--------------+----------+
Each row represents a skill that a student knows. A student can appear multiple times in the table if they have multiple skills.

Write a SQL query to return the student_ids of students who only know the skill 'SQL'.  Sort the result by student id.
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH skill_counts AS (
    SELECT
        student_id,
        COUNT(*) AS total_skills,
        -- Count how many of those skills are 'SQL'
        SUM(CASE WHEN skill = 'SQL' THEN 1 ELSE 0 END) AS sql_count
    FROM students
    GROUP BY student_id
)
SELECT student_id
FROM skill_counts
WHERE total_skills = 1
  AND sql_count = 1
ORDER BY student_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT student_id
FROM students
WHERE student_id IN (
    -- Students who know 'SQL'
    SELECT student_id
    FROM students
    WHERE skill = 'SQL'
)
AND student_id NOT IN (
    -- Students who know any skill other than 'SQL'
    SELECT student_id
    FROM students
    WHERE skill <> 'SQL'
)
ORDER BY student_id;
