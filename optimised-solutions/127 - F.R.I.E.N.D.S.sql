-- ======================================================================
-- 127 - F.R.I.E.N.D.S.
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Swiggy
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/127-f-r-i-e-n-d-s
-- ======================================================================

/*
You are given three tables: students, friends and packages. Friends table has student id and friend id(only best friend). A student can have more than one best friends. 
Write a query to output the names of those students whose ALL friends got offered a higher salary than them. Display those students name and difference between their salary and average of their friends salaries.

 
Table: students 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | int      |
| name        | varchar  |
+-------------+----------+Table: friends 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | int      |
| friend_id   | int      |
+-------------+----------+Table: packages 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | int      |
| salary      | int      |
+-------------+----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    s.name,
    ROUND(AVG(p_friend.salary) - p_student.salary, 2) AS salary_difference
FROM students s
INNER JOIN packages p_student ON s.id = p_student.id
INNER JOIN friends f ON s.id = f.id
INNER JOIN packages p_friend ON f.friend_id = p_friend.id
GROUP BY s.id, s.name, p_student.salary
HAVING MIN(p_friend.salary) > p_student.salary
ORDER BY salary_difference DESC;
```
