-- ======================================================================
-- 47 - Employees Inside Office (Part 2)
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Gameberry labs
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/47-employees-inside-office-part-2
-- ======================================================================

/*
A company record its employee's movement In and Out of office in a table. Please note below points about the data:

 
1- First entry for each employee is “in”
2- Every “in” is succeeded by an “out”
3- Employee can work across days
Write an SQL to measure the time spent by each employee inside the office between “2019-04-01 14:00:00” and “2019-04-02 10:00:00" in minutes, display the output in ascending order of employee id .

 
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
WITH filtered_records AS (
  SELECT 
    emp_id,
    action,
    created_at
  FROM employee_record
  WHERE created_at BETWEEN '2019-04-01 14:00:00' AND '2019-04-02 10:00:00'
),
paired_records AS (
  SELECT 
    emp_id,
    created_at AS check_in,
    LEAD(created_at) OVER (PARTITION BY emp_id ORDER BY created_at) AS check_out
  FROM filtered_records
  WHERE action = 'in'
)
SELECT 
  emp_id,
  ROUND(SUM(EXTRACT(EPOCH FROM (check_out - check_in)) / 60)) AS minutes_in_office
FROM paired_records
WHERE check_out IS NOT NULL
GROUP BY emp_id
ORDER BY emp_id ASC;
```
