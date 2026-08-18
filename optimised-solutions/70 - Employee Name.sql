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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH parsed AS (
    SELECT
        employeeid,
        fullname,
        -- Check if there's a comma (formats 1 & 2) or not (format 3)
        CASE
            WHEN fullname LIKE '%,%' THEN TRIM(SPLIT_PART(fullname, ',', 1))
            ELSE NULL
        END AS last_name,
        -- After the comma: everything before the space (if space exists) = first name
        -- If no comma: the whole name is first name
        CASE
            WHEN fullname LIKE '%,%' AND SPLIT_PART(fullname, ',', 2) LIKE '% %'
                THEN TRIM(SPLIT_PART(SPLIT_PART(fullname, ',', 2), ' ', 1))
            WHEN fullname LIKE '%,%'
                THEN TRIM(SPLIT_PART(fullname, ',', 2))
            ELSE TRIM(fullname)
        END AS first_name,
        -- Middle name only exists in format 1
        CASE
            WHEN fullname LIKE '%,%' AND SPLIT_PART(fullname, ',', 2) LIKE '% %'
                THEN TRIM(SPLIT_PART(SPLIT_PART(fullname, ',', 2), ' ', 2))
            ELSE NULL
        END AS middle_name
    FROM employee
)
SELECT
    employeeid,
    fullname,
    first_name,
    middle_name,
    last_name
FROM parsed;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    employeeid,
    fullname,
    -- First Name
    CASE
        -- Format 1 & 2: has comma
        WHEN fullname LIKE '%,%' THEN
            CASE
                -- Format 1: after comma there is a space → take part before space
                WHEN SUBSTRING(fullname FROM POSITION(',' IN fullname) + 1) LIKE '% %'
                    THEN TRIM(SUBSTRING(
                            SUBSTRING(fullname FROM POSITION(',' IN fullname) + 1)
                            FROM 1
                            FOR POSITION(' ' IN SUBSTRING(fullname FROM POSITION(',' IN fullname) + 1)) - 1
                         ))
                -- Format 2: after comma no space → whole remainder is first name
                ELSE TRIM(SUBSTRING(fullname FROM POSITION(',' IN fullname) + 1))
            END
        -- Format 3: no comma → whole name is first name
        ELSE TRIM(fullname)
    END AS first_name,

    -- Middle Name
    CASE
        -- Format 1: has comma AND a space after the comma
        WHEN fullname LIKE '%,%'
             AND SUBSTRING(fullname FROM POSITION(',' IN fullname) + 1) LIKE '% %'
            THEN TRIM(SUBSTRING(
                    SUBSTRING(fullname FROM POSITION(',' IN fullname) + 1)
                    FROM POSITION(' ' IN SUBSTRING(fullname FROM POSITION(',' IN fullname) + 1)) + 1
                 ))
        ELSE NULL
    END AS middle_name,

    -- Last Name
    CASE
        WHEN fullname LIKE '%,%'
            THEN TRIM(SUBSTRING(fullname FROM 1 FOR POSITION(',' IN fullname) - 1))
        ELSE NULL
    END AS last_name

FROM employee;
