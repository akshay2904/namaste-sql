-- ======================================================================
-- 46 - Employees Inside Office (Part 1)
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Gameberry labs
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/46-employees-inside-office-part-1
-- ======================================================================

/*
A company record its employee's movement In and Out of office in a table. Please note below points about the data:

 
1- First entry for each employee is “in”
2- Every “in” is succeeded by an “out”
3- Employee can work across days
Write a SQL to find the number of employees inside the Office at “2019-04-01 19:05:00".

 
Table: employee_record
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| emp_id      | int        |
| action      | varchar(3) |
| created_at  | datetime   |
+-------------+------------+
*/


-- Write your SQL solution below:

```sql
SELECT COUNT(DISTINCT emp_id) AS employees_inside
FROM employee_record
WHERE created_at <= '2019-04-01 19:05:00'
GROUP BY emp_id
HAVING COUNT(*) % 2 = 1;
```

The logic works as follows:
- Filter all records up to and including the given timestamp
- Group by employee ID
- Use HAVING to count total actions per employee: if the count is odd, the last action was "in" (employee is inside); if even, the last action was "out" (employee is outside)
- COUNT(DISTINCT emp_id) gives the total number of employees currently inside
