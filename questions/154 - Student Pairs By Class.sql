-- ======================================================================
-- 154 - Student Pairs By Class
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Tiger analytics
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/154-student-pairs-by-class
-- ======================================================================

/*
A school maintains a record of students' SAT scores along with the class they belong to. The academic team wants to analyze which two students in each class have the closest SAT scores. This helps in grouping students with similar performance for peer learning programs.

Write a query to return, for each class, the pair of students with the smallest absolute difference in their SAT scores.
Return the class name, the two students' names, and their absolute score difference. Order by class.

 

Note: In each pair, the student with the lexicographically smaller name (alphabetically first) should appear as student1. This helps in consistent comparison and verification of results.

 
Table: scores
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| student_name | VARCHAR  | 
| class        | VARCHAR  |
| score        | INT      | 
+-------------------------+
*/


-- Write your SQL solution below:

```sql
WITH score_pairs AS (
  SELECT 
    s1.class,
    CASE 
      WHEN s1.student_name < s2.student_name THEN s1.student_name 
      ELSE s2.student_name 
    END AS student1,
    CASE 
      WHEN s1.student_name < s2.student_name THEN s2.student_name 
      ELSE s1.student_name 
    END AS student2,
    ABS(s1.score - s2.score) AS score_diff,
    ROW_NUMBER() OVER (PARTITION BY s1.class ORDER BY ABS(s1.score - s2.score) ASC, LEAST(s1.student_name, s2.student_name) ASC) AS rn
  FROM scores s1
  JOIN scores s2 
    ON s1.class = s2.class 
    AND s1.student_name < s2.student_name
)
SELECT 
  class,
  student1,
  student2,
  score_diff
FROM score_pairs
WHERE rn = 1
ORDER BY class;
```
