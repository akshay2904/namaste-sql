-- ======================================================================
-- 102 - Users With Valid Passwords
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Google
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/102-users-with-valid-passwords
-- ======================================================================

/*
Write a SQL query to identify the users with valid passwords according to the conditions below.

The password must be at least 8 characters long.

The password must contain at least one letter (lowercase or uppercase).

The password must contain at least one digit (0-9).

The password must contain at least one special character from the set @#$%^&*.

The password must not contain any spaces.

 
Table: user_passwords 
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| user_id     | int         |    
| user_name   | varchar(10) |
| password    | varchar(20) |
+-------------+-------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH password_validation AS (
    SELECT
        user_id,
        user_name,
        password,
        -- Check all conditions using regex in a single pass
        LENGTH(password) >= 8                            AS min_length_ok,
        password ~ '[A-Za-z]'                            AS has_letter,
        password ~ '[0-9]'                               AS has_digit,
        password ~ '[@#$%^&*.]'                         AS has_special,
        password !~ '\s'                                 AS no_spaces
    FROM user_passwords
)
SELECT
    user_id,
    user_name,
    password
FROM password_validation
WHERE
    min_length_ok
    AND has_letter
    AND has_digit
    AND has_special
    AND no_spaces
ORDER BY user_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    user_id,
    user_name,
    password
FROM user_passwords
WHERE
    -- Condition 1: Password must be at least 8 characters long
    LENGTH(password) >= 8

    -- Condition 2: Must contain at least one letter (lowercase or uppercase)
    AND (
        password LIKE '%a%' OR password LIKE '%b%' OR password LIKE '%c%' OR
        password LIKE '%d%' OR password LIKE '%e%' OR password LIKE '%f%' OR
        password LIKE '%g%' OR password LIKE '%h%' OR password LIKE '%i%' OR
        password LIKE '%j%' OR password LIKE '%k%' OR password LIKE '%l%' OR
        password LIKE '%m%' OR password LIKE '%n%' OR password LIKE '%o%' OR
        password LIKE '%p%' OR password LIKE '%q%' OR password LIKE '%r%' OR
        password LIKE '%s%' OR password LIKE '%t%' OR password LIKE '%u%' OR
        password LIKE '%v%' OR password LIKE '%w%' OR password LIKE '%x%' OR
        password LIKE '%y%' OR password LIKE '%z%' OR
        -- Uppercase
        password LIKE '%A%' OR password LIKE '%B%' OR password LIKE '%C%' OR
        password LIKE '%D%' OR password LIKE '%E%' OR password LIKE '%F%' OR
        password LIKE '%G%' OR password LIKE '%H%' OR password LIKE '%I%' OR
        password LIKE '%J%' OR password LIKE '%K%' OR password LIKE '%L%' OR
        password LIKE '%M%' OR password LIKE '%N%' OR password LIKE '%O%' OR
        password LIKE '%P%' OR password LIKE '%Q%' OR password LIKE '%R%' OR
        password LIKE '%S%' OR password LIKE '%T%' OR password LIKE '%U%' OR
        password LIKE '%V%' OR password LIKE '%W%' OR password LIKE '%X%' OR
        password LIKE '%Y%' OR password LIKE '%Z%'
    )

    -- Condition 3: Must contain at least one digit (0-9)
    AND (
        password LIKE '%0%' OR password LIKE '%1%' OR password LIKE '%2%' OR
        password LIKE '%3%' OR password LIKE '%4%' OR password LIKE '%5%' OR
        password LIKE '%6%' OR password LIKE '%7%' OR password LIKE '%8%' OR
        password LIKE '%9%'
    )

    -- Condition 4: Must contain at least one special character from @#$%^&*.
    AND (
        password LIKE '%@%' OR password LIKE '%#%' OR password LIKE '%$%' OR
        password LIKE '%^%' OR password LIKE '%&%' OR password LIKE '%*%' OR
        password LIKE '%!%' OR password LIKE '%-%'
    )

    -- Condition 5: Must NOT contain any spaces
    AND password NOT LIKE '% %'

ORDER BY user_id;
