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

```sql
SELECT 
    COALESCE(e20.emp_id, e21.emp_id) AS emp_id,
    CASE 
        WHEN e20.emp_id IS NULL THEN 'New Hire'
        WHEN e21.emp_id IS NULL THEN 'Resigned'
        WHEN e20.designation != e21.designation THEN 'Promoted'
    END AS status
FROM emp_2020 e20
FULL OUTER JOIN emp_2021 e21 
    ON e20.emp_id = e21.emp_id
ORDER BY emp_id;
```
