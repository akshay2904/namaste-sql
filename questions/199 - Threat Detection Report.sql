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

```sql
SELECT 
  ft.extension,
  COALESCE(qs.quantumsafe_total_detections, 0) AS quantumsafe_total_detections,
  COALESCE(wg.webguardian_total_detections, 0) AS webguardian_total_detections
FROM file_types ft
LEFT JOIN (
  SELECT 
    filetype_id,
    COUNT(*) AS quantumsafe_total_detections
  FROM quantumsafe_detections
  WHERE EXTRACT(YEAR FROM dt) = 2023 
    AND EXTRACT(MONTH FROM dt) = 7
  GROUP BY filetype_id
) qs ON ft.id = qs.filetype_id
LEFT JOIN (
  SELECT 
    filetype_id,
    COUNT(*) AS webguardian_total_detections
  FROM webguardian_detections
  WHERE EXTRACT(YEAR FROM dt) = 2023 
    AND EXTRACT(MONTH FROM dt) = 7
  GROUP BY filetype_id
) wg ON ft.id = wg.filetype_id
ORDER BY ft.extension ASC;
```
