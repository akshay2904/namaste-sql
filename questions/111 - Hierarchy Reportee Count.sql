-- ======================================================================
-- 111 - Hierarchy Reportee Count
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/111-hierarchy-reportee-count
-- ======================================================================

/*
Write a SQL query to find the number of reportees (both direct and indirect) under each manager. The output should include:

m_id: The manager ID.

num_of_reportees: The total number of unique reportees (both direct and indirect) under that manager.

Order the result by number of reportees in descending order.

 
Table: hierarchy
+-------------+------------+
|COLUMN_NAME  | DATA_TYPE  |
+-------------+------------+
| e_id        | int        |
| m_id        | int        |
+-------------+------------+
*/


-- Write your SQL solution below:

```sql
WITH RECURSIVE manager_hierarchy AS (
  -- Base case: direct reportees
  SELECT m_id, e_id, 1 AS level
  FROM hierarchy
  WHERE m_id IS NOT NULL
  
  UNION ALL
  
  -- Recursive case: indirect reportees
  SELECT mh.m_id, h.e_id, mh.level + 1
  FROM manager_hierarchy mh
  INNER JOIN hierarchy h ON mh.e_id = h.m_id
  WHERE h.m_id IS NOT NULL
)
SELECT 
  m_id,
  COUNT(DISTINCT e_id) AS num_of_reportees
FROM manager_hierarchy
GROUP BY m_id
ORDER BY num_of_reportees DESC;
```
