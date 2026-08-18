-- ======================================================================
-- 155 - Top 2 Scores per Student
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Kpmg
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/155-top-2-scores-per-student
-- ======================================================================

/*
You are given a table Students that stores each student's subject-wise marks. Your task is to calculate the total marks of the top-performing subjects for each student (sname), considering ties in marks.

 

A subject is considered a top-performing subject if its marks are among the top two distinct marks for that student. If multiple subjects share the same marks, they should all be included if their marks fall within the top two distinct values.

 

Return each student's name and the total marks of these top-performing subjects. order by student name.

 
Table: students
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| student_name | VARCHAR  | 
| subject_name | VARCHAR  |
| marks        | INT      | 
+-------------------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        student_name,
        subject_name,
        marks,
        -- Rank distinct mark values per student
        DENSE_RANK() OVER (PARTITION BY student_name ORDER BY marks DESC) AS rnk
    FROM students
)
SELECT
    student_name,
    SUM(marks) AS total_marks
FROM ranked
WHERE rnk <= 2  -- top two distinct mark values
GROUP BY student_name
ORDER BY student_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    s.student_name,
    SUM(s.marks) AS total_marks
FROM students s
WHERE s.marks IN (
    -- For each student, find the top 2 distinct marks
    SELECT DISTINCT marks
    FROM students s2
    WHERE s2.student_name = s.student_name
    ORDER BY marks DESC
    LIMIT 2
)
GROUP BY s.student_name
ORDER BY s.student_name;
