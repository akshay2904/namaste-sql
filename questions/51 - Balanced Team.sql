-- ======================================================================
-- 51 - Balanced Team
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Kpmg
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/51-balanced-team
-- ======================================================================

/*
Suppose you are a manager of a data analytics company. You are tasked to build a new team consists of senior and junior data analysts. The total budget for the salaries is 70000.  You need to use the below criterion for hiring:

 
1- Keep hiring the seniors with the smallest salaries until you cannot hire anymore seniors.
2- Use the remaining budget to hire the juniors with the smallest salaries until you cannot hire anymore juniors.
Display employee id, experience and salary. Sort in decreasing order of salary.

 
Table: candidates
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| emp_id      | int         |
| experience  | varchar(6) |
| salary      | int         |
+-------------+-------------+
*/


-- Write your SQL solution below:

```sql
WITH seniors AS (
  SELECT emp_id, experience, salary
  FROM candidates
  WHERE experience = 'senior'
  ORDER BY salary ASC
),
seniors_cumsum AS (
  SELECT emp_id, experience, salary,
         SUM(salary) OVER (ORDER BY salary ASC, emp_id ASC) AS cumulative_salary
  FROM seniors
),
hired_seniors AS (
  SELECT emp_id, experience, salary
  FROM seniors_cumsum
  WHERE cumulative_salary <= 70000
),
remaining_budget AS (
  SELECT 70000 - COALESCE(SUM(salary), 0) AS budget_left
  FROM hired_seniors
),
juniors AS (
  SELECT emp_id, experience, salary
  FROM candidates
  WHERE experience = 'junior'
  ORDER BY salary ASC
),
juniors_cumsum AS (
  SELECT emp_id, experience, salary,
         SUM(salary) OVER (ORDER BY salary ASC, emp_id ASC) AS cumulative_salary
  FROM juniors
),
hired_juniors AS (
  SELECT j.emp_id, j.experience, j.salary
  FROM juniors_cumsum j
  CROSS JOIN remaining_budget rb
  WHERE j.cumulative_salary <= rb.budget_left
)
SELECT emp_id, experience, salary
FROM hired_seniors
UNION ALL
SELECT emp_id, experience, salary
FROM hired_juniors
ORDER BY salary DESC;
```
