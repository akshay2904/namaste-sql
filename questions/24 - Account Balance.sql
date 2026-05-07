-- ======================================================================
-- 24 - Account Balance
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Paypal
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/24-account-balance
-- ======================================================================

/*
You are given a list of users and their opening account balance along with the transactions done by them. Write a SQL to calculate their account balance at the end of all the transactions. Please note that users can do transactions among themselves as well, display the output in ascending order of the final balance.

 

Table: users
+-----------------+-------------+
| COLUMN_NAME     | DATA_TYPE   |
+-----------------+-------------+
| user_id         | int         |
| username        | varchar(10) |
| opening_balance | int         |
+-----------------+-------------+

Table: transactions
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| id          | int       |
| from_userid | int       |
| to_userid   | int       |
| amount      | int       |
+-------------+-----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    u.user_id,
    u.username,
    u.opening_balance + COALESCE(SUM(t.net_amount), 0) AS final_balance
FROM users u
LEFT JOIN (
    SELECT 
        user_id,
        SUM(amount) AS net_amount
    FROM (
        SELECT from_userid AS user_id, -amount AS amount FROM transactions
        UNION ALL
        SELECT to_userid AS user_id, amount AS amount FROM transactions
    ) combined_transactions
    GROUP BY user_id
) t ON u.user_id = t.user_id
GROUP BY u.user_id, u.username, u.opening_balance
ORDER BY final_balance ASC;
```
