-- ======================================================================
-- 82 - Child and Parents
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Deloitte
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/82-child-and-parents
-- ======================================================================

/*
You are tasked to determine the mother and father's name for each child based on the given data. The people table provides information about individuals, including their names and genders. The relations table specifies parent-child relationships, linking each child (c_id) to their parent (p_id). Each parent is identified by their ID, and their gender is used to distinguish between mothers (F) and fathers (M).

Write an SQL query to retrieve the names of each child along with the names of their respective mother and father, if available. If a child has only one parent listed in the relations table, the query should still include that parent's name and leave the other parent's name as NULL. Order the output by child name in ascending order.

 
Tables: people
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| gender      | char(2)     |
| id          | int         |
| name        | varchar(20) |
+-------------+-------------+Tables: relations 
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| c_id        | int       |
| p_id        | int       |
+-------------+-----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    c.name AS child_name,
    MAX(CASE WHEN p.gender = 'F' THEN p.name END) AS mother_name,
    MAX(CASE WHEN p.gender = 'M' THEN p.name END) AS father_name
FROM relations r
JOIN people c ON r.c_id = c.id
JOIN people p ON r.p_id = p.id
GROUP BY c.id, c.name
ORDER BY c.name ASC;
```
