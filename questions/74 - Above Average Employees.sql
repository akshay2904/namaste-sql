-- ======================================================================
-- 74 - Above Average Employees
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/74-above-average-employees
-- ======================================================================

/*
You are working as a data analyst at a tech company called "TechGuru Inc." that specializes in software development and data science solutions. The HR department has tasked you with analyzing the salaries of employees. Your goal is to identify employees who earn above the average salary for their respective job title but are not among the top 3 earners within their job title. Consider the sum of base_pay, overtime_pay and other_pay as total salary. 

In case multiple employees have same total salary then ranked them based on higher base pay. Sort the output by total salary in descending order.

 
Table: employee 
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| emp_id      | int         |
| emp_name    | varchar(20) |
| job_title   | varchar(20) |
+-------------+-------------+Table: salary 
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| emp_id       | int       |
| base_pay     | int       |
| other_pay    | int       |
| overtime_pay | int       |
+--------------+-----------+
*/


-- Write your SQL solution below:

```sql
WITH salary_totals AS (
  SELECT 
    e.emp_id,
    e.emp_name,
    e.job_title,
    s.base_pay,
    s.overtime_pay,
    s.other_pay,
    (s.base_pay + s.overtime_pay + s.other_pay) AS total_salary
  FROM employee e
  JOIN salary s ON e.emp_id = s.emp_id
),
job_title_avg AS (
  SELECT 
    job_title,
    AVG(total_salary) AS avg_salary
  FROM salary_totals
  GROUP BY job_title
),
ranked_by_title AS (
  SELECT 
    st.emp_id,
    st.emp_name,
    st.job_title,
    st.base_pay,
    st.total_salary,
    ROW_NUMBER() OVER (PARTITION BY st.job_title ORDER BY st.total_salary DESC, st.base_pay DESC) AS rank_in_title
  FROM salary_totals st
)
SELECT 
  r.emp_id,
  r.emp_name,
  r.job_title,
  r.base_pay,
  r.total_salary
FROM ranked_by_title r
JOIN job_title_avg ja ON r.job_title = ja.job_title
WHERE r.total_salary > ja.avg_salary
  AND r.rank_in_title > 3
ORDER BY r.total_salary DESC;
```
