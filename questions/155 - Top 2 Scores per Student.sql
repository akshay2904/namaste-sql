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

```sql
WITH ranked_marks AS (
  -- Get distinct marks for each student, ranked by mark value
  SELECT 
    student_name,
    subject_name,
    marks,
    DENSE_RANK() OVER (PARTITION BY student_name ORDER BY marks DESC) as mark_rank
  FROM students
),
top_subjects AS (
  -- Filter to keep only top 2 distinct mark levels for each student
  SELECT 
    student_name,
    subject_name,
    marks
  FROM ranked_marks
  WHERE mark_rank <= 2
)
SELECT 
  student_name,
  SUM(marks) as total_marks
FROM top_subjects
GROUP BY student_name
ORDER BY student_name;
```
