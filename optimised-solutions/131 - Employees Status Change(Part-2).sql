-- ======================================================================
-- 131 - Employees Status Change(Part-2)
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Deloitte
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/131-employees-status-change-part-2
-- ======================================================================

/*
You work in the Human Resources (HR) department of a growing company that tracks the status of its employees year over year. The company needs to analyze employee status changes between two consecutive years: 2020 and 2021.

The company's HR system has two separate records of employees for the years 2020 and 2021 in the same table, which include each employee's unique identifier (emp_id) and their corresponding designation (role) within the organization for each year.

The task is to track how the designations of employees have changed over the year. Specifically, you are required to identify the following changes:

Promoted: If an employee's designation has changed (e.g., from Trainee to Developer, or from Developer to Manager).
Resigned: If an employee was present in 2020 but has left the company by 2021.
New Hire: If an employee was hired in 2021 but was not present in 2020.

Assume that employees can only be promoted and cannot be demoted.

 
Table: employees
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| emp_id      | int      |
| year        | int      | 
| designation | date     |
+-------------+----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH pivoted AS (
    SELECT
        emp_id,
        MAX(CASE WHEN year = 2020 THEN designation END) AS desig_2020,
        MAX(CASE WHEN year = 2021 THEN designation END) AS desig_2021
    FROM employees
    WHERE year IN (2020, 2021)
    GROUP BY emp_id
)
SELECT
    emp_id,
    desig_2020 AS old_designation,
    desig_2021 AS new_designation,
    CASE
        WHEN desig_2020 IS NOT NULL AND desig_2021 IS NULL     THEN 'Resigned'
        WHEN desig_2020 IS NULL     AND desig_2021 IS NOT NULL THEN 'New Hire'
        WHEN desig_2020 IS NOT NULL AND desig_2021 IS NOT NULL
             AND desig_2020 <> desig_2021                      THEN 'Promoted'
        ELSE 'No Change'
    END AS status
FROM pivoted
ORDER BY emp_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    COALESCE(e20.emp_id, e21.emp_id)   AS emp_id,
    e20.designation                     AS old_designation,
    e21.designation                     AS new_designation,
    CASE
        WHEN e20.emp_id IS NOT NULL AND e21.emp_id IS NULL     THEN 'Resigned'
        WHEN e20.emp_id IS NULL     AND e21.emp_id IS NOT NULL THEN 'New Hire'
        WHEN e20.emp_id IS NOT NULL AND e21.emp_id IS NOT NULL
             AND e20.designation <> e21.designation            THEN 'Promoted'
        ELSE 'No Change'
    END AS status
FROM
    -- all 2020 employees
    (SELECT emp_id, designation FROM employees WHERE year = 2020) AS e20
FULL OUTER JOIN
    -- all 2021 employees
    (SELECT emp_id, designation FROM employees WHERE year = 2021) AS e21
ON e20.emp_id = e21.emp_id
ORDER BY COALESCE(e20.emp_id, e21.emp_id);
