-- ======================================================================
-- 54 - Employees Payout
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Deloitte
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/54-employees-payout
-- ======================================================================

/*
An IT company pays its employees on hourly basis. You are given the database of employees along with their department id.

 
Table: employees
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| emp_id      | int         |
| emp_name    | varchar(20) |
| dept_id     | int         |
+-------------+-------------+
Department table which consist of hourly rate for each department.

 
Table: dept
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| dept_id     | int       |
| hourly_rate | int       |
+-------------+-----------+

Given the daily entry_time and exit_time of each employee, calculate the total amount payable to each employee.

 
Table: daily_time
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| emp_id      | int       |
| entry_time  | datetime  |
| exit_time   | datetime  |
+-------------+-----------+
Please note that company also pays overtime to employees who work for more than 8 hours a day which is 1.5 times of hourly rate. So for example if hourly rate is 10 and a employee works for 9 hours then total payable will be 10*8+15*1 = 95 for that day. In this example 95 is total payout and 15 is overtime payout.  Round the result to 2 decimal places and sort the output by decreasing order of total payout.
*/


-- Write your SQL solution below:

```sql
SELECT 
  e.emp_id,
  e.emp_name,
  ROUND(SUM(
    CASE 
      WHEN hours_worked <= 8 THEN hours_worked * d.hourly_rate
      ELSE 8 * d.hourly_rate + (hours_worked - 8) * d.hourly_rate * 1.5
    END
  ), 2) AS total_payout
FROM employees e
JOIN dept d ON e.dept_id = d.dept_id
JOIN daily_time dt ON e.emp_id = dt.emp_id
CROSS APPLY (
  SELECT EXTRACT(EPOCH FROM (dt.exit_time - dt.entry_time)) / 3600 AS hours_worked
) hours
GROUP BY e.emp_id, e.emp_name, d.dept_id, d.hourly_rate
ORDER BY total_payout DESC;
```

Alternative version compatible with MySQL:

```sql
SELECT 
  e.emp_id,
  e.emp_name,
  ROUND(SUM(
    CASE 
      WHEN hours_worked <= 8 THEN hours_worked * d.hourly_rate
      ELSE 8 * d.hourly_rate + (hours_worked - 8) * d.hourly_rate * 1.5
    END
  ), 2) AS total_payout
FROM employees e
JOIN dept d ON e.dept_id = d.dept_id
JOIN daily_time dt ON e.emp_id = dt.emp_id
JOIN (
  SELECT emp_id, entry_time, exit_time, 
         HOUR(TIMEDIFF(exit_time, entry_time)) + 
         MINUTE(TIMEDIFF(exit_time, entry_time)) / 60 + 
         SECOND(TIMEDIFF(exit_time, entry_time)) / 3600 AS hours_worked
  FROM daily_time
) time_calc ON dt.emp_id = time_calc.emp_id AND dt.entry_time = time_calc.entry_time
GROUP BY e.emp_id, e.emp_name
ORDER BY total_payout DESC;
```

Most compatible version:

```sql
SELECT 
  e.emp_id,
  e.emp_name,
  ROUND(SUM(
    CASE 
      WHEN hours_worked <= 8 THEN hours_worked * d.hourly_rate
      ELSE 8 * d.hourly_rate + (hours_worked - 8) * d.hourly_rate * 1.5
    END
  ), 2) AS total_payout
FROM employees e
JOIN dept d ON e.dept_id = d.dept_id
JOIN daily_time dt ON e.emp_id = dt.emp_id
JOIN (
  SELECT emp_id, entry_time, exit_time,
         CAST(JULIANDAY(exit_time) - JULIANDAY(entry_time) AS FLOAT) * 24 AS hours_worked
  FROM daily_time
) time_calc ON dt.emp_id = time_calc.emp_id AND dt.entry_time = time_calc.entry_time
GROUP BY e.emp_id, e.emp_name
ORDER BY total_payout DESC;
```
