-- ======================================================================
-- 105 - Student Major Subject
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Linkedin
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/105-student-major-subject
-- ======================================================================

/*
You are provided with information about students enrolled in various courses at a university. Each student can be enrolled in multiple courses, and for each course, it is specified whether the course is a major or an elective for the student.
Write a SQL query to generate a report that lists the primary (major_flag='Y') course for each student. If a student is enrolled in only one course, that course should be considered their primary course by default irrespective of the flag. Sort the output by student_id.

 
Table: student_courses
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| student_id  | int        |
| course_id   | int        |
| major_flag  | varchar(1) |
+-------------+------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    student_id,
    course_id
FROM (
    SELECT 
        student_id,
        course_id,
        major_flag,
        COUNT(*) OVER (PARTITION BY student_id) as course_count,
        ROW_NUMBER() OVER (PARTITION BY student_id ORDER BY CASE WHEN major_flag = 'Y' THEN 0 ELSE 1 END, course_id) as rn
    FROM student_courses
) ranked
WHERE 
    -- If only one course, take that course regardless of major_flag
    course_count = 1
    OR 
    -- If multiple courses, take the one marked as major (Y)
    (course_count > 1 AND rn = 1 AND major_flag = 'Y')
ORDER BY student_id;
```
