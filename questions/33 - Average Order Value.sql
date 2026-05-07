-- ======================================================================
-- 33 - Average Order Value
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Google
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/33-average-order-value
-- ======================================================================

/*
Write an SQL query to determine the transaction date with the lowest average order value (AOV) among all dates recorded in the transaction table. Display the transaction date, its corresponding AOV, and the difference between the AOV for that date and the highest AOV for any day in the dataset. Round the result to 2 decimal places.

 
Table: transactions 
+--------------------+--------------+
| COLUMN_NAME        | DATA_TYPE    |
+--------------------+--------------+
| order_id           | int          |
| transaction_amount | decimal(5,2) |
| transaction_date   | date         |
| user_id            | int          |
+--------------------+--------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
  daily_aov.transaction_date,
  ROUND(daily_aov.aov, 2) AS aov,
  ROUND(max_aov.max_aov - daily_aov.aov, 2) AS difference_from_max
FROM (
  SELECT 
    transaction_date,
    AVG(transaction_amount) AS aov,
    ROW_NUMBER() OVER (ORDER BY AVG(transaction_amount) ASC) AS rn
  FROM transactions
  GROUP BY transaction_date
) AS daily_aov
CROSS JOIN (
  SELECT MAX(daily_avg) AS max_aov
  FROM (
    SELECT AVG(transaction_amount) AS daily_avg
    FROM transactions
    GROUP BY transaction_date
  ) AS daily_averages
) AS max_aov
WHERE daily_aov.rn = 1;
```
