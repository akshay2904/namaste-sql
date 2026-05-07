-- ======================================================================
-- 13 - Best Employee Award
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Tcs
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/13-best-employee-award
-- ======================================================================

/*
TCS wants to award employees based on number of projects completed by each individual each month.  Write an SQL to find best employee for each month along with number of projects completed by him/her in that month, display the output in descending order of number of completed projects & employee name.
Table: projects
+-------------------------+-------------+
| COLUMN_NAME             | DATA_TYPE   |
+-------------------------+-------------+
| project_id              | int         |
| employee_name           | varchar(10) |
| project_completion_date | date        |
+-------------------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    DATE_TRUNC('month', project_completion_date)::date AS month,
    employee_name,
    COUNT(*) AS projects_completed
FROM projects
WHERE project_completion_date IS NOT NULL
GROUP BY DATE_TRUNC('month', project_completion_date), employee_name
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY DATE_TRUNC('month', project_completion_date) 
    ORDER BY COUNT(*) DESC, employee_name ASC
) = 1
ORDER BY projects_completed DESC, employee_name ASC;
```

**Alternative solution using subquery (compatible with more databases):**

```sql
SELECT 
    month,
    employee_name,
    projects_completed
FROM (
    SELECT 
        DATE_TRUNC('month', project_completion_date)::date AS month,
        employee_name,
        COUNT(*) AS projects_completed,
        ROW_NUMBER() OVER (
            PARTITION BY DATE_TRUNC('month', project_completion_date) 
            ORDER BY COUNT(*) DESC, employee_name ASC
        ) AS rnk
    FROM projects
    WHERE project_completion_date IS NOT NULL
    GROUP BY DATE_TRUNC('month', project_completion_date), employee_name
) ranked
WHERE rnk = 1
ORDER BY projects_completed DESC, employee_name ASC;
```

**MySQL compatible version:**

```sql
SELECT 
    month,
    employee_name,
    projects_completed
FROM (
    SELECT 
        DATE_FORMAT(project_completion_date, '%Y-%m-01') AS month,
        employee_name,
        COUNT(*) AS projects_completed,
        ROW_NUMBER() OVER (
            PARTITION BY DATE_FORMAT(project_completion_date, '%Y-%m-01') 
            ORDER BY COUNT(*) DESC, employee_name ASC
        ) AS rnk
    FROM projects
    WHERE project_completion_date IS NOT NULL
    GROUP BY DATE_FORMAT(project_completion_date, '%Y-%m-01'), employee_name
) ranked
WHERE rnk = 1
ORDER BY projects_completed DESC, employee_name ASC;
```
