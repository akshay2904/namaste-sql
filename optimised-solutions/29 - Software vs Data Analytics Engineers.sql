-- ======================================================================
-- 29 - Software vs Data Analytics Engineers
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Infosys
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/29-software-vs-data-analytics-engineers
-- ======================================================================

/*
You are given the details of employees of a new startup. Write an SQL query to retrieve number of Software Engineers , Data Professionals and Managers in the team to separate columns. Below are the rules to identify them using Job Title. 

 

1- Software Engineers  :  The title should starts with “Software”

2- Data Professionals :  The title should starts with “Data”

3- Managers : The title should contain "Manager"

 
Tables: Employees
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| EmployeeID  | int         |
| Name        | varchar(20) |
| JoinDate    | date        |
| JobTitle    | varchar(20) |
+-------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    COUNT(CASE WHEN JobTitle LIKE 'Software%' THEN 1 END) AS SoftwareEngineers,
    COUNT(CASE WHEN JobTitle LIKE 'Data%'     THEN 1 END) AS DataProfessionals,
    COUNT(CASE WHEN JobTitle LIKE '%Manager%' THEN 1 END) AS Managers
FROM Employees;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM Employees WHERE JobTitle LIKE 'Software%') AS SoftwareEngineers,
    (SELECT COUNT(*) FROM Employees WHERE JobTitle LIKE 'Data%')     AS DataProfessionals,
    (SELECT COUNT(*) FROM Employees WHERE JobTitle LIKE '%Manager%') AS Managers;
