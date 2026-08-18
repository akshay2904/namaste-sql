-- ======================================================================
-- 133 - Projects Source System
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : E&y
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/133-projects-source-system
-- ======================================================================

/*
A company manages project data from three source systems with varying reliability:

EagleEye: The most reliable and prioritized internal system.
SwiftLink: A trusted partner system with moderate reliability.
DataVault: A third-party system used as a fallback.

 

Data for a project can come from multiple systems. For each project, you need to select the most reliable data by prioritizing the source systems: EagleEye > SwiftLink > DataVault

 

Write an SQL to display id , project number and selected source system.

 
Table: projects
+----------------+----------+
| COLUMN_NAME    | DATA_TYPE|
+----------------+----------+
| id             | int      |
| project_number | int      | 
| Source_System  | varchar  |
+-------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_projects AS (
    SELECT
        id,
        project_number,
        Source_System,
        ROW_NUMBER() OVER (
            PARTITION BY project_number
            ORDER BY
                CASE Source_System
                    WHEN 'EagleEye'  THEN 1
                    WHEN 'SwiftLink' THEN 2
                    WHEN 'DataVault' THEN 3
                    ELSE 4
                END
        ) AS rn
    FROM projects
)
SELECT
    id,
    project_number,
    Source_System
FROM ranked_projects
WHERE rn = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    p.id,
    p.project_number,
    p.Source_System
FROM projects p
WHERE p.Source_System = (
    -- For each project, find the highest-priority source system available
    SELECT
        CASE
            WHEN SUM(CASE WHEN Source_System = 'EagleEye'  THEN 1 ELSE 0 END) > 0 THEN 'EagleEye'
            WHEN SUM(CASE WHEN Source_System = 'SwiftLink' THEN 1 ELSE 0 END) > 0 THEN 'SwiftLink'
            WHEN SUM(CASE WHEN Source_System = 'DataVault' THEN 1 ELSE 0 END) > 0 THEN 'DataVault'
        END
    FROM projects sub
    WHERE sub.project_number = p.project_number
)
-- Pick only one row per project_number in case of duplicates within same system
AND p.id = (
    SELECT MIN(id)
    FROM projects sub2
    WHERE sub2.project_number = p.project_number
      AND sub2.Source_System = p.Source_System
);
