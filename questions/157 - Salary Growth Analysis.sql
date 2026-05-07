-- ======================================================================
-- 157 - Salary Growth Analysis
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/157-salary-growth-analysis
-- ======================================================================

/*
The HR analytics team wants to evaluate employee performance based on their salary progression and promotion history. Write a query to return a summary for each employee with the following:

 

 1. `employee_id`
 2. `latest_salary`: most recent salary value
 3. `total_promotions`: number of times the employee got a promotion 
 4. `max_perc_change`: the maximum percentage increase between any two salary changes (round to 2 decimal places)
 5. `never_decreased`: 'Y' if salary never decreased, else 'N'
 6. `RankByGrowth`: rank of the employee based on salary growth (latest_salary / first_salary), tie-breaker = earliest join date

 
Table: employees
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| employee_id   | INT      | 
| name          | VARCHAR  | 
| join_date     | DATE     | 
| department    | VARCHAR  |  
| intial_salary | INT      | 
+--------------------------+Table: salary_history
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| employee_id  | INT      | 
| change_date  | DATE     |
| salary       | INT      | 
| promotion    | VARCHAR  | 
+-------------------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    e.employee_id,
    sh_latest.salary AS latest_salary,
    COALESCE(SUM(CASE WHEN sh.promotion = 'Y' THEN 1 ELSE 0 END), 0) AS total_promotions,
    ROUND(COALESCE(MAX(
        CASE 
            WHEN sh_prev.salary IS NOT NULL AND sh_prev.salary > 0
            THEN ((sh.salary - sh_prev.salary) * 100.0 / sh_prev.salary)
            ELSE 0
        END
    ), 0), 2) AS max_perc_change,
    CASE 
        WHEN MIN(sh.salary) >= e.intial_salary THEN 'Y'
        ELSE 'N'
    END AS never_decreased,
    RANK() OVER (
        ORDER BY (sh_latest.salary * 100.0 / e.intial_salary) DESC, 
                 e.join_date ASC
    ) AS RankByGrowth
FROM 
    employees e
    LEFT JOIN salary_history sh ON e.employee_id = sh.employee_id
    LEFT JOIN salary_history sh_prev ON e.employee_id = sh_prev.employee_id 
        AND sh_prev.change_date = (
            SELECT MAX(change_date) 
            FROM salary_history 
            WHERE employee_id = sh.employee_id 
            AND change_date < sh.change_date
        )
    LEFT JOIN (
        SELECT employee_id, salary
        FROM salary_history
        WHERE (employee_id, change_date) IN (
            SELECT employee_id, MAX(change_date)
            FROM salary_history
            GROUP BY employee_id
        )
    ) sh_latest ON e.employee_id = sh_latest.employee_id
GROUP BY 
    e.employee_id,
    e.intial_salary,
    e.join_date,
    sh_latest.salary
ORDER BY 
    RankByGrowth;
```
