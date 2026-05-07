-- ======================================================================
-- 150 - Employees Current Salary
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Google
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/150-employees-current-salary
-- ======================================================================

/*
In your organization, each employee has a fixed joining salary recorded at the time they start. Over time, employees may receive one or more promotions, each offering a certain percentage increase to their current salary.

 

You're given two datasets:

employees :  contains each employee’s name and joining salary.

promotions:  lists all promotions that have occurred, including the promotion date and the percent increase granted during that promotion.

 

Your task is to write a SQL query to compute the current salary of every employee by applying each of their promotions increase round to 1 decimal places.
If an employee has no promotions, their current salary remains equal to the joining salary. Order the result by emp id.

 
Table: employees
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| id            | INT     |
| name          | VARCHAR |  
|joining_salary | INT     |  
+--------------+----------+Table: promotions
+----------------+----------+
| COLUMN_NAME    | DATA_TYPE|
+----------------+----------+
|emp_id          | INT      |
|promotion_date  | DATE     | 
|percent_increase| INT      |   
+--------------+------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    e.id,
    e.name,
    ROUND(
        e.joining_salary * EXP(SUM(LN(1 + p.percent_increase / 100.0))),
        1
    ) AS current_salary
FROM employees e
LEFT JOIN promotions p ON e.id = p.emp_id
GROUP BY e.id, e.name, e.joining_salary
ORDER BY e.id;
```
