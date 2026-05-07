-- ======================================================================
-- 48 – Female Contribution
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Google
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/48-female-contribution
-- ======================================================================

/*
You are given a history of credit card transaction data for the people of India across cities. Write an SQL to find percentage contribution of spends by females in each city.  Round the percentage to 2 decimal places. Display city, total spend , female spend and female contribution in ascending order of city.

 
Table: credit_card_transactions
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| amount           | int         |
| card_type        | varchar(10) |
| city             | varchar(10) |
| gender           | varchar(1)  |
| transaction_date | date        |
| transaction_id   | int         |
+------------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    city,
    SUM(amount) AS total_spend,
    SUM(CASE WHEN gender = 'F' THEN amount ELSE 0 END) AS female_spend,
    ROUND(
        (SUM(CASE WHEN gender = 'F' THEN amount ELSE 0 END) * 100.0) / SUM(amount),
        2
    ) AS female_contribution_percentage
FROM credit_card_transactions
GROUP BY city
ORDER BY city ASC;
```
