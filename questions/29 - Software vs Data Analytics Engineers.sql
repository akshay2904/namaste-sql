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

```sql
SELECT
    SUM(CASE WHEN JobTitle LIKE 'Software%' THEN 1 ELSE 0 END) AS Software_Engineers,
    SUM(CASE WHEN JobTitle LIKE 'Data%' THEN 1 ELSE 0 END) AS Data_Professionals,
    SUM(CASE WHEN JobTitle LIKE '%Manager%' THEN 1 ELSE 0 END) AS Managers
FROM Employees;
```
