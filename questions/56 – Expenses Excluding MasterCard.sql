-- ======================================================================
-- 56 – Expenses Excluding MasterCard
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Paypal
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/56-expenses-excluding-mastercard
-- ======================================================================

/*
You're working for a financial analytics company that specializes in analyzing credit card expenditures. You have a dataset containing information about users' credit card expenditures across different card companies.
Write an SQL query to find the total expenditure from other cards (excluding Mastercard) for users who hold Mastercard.  Display only the users(along with Mastercard expense and other expense) for which expense from other cards together is more than Mastercard expense.

 
Table: expenditures
+--------------+-------------+
| COLUMN_NAME  | DATA_TYPE   |
+--------------+-------------+
| user_name    | varchar(10) |
| expenditure  | int         |
| card_company | varchar(15) |
+--------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    e1.user_name,
    SUM(CASE WHEN e1.card_company = 'Mastercard' THEN e1.expenditure ELSE 0 END) AS mastercard_expense,
    SUM(CASE WHEN e1.card_company != 'Mastercard' THEN e1.expenditure ELSE 0 END) AS other_expense
FROM 
    expenditures e1
WHERE 
    e1.user_name IN (
        SELECT DISTINCT user_name 
        FROM expenditures 
        WHERE card_company = 'Mastercard'
    )
GROUP BY 
    e1.user_name
HAVING 
    SUM(CASE WHEN e1.card_company != 'Mastercard' THEN e1.expenditure ELSE 0 END) > 
    SUM(CASE WHEN e1.card_company = 'Mastercard' THEN e1.expenditure ELSE 0 END)
ORDER BY 
    e1.user_name;
```
