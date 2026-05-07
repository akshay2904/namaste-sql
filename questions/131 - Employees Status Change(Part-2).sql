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

```sql
SELECT 
    COALESCE(e2020.emp_id, e2021.emp_id) as emp_id,
    CASE 
        WHEN e2020.emp_id IS NULL THEN 'New Hire'
        WHEN e2021.emp_id IS NULL THEN 'Resigned'
        WHEN e2020.designation != e2021.designation THEN 'Promoted'
    END as status_change,
    e2020.designation as designation_2020,
    e2021.designation as designation_2021
FROM (
    SELECT emp_id, designation 
    FROM employees 
    WHERE year = 2020
) e2020
FULL OUTER JOIN (
    SELECT emp_id, designation 
    FROM employees 
    WHERE year = 2021
) e2021
ON e2020.emp_id = e2021.emp_id
WHERE e2020.designation != e2021.designation 
   OR e2020.emp_id IS NULL 
   OR e2021.emp_id IS NULL
ORDER BY emp_id;
```
