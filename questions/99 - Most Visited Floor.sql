-- ======================================================================
-- 99 - Most Visited Floor
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Intuit
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/99-most-visited-floor
-- ======================================================================

/*
You are a facilities manager at a corporate office building, responsible for tracking employee visits, floor preferences, and resource usage within the premises. The office building has multiple floors, each equipped with various resources such as desks, computers, monitors, and other office supplies. You have a database table “entries” that stores information about employee visits to the office building. Each record in the table represents a visit by an employee and includes details such as their name, the floor they visited, and the resources they used during their visit.
Write an SQL query to retrieve the total visits, most visited floor, and resources used by each employee, display the output in ascending order of employee name.

 
Table : entries
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| emp_name    | varchar(10) |
| address     | varchar(10) |
| floor       | int         |
| resources   | varchar(10) |
+-------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
  emp_name,
  COUNT(*) AS total_visits,
  MAX(floor) AS most_visited_floor,
  STRING_AGG(DISTINCT resources, ', ') AS resources_used
FROM entries
GROUP BY emp_name
ORDER BY emp_name ASC;
```
