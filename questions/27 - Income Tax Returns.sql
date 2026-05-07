-- ======================================================================
-- 27 - Income Tax Returns
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Tcs
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/27-income-tax-returns
-- ======================================================================

/*
Given two tables: income_tax_dates and users, write a query to identify users who either filed their income tax returns late or completely skipped filing for certain financial years.

A return is considered late if the return_file_date is after the file_due_date.
A return is considered missed if there is no entry for the user in the users table for a given financial year (i.e., the user did not file at all).
Your task is to generate a list of users along with the financial year for which they either filed late or missed filing, and also include a comment column specifying whether it is a 'late return' or 'missed'. The result should be sorted by financial year in ascending order.

 
Table: income_tax_dates
+-----------------+------------+
| COLUMN_NAME     | DATA_TYPE  |
+-----------------+------------+
| financial_year  | varchar(4) |
| file_start_date | date       |
| file_due_date   | date       |
+-----------------+------------+Table: users
+------------------+------------+
| COLUMN_NAME      | DATA_TYPE  |
+------------------+------------+
| user_id          | int        |
| financial_year   | varchar(4) |
| return_file_date | date       |
+------------------+------------+
*/


-- Write your SQL solution below:

```sql
-- Identify users with late or missed income tax returns
SELECT 
    u.user_id,
    u.financial_year,
    'late return' AS comment
FROM users u
INNER JOIN income_tax_dates itd 
    ON u.financial_year = itd.financial_year
WHERE u.return_file_date > itd.file_due_date

UNION

SELECT 
    u.user_id,
    itd.financial_year,
    'missed' AS comment
FROM income_tax_dates itd
LEFT JOIN users u 
    ON itd.financial_year = u.financial_year
WHERE u.user_id IS NULL

ORDER BY financial_year ASC;
```
