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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Use recursive CTE to traverse the hierarchy from each manager downward
WITH RECURSIVE org_tree AS (
    -- Base case: direct reportees
    SELECT
        m_id AS root_manager,
        e_id AS reportee
    FROM hierarchy
    WHERE m_id IS NOT NULL

    UNION ALL

    -- Recursive case: indirect reportees
    SELECT
        ot.root_manager,
        h.e_id AS reportee
    FROM org_tree ot
    JOIN hierarchy h ON h.m_id = ot.reportee
)
SELECT
    root_manager AS m_id,
    COUNT(DISTINCT reportee) AS num_of_reportees
FROM org_tree
GROUP BY root_manager
ORDER BY num_of_reportees DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Use recursive CTE but flatten manually with basic aggregation
WITH RECURSIVE subordinates AS (
    -- Anchor: each employee is a direct report of their manager
    SELECT
        m_id AS manager_id,
        e_id AS subordinate_id,
        1 AS level_depth
    FROM hierarchy
    WHERE m_id IS NOT NULL

    UNION ALL

    -- Recursion: go deeper into reporting chain
    SELECT
        s.manager_id,
        h.e_id AS subordinate_id,
        s.level_depth + 1 AS level_depth
    FROM subordinates s
    JOIN hierarchy h
        ON h.m_id = s.subordinate_id
    -- Guard against cycles (in case data has circular references)
    WHERE s.level_depth < 100
)
SELECT
    manager_id AS m_id,
    COUNT(DISTINCT subordinate_id) AS num_of_reportees
FROM subordinates
GROUP BY manager_id
ORDER BY num_of_reportees DESC;
