-- ======================================================================
-- 125 - Project Budget
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Tiger analytics
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/125-project-budget
-- ======================================================================

/*
You are tasked with managing project budgets at a company. Each project has a fixed budget, and multiple employees work on these projects. The company's payroll is based on annual salaries, and each employee works for a specific duration on a project.

 

Over budget on a project is defined when the salaries (allocated on per day basis as per project duration) exceed the budget of the project. For example, if Ankit and Rohit both combined income make 200K and work on a project of a budget of 50K that takes half a year, then the project is over budget given 0.5 * 200K = 100K > 50K.

 

Write a query to forecast the budget for all projects and return a label of "overbudget" if it is over budget and "within budget" otherwise. Order the result by project title.

 Note: Assume that employees only work on one project at a time.

 
Table: employees 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | int      |
| name        | varchar  |
| salary      | int      |
+-------------+----------+Table: projects 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | int      |
| title       | varchar  |
| start_date  | date     |
| end_date    | date     |
| budget      | int      |
+-------------+----------+Table: project_employees 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| project_id  | int      |
| employee_id | int      |
+-------------+----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    p.id,
    p.title,
    p.budget,
    SUM(e.salary) AS total_salaries,
    ROUND(CAST((EXTRACT(DAY FROM p.end_date - p.start_date) + 1) AS FLOAT) / 365, 4) AS project_duration_years,
    ROUND(SUM(e.salary) * CAST((EXTRACT(DAY FROM p.end_date - p.start_date) + 1) AS FLOAT) / 365, 2) AS allocated_cost,
    CASE 
        WHEN SUM(e.salary) * CAST((EXTRACT(DAY FROM p.end_date - p.start_date) + 1) AS FLOAT) / 365 > p.budget 
        THEN 'overbudget'
        ELSE 'within budget'
    END AS budget_status
FROM 
    projects p
    LEFT JOIN project_employees pe ON p.id = pe.project_id
    LEFT JOIN employees e ON pe.employee_id = e.id
GROUP BY 
    p.id,
    p.title,
    p.budget,
    p.start_date,
    p.end_date
ORDER BY 
    p.title;
```
