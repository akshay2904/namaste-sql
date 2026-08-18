-- ======================================================================
-- 130 - Employees Status Change(Part-1)
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Deloitte
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/130-employees-status-change-part-1
-- ======================================================================

/*
You work in the Human Resources (HR) department of a growing company that tracks the status of its employees year over year. The company needs to analyze employee status changes between two consecutive years: 2020 and 2021.

The company's HR system has two separate tables of employees for the years 2020 and 2021, which include each employee's unique identifier (emp_id) and their corresponding designation (role) within the organization.

The task is to track how the designations of employees have changed over the year. Specifically, you are required to identify the following changes:

Promoted: If an employee's designation has changed (e.g., from Trainee to Developer, or from Developer to Manager).
Resigned: If an employee was present in 2020 but has left the company by 2021.
New Hire: If an employee was hired in 2021 but was not present in 2020.

Assume that employees can only be promoted and cannot be demoted.

Table: emp_2020 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| emp_id      | int      |
| designation | date     |
+-------------+----------+
Table: emp_2021
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| emp_id      | int      |
| designation | date     |
+-------------+----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH status_changes AS (
    SELECT
        COALESCE(e20.emp_id, e21.emp_id) AS emp_id,
        e20.designation AS designation_2020,
        e21.designation AS designation_2021,
        CASE
            WHEN e20.emp_id IS NULL THEN 'New Hire'
            WHEN e21.emp_id IS NULL THEN 'Resigned'
            WHEN e20.designation <> e21.designation THEN 'Promoted'
            ELSE 'No Change'
        END AS emp_status
    FROM emp_2020 e20
    FULL OUTER JOIN emp_2021 e21
        ON e20.emp_id = e21.emp_id
)
SELECT
    emp_id,
    designation_2020,
    designation_2021,
    emp_status
FROM status_changes
WHERE emp_status <> 'No Change'
ORDER BY emp_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Promoted: in both years but designation changed
SELECT
    e20.emp_id,
    e20.designation AS designation_2020,
    e21.designation AS designation_2021,
    'Promoted' AS emp_status
FROM emp_2020 e20
INNER JOIN emp_2021 e21
    ON e20.emp_id = e21.emp_id
WHERE e20.designation <> e21.designation

UNION ALL

-- Resigned: present in 2020 but not in 2021
SELECT
    e20.emp_id,
    e20.designation AS designation_2020,
    NULL AS designation_2021,
    'Resigned' AS emp_status
FROM emp_2020 e20
WHERE e20.emp_id NOT IN (
    SELECT emp_id FROM emp_2021
)

UNION ALL

-- New Hire: present in 2021 but not in 2020
SELECT
    e21.emp_id,
    NULL AS designation_2020,
    e21.designation AS designation_2021,
    'New Hire' AS emp_status
FROM emp_2021 e21
WHERE e21.emp_id NOT IN (
    SELECT emp_id FROM emp_2020
)

ORDER BY emp_id;
