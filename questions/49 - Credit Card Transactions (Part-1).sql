-- ======================================================================
-- 49 - Credit Card Transactions (Part-1)
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Google
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/49-credit-card-transactions-part-1
-- ======================================================================

/*
You are given a history of credit card transaction data for the people of India across cities . Write an SQL to find how many days each city took to reach cumulative spend of 1500 from its first day of transactions. 

Display city, first transaction date , date of 1500 spend and # of days in the ascending order of city.

 
Table: credit_card_transactions
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| transaction_id   | int         |
| transaction_date | date        |
| amount           | int         |
| card_type        | varchar(12) |
| city             | varchar(20) |
| gender           | varchar(1)  |
+------------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    city,
    MIN(transaction_date) AS first_transaction_date,
    MIN(CASE WHEN cumulative_spend >= 1500 THEN transaction_date END) AS date_of_1500_spend,
    DATEDIFF(
        day,
        MIN(transaction_date),
        MIN(CASE WHEN cumulative_spend >= 1500 THEN transaction_date END)
    ) AS days_to_reach_1500
FROM (
    SELECT 
        city,
        transaction_date,
        amount,
        SUM(amount) OVER (PARTITION BY city ORDER BY transaction_date, transaction_id) AS cumulative_spend
    FROM credit_card_transactions
) subquery
GROUP BY city
ORDER BY city ASC;
```
