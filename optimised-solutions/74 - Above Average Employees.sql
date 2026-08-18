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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH salary_details AS (
    SELECT
        e.emp_id,
        e.emp_name,
        e.job_title,
        s.base_pay,
        s.other_pay,
        s.overtime_pay,
        (s.base_pay + s.overtime_pay + s.other_pay) AS total_salary
    FROM employee e
    JOIN salary s ON e.emp_id = s.emp_id
),
ranked_salaries AS (
    SELECT
        *,
        -- Average salary per job title
        AVG(total_salary) OVER (PARTITION BY job_title) AS avg_salary_by_title,
        -- Rank within job title: tie-break by higher base_pay
        DENSE_RANK() OVER (
            PARTITION BY job_title
            ORDER BY total_salary DESC, base_pay DESC
        ) AS salary_rank
    FROM salary_details
)
SELECT
    emp_id,
    emp_name,
    job_title,
    total_salary,
    base_pay,
    ROUND(avg_salary_by_title, 2) AS avg_salary_by_title
FROM ranked_salaries
WHERE
    total_salary > avg_salary_by_title  -- above average for their job title
    AND salary_rank > 3                  -- not in top 3 earners
ORDER BY total_salary DESC, base_pay DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    e.emp_id,
    e.emp_name,
    e.job_title,
    (s.base_pay + s.overtime_pay + s.other_pay) AS total_salary,
    s.base_pay,
    ROUND(avg_by_title.avg_salary, 2) AS avg_salary_by_title
FROM employee e
JOIN salary s ON e.emp_id = s.emp_id
-- Subquery: average total salary per job title
JOIN (
    SELECT
        e2.job_title,
        AVG(s2.base_pay + s2.overtime_pay + s2.other_pay) AS avg_salary
    FROM employee e2
    JOIN salary s2 ON e2.emp_id = s2.emp_id
    GROUP BY e2.job_title
) avg_by_title ON e.job_title = avg_by_title.job_title
WHERE
    -- Above average for their job title
    (s.base_pay + s.overtime_pay + s.other_pay) > avg_by_title.avg_salary
    -- Not in top 3 earners within their job title
    AND e.emp_id NOT IN (
        SELECT sub_e.emp_id
        FROM employee sub_e
        JOIN salary sub_s ON sub_e.emp_id = sub_s.emp_id
        WHERE sub_e.job_title = e.job_title
        ORDER BY
            (sub_s.base_pay + sub_s.overtime_pay + sub_s.other_pay) DESC,
            sub_s.base_pay DESC
        LIMIT 3
    )
ORDER BY total_salary DESC, s.base_pay DESC;
