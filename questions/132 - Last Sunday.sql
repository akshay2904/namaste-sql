-- ======================================================================
-- 132 - Last Sunday
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/132-last-sunday
-- ======================================================================

/*
Write an SQL to get the date of the last Sunday as per today's date. If you are solving the problem on Sunday then it should still return the date of last Sunday (not current date).

 

Note : Dates are displayed as per UTC time zone.
*/


-- Write your SQL solution below:

```sql
SELECT CURRENT_DATE - INTERVAL '1 day' * ((EXTRACT(DOW FROM CURRENT_DATE) + 6) % 7) AS last_sunday_date;
```

Alternatively, for better compatibility across different SQL databases:

```sql
SELECT 
  CASE 
    WHEN EXTRACT(DOW FROM CURRENT_DATE) = 0 THEN CURRENT_DATE - INTERVAL '7 day'
    ELSE CURRENT_DATE - INTERVAL '1 day' * EXTRACT(DOW FROM CURRENT_DATE)
  END AS last_sunday_date;
```

Or using DAYOFWEEK (for MySQL compatibility):

```sql
SELECT 
  CASE 
    WHEN DAYOFWEEK(CURDATE()) = 1 THEN CURDATE() - INTERVAL 7 DAY
    ELSE CURDATE() - INTERVAL (DAYOFWEEK(CURDATE()) - 1) DAY
  END AS last_sunday_date;
```
