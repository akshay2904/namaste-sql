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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH parent_info AS (
    -- Join relations with people to get parent details in one scan
    SELECT 
        r.c_id,
        MAX(CASE WHEN p.gender = 'F' THEN p.name END) AS mother_name,
        MAX(CASE WHEN p.gender = 'M' THEN p.name END) AS father_name
    FROM relations r
    JOIN people p ON r.p_id = p.id
    GROUP BY r.c_id
)
SELECT 
    c.name        AS child_name,
    pi.mother_name,
    pi.father_name
FROM people c
JOIN parent_info pi ON c.id = pi.c_id
ORDER BY c.name ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    c.name AS child_name,
    -- Subquery to find the mother (gender = 'F') for each child
    (
        SELECT p.name
        FROM relations r
        JOIN people p ON r.p_id = p.id
        WHERE r.c_id = c.id
          AND p.gender = 'F'
        LIMIT 1
    ) AS mother_name,
    -- Subquery to find the father (gender = 'M') for each child
    (
        SELECT p.name
        FROM relations r
        JOIN people p ON r.p_id = p.id
        WHERE r.c_id = c.id
          AND p.gender = 'M'
        LIMIT 1
    ) AS father_name
FROM people c
-- Only include people who appear as children in the relations table
WHERE c.id IN (SELECT c_id FROM relations)
ORDER BY c.name ASC;
