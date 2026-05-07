-- ======================================================================
-- 14 - Workaholics Employees
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Meta
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/14-workaholics-employees
-- ======================================================================

/*
Write a query to find workaholics employees.  Workaholics employees are those who satisfy at least one of the given criterions:

 
1- Worked for more than 8 hours a day for at least 3 days in a week. 
2- worked for more than 10 hours a day for at least 2 days in a week. 
You are given the login and logout timings of all the employees for a given week. Write a SQL to find all the workaholic employees along with the criterion that they are satisfying (1,2 or both), display it in the order of increasing employee id

 
Table: employees
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| emp_id      | int       |
| login       | datetime  |
| logout      | datetime  |
+-------------+-----------+
*/


-- Write your SQL solution below:

```sql
WITH daily_hours AS (
  -- Calculate hours worked per day for each employee
  SELECT 
    emp_id,
    DATE(login) AS work_date,
    EXTRACT(EPOCH FROM (logout - login)) / 3600 AS hours_worked
  FROM employees
),
criteria_check AS (
  -- Check which criteria each employee meets
  SELECT 
    emp_id,
    -- Criterion 1: More than 8 hours for at least 3 days in a week
    CASE 
      WHEN COUNT(CASE WHEN hours_worked > 8 THEN 1 END) >= 3 THEN 1 
      ELSE 0 
    END AS criterion_1,
    -- Criterion 2: More than 10 hours for at least 2 days in a week
    CASE 
      WHEN COUNT(CASE WHEN hours_worked > 10 THEN 1 END) >= 2 THEN 1 
      ELSE 0 
    END AS criterion_2
  FROM daily_hours
  GROUP BY emp_id
)
SELECT 
  emp_id,
  CONCAT_WS(',', 
    CASE WHEN criterion_1 = 1 THEN '1' END,
    CASE WHEN criterion_2 = 1 THEN '2' END
  ) AS criteria_satisfied
FROM criteria_check
WHERE criterion_1 = 1 OR criterion_2 = 1
ORDER BY emp_id ASC;
```
