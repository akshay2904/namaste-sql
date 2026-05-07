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

```sql
SELECT student_id
FROM students
GROUP BY student_id
HAVING COUNT(*) = 1 AND MAX(skill) = 'SQL'
ORDER BY student_id;
```
