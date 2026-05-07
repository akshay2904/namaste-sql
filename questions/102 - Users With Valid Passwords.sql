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

```sql
SELECT 
    user_id,
    user_name,
    password
FROM user_passwords
WHERE 
    -- At least 8 characters long
    LENGTH(password) >= 8
    -- Contains at least one letter (lowercase or uppercase)
    AND password REGEXP '[a-zA-Z]'
    -- Contains at least one digit
    AND password REGEXP '[0-9]'
    -- Contains at least one special character from @#$%^&*
    AND password REGEXP '[@#$%^&*]'
    -- Does not contain any spaces
    AND password NOT REGEXP ' '
ORDER BY user_id;
```
