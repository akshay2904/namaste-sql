-- ======================================================================
-- 149 - Employees Not Promoted
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Tiger analytics
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/149-employees-not-promoted
-- ======================================================================

/*
The promotions table records all historical promotions of employees (an employee can appear multiple times).
Write a query to find all employees who were not promoted in the last 1 year from today. Display id , name and latest promotion date for those employees order by id.

 
Table: employees
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | INT      |
| name        | VARCHAR  |  
+-------------+----------+Table: promotions
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
|emp_id        | INT      |
|promotion_date| DATE     |  
+--------------+----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    e.id,
    e.name,
    MAX(p.promotion_date) AS latest_promotion_date
FROM employees e
LEFT JOIN promotions p ON e.id = p.emp_id
GROUP BY e.id, e.name
HAVING MAX(p.promotion_date) < CURRENT_DATE - INTERVAL '1 year'
   OR MAX(p.promotion_date) IS NULL
ORDER BY e.id;
```
