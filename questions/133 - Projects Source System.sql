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

```sql
SELECT 
    id,
    project_number,
    Source_System
FROM projects
WHERE (id, Source_System) IN (
    SELECT 
        id,
        FIRST_VALUE(Source_System) OVER (PARTITION BY id ORDER BY CASE 
            WHEN Source_System = 'EagleEye' THEN 1
            WHEN Source_System = 'SwiftLink' THEN 2
            WHEN Source_System = 'DataVault' THEN 3
            ELSE 4
        END)
    FROM projects
)
GROUP BY id, project_number, Source_System;
```
