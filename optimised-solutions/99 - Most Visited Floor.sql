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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH visit_stats AS (
    SELECT
        emp_name,
        COUNT(*) AS total_visits,
        -- Rank floors by visit frequency per employee
        floor,
        RANK() OVER (PARTITION BY emp_name ORDER BY COUNT(*) DESC) AS floor_rank
    FROM entries
    GROUP BY emp_name, floor
),
most_visited AS (
    SELECT emp_name, floor AS most_visited_floor
    FROM visit_stats
    WHERE floor_rank = 1
),
resources_used AS (
    SELECT
        emp_name,
        STRING_AGG(DISTINCT resources, ', ' ORDER BY resources) AS resources_used
    FROM entries
    GROUP BY emp_name
),
total_visits AS (
    SELECT emp_name, SUM(total_visits) AS total_visits
    FROM visit_stats
    GROUP BY emp_name
)
SELECT
    t.emp_name,
    t.total_visits,
    m.most_visited_floor,
    r.resources_used
FROM total_visits t
JOIN most_visited m ON t.emp_name = m.emp_name
JOIN resources_used r ON t.emp_name = r.emp_name
ORDER BY t.emp_name ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    e.emp_name,
    COUNT(*) AS total_visits,
    -- Subquery to find the most visited floor for each employee
    (
        SELECT floor
        FROM entries e2
        WHERE e2.emp_name = e.emp_name
        GROUP BY floor
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS most_visited_floor,
    -- Aggregate distinct resources used by each employee
    STRING_AGG(DISTINCT e.resources, ', ' ORDER BY e.resources) AS resources_used
FROM entries e
GROUP BY e.emp_name
ORDER BY e.emp_name ASC;
