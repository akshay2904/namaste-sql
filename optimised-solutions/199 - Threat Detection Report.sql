-- ======================================================================
-- 199 - Threat Detection Report
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Hackerrank
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/199-threat-detection-report
-- ======================================================================

/*
Two antivirus products, "QuantumSafe" and "WebGuardian", have separate tables to record suspicious files. A company wants to create a consolidated report of these detections, distinguishing threats based on product source and file type. The database contains information from June through August, 2023.

 

The result should have the following columns: extension | quantumsafe_total_detections | webguardian_total_detections.

extension - the file extension (e.g., *.txt, *.doc)
quantumsafe_total_detections - the total number of detections from the "QuantumSafe" database
webguardian_total_detections - the total number of detections from the "WebGuardian" database

The result should be sorted in ascending order by extension.

Note: Only detections in July, 2023 should be included in the report.

 
Table: file_types
+--------------+---------------+------------------------------------------+
| COLUMN_NAME  | DATA_TYPE     | DESCRIPTION                              |
+--------------+---------------+------------------------------------------+
| id           | INT           | File type ID                             |
| extension    | VARCHAR(10)   | File extension (e.g., *.txt, *.doc)      |
+--------------+---------------+------------------------------------------+Table: quantumsafe_detections
+--------------+-------------+-------------------------+
| COLUMN_NAME  | DATA_TYPE   | DESCRIPTION             |
+--------------+-------------+-------------------------+
| filetype_id  | INT         | File type ID reference  |
| dt           | TIMESTAMP   | Detection datetime      |
+--------------+-------------+-------------------------+Table: webguardian_detections
+--------------+-------------+-------------------------+
| COLUMN_NAME  | DATA_TYPE   | DESCRIPTION             |
+--------------+-------------+-------------------------+
| filetype_id  | INT         | File type ID reference  |
| dt           | TIMESTAMP   | Detection datetime      |
+--------------+-------------+-------------------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH july_qs AS (
    SELECT filetype_id, COUNT(*) AS total
    FROM quantumsafe_detections
    WHERE dt >= '2023-07-01' AND dt < '2023-08-01'
    GROUP BY filetype_id
),
july_wg AS (
    SELECT filetype_id, COUNT(*) AS total
    FROM webguardian_detections
    WHERE dt >= '2023-07-01' AND dt < '2023-08-01'
    GROUP BY filetype_id
)
SELECT
    ft.extension,
    COALESCE(qs.total, 0) AS quantumsafe_total_detections,
    COALESCE(wg.total, 0) AS webguardian_total_detections
FROM file_types ft
LEFT JOIN july_qs qs ON ft.id = qs.filetype_id
LEFT JOIN july_wg wg ON ft.id = wg.filetype_id
-- Only include file types that had at least one detection in July from either product
WHERE qs.filetype_id IS NOT NULL OR wg.filetype_id IS NOT NULL
ORDER BY ft.extension;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ft.extension,
    COALESCE(
        (SELECT COUNT(*)
         FROM quantumsafe_detections qd
         WHERE qd.filetype_id = ft.id
           AND qd.dt >= '2023-07-01'
           AND qd.dt < '2023-08-01'),
        0
    ) AS quantumsafe_total_detections,
    COALESCE(
        (SELECT COUNT(*)
         FROM webguardian_detections wd
         WHERE wd.filetype_id = ft.id
           AND wd.dt >= '2023-07-01'
           AND wd.dt < '2023-08-01'),
        0
    ) AS webguardian_total_detections
FROM file_types ft
WHERE
    -- Only include file types detected in July by at least one product
    EXISTS (
        SELECT 1 FROM quantumsafe_detections qd
        WHERE qd.filetype_id = ft.id
          AND qd.dt >= '2023-07-01' AND qd.dt < '2023-08-01'
    )
    OR EXISTS (
        SELECT 1 FROM webguardian_detections wd
        WHERE wd.filetype_id = ft.id
          AND wd.dt >= '2023-07-01' AND wd.dt < '2023-08-01'
    )
ORDER BY ft.extension;
