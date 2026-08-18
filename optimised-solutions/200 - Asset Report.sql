-- ======================================================================
-- 200 - Asset Report
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Hackerrank
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/200-asset-report
-- ======================================================================

/*
An IT department aims to merge its inventory data, encompassing both hardware and software assets. Currently, these assets are recorded in separate tables. The task is to create a query that provides a comprehensive list of all assets, combining hardware and software, and includes information on their allocation to employees. It should also highlight assets that are not presently assigned to any employee.

 

The result should have the following columns:asset_id | asset_type | asset_name | employee_email.

asset_id- the unique identifier for the asset.
asset_type- the derived column that shows either: Hardware or Software indicating the type of the asset.
asset_name- the name of the asset.
employee_email- the email address of the employee to whom the asset is assigned, or Unassigned, if the asset is not currently assigned to any employee.

The result should be sorted in ascending, natural order by asset_id.

 

Note:
Assets should be listed even if they are not assigned to any employee.
Only active assets should be included in the report.

 
Table: employees
+-------------+-----------+-----------------------------------+
| COLUMN_NAME | DATA_TYPE | DESCRIPTION                       |
+-------------+-----------+-----------------------------------+
| id          | INT       | The identifier of the employee    |
| email       | VARCHAR   | The employee email address        |
+-------------+-----------+-----------------------------------+Table: hardware_assets
+-------------+-----------+-------------------------------------------+
| COLUMN_NAME | DATA_TYPE | DESCRIPTION                               |
+-------------+-----------+-------------------------------------------+
| id          | VARCHAR   | The identifier of the asset               |
| name        | VARCHAR   | The name of the asset                     |
| is_active   | BOOLEAN   | The activity status of the asset          |
| employee_id | INT       | The reference to the employee             |
+-------------+-----------+-------------------------------------------+Table: software_assets
+-------------+-----------+-------------------------------------------+
| COLUMN_NAME | DATA_TYPE | DESCRIPTION                               |
+-------------+-----------+-------------------------------------------+
| id          | VARCHAR   | The identifier of the asset               |
| name        | VARCHAR   | The name of the asset                     |
| is_active   | BOOLEAN   | The activity status of the asset          |
| employee_id | INT       | The reference to the employee             |
+-------------+-----------+-------------------------------------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (CTEs with UNION ALL, single pass joins)
-- ============================================================

WITH all_assets AS (
    SELECT id, name, 'Hardware' AS asset_type, employee_id
    FROM hardware_assets
    WHERE is_active = TRUE
    UNION ALL
    SELECT id, name, 'Software' AS asset_type, employee_id
    FROM software_assets
    WHERE is_active = TRUE
)
SELECT
    a.id          AS asset_id,
    a.asset_type,
    a.name        AS asset_name,
    COALESCE(e.email, 'Unassigned') AS employee_email
FROM all_assets a
LEFT JOIN employees e ON a.employee_id = e.id
ORDER BY a.id ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, no CTEs)
-- ============================================================

SELECT
    assets.id          AS asset_id,
    assets.asset_type,
    assets.name        AS asset_name,
    COALESCE(e.email, 'Unassigned') AS employee_email
FROM (
    SELECT id, name, 'Hardware' AS asset_type, employee_id
    FROM hardware_assets
    WHERE is_active = TRUE
    UNION ALL
    SELECT id, name, 'Software' AS asset_type, employee_id
    FROM software_assets
    WHERE is_active = TRUE
) AS assets
LEFT JOIN employees e ON assets.employee_id = e.id
ORDER BY assets.id ASC;
