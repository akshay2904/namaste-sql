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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_courses AS (
    SELECT
        student_id,
        course_id,
        major_flag,
        COUNT(*) OVER (PARTITION BY student_id) AS total_courses,
        ROW_NUMBER() OVER (
            PARTITION BY student_id
            -- major courses ('Y') come first; if tied or only electives, pick first by course_id
            ORDER BY CASE WHEN major_flag = 'Y' THEN 0 ELSE 1 END, course_id
        ) AS rn
    FROM student_courses
)
SELECT
    student_id,
    course_id,
    major_flag
FROM ranked_courses
WHERE
    rn = 1  -- picks the major course if exists, or the single course if only one enrolled
ORDER BY student_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    sc.student_id,
    sc.course_id,
    sc.major_flag
FROM student_courses sc
WHERE
    -- Case 1: Student has a major course (major_flag = 'Y')
    sc.major_flag = 'Y'

    OR

    -- Case 2: Student is enrolled in only one course (treat it as primary regardless of flag)
    sc.student_id IN (
        SELECT student_id
        FROM student_courses
        GROUP BY student_id
        HAVING COUNT(*) = 1
    )

    -- Exclude case where a student has both a major course and an elective;
    -- only keep the elective row if they have NO major course at all (single enrollment)
    AND sc.student_id NOT IN (
        SELECT student_id
        FROM student_courses
        WHERE major_flag = 'Y'
    )

ORDER BY sc.student_id;
