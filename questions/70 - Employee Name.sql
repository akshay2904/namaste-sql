-- ======================================================================
-- 70 - Employee Name
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Google
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/70-employee-name
-- ======================================================================

/*
The HR department needs to extract the first name, middle name and last name of each employee from the full name column. However, the full name column contains names in the format "Lastname,Firstname Middlename". 
Please consider that an employee name can be in one of the 3 following formats.
1- "Lastname,Firstname Middlename"
2- "Lastname,Firstname"
3- "Firstname"

 
Table : employee 
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| employeeid  | int         |
| fullname    | varchar(20) |
+-------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
  employeeid,
  CASE 
    WHEN fullname LIKE '%,%' THEN
      TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(fullname, ',', -1), ' ', 1))
    ELSE
      TRIM(SUBSTRING_INDEX(fullname, ' ', 1))
  END AS firstname,
  CASE 
    WHEN fullname LIKE '%,%' AND fullname LIKE '% %' THEN
      CASE 
        WHEN (LENGTH(SUBSTRING_INDEX(fullname, ',', -1)) - LENGTH(REPLACE(SUBSTRING_INDEX(fullname, ',', -1), ' ', ''))) > 1
        THEN TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(fullname, ',', -1), ' ', -1))
        ELSE NULL
      END
    ELSE NULL
  END AS middlename,
  CASE 
    WHEN fullname LIKE '%,%' THEN
      TRIM(SUBSTRING_INDEX(fullname, ',', 1))
    ELSE
      NULL
  END AS lastname
FROM employee;
```
