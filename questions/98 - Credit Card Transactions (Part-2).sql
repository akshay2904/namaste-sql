-- ======================================================================
-- 98 - Credit Card Transactions (Part-2)
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Paypal
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/98-credit-card-transactions-part-2
-- ======================================================================

/*
You are given a history of credit card transaction data for the people of India across cities as below. Your task is to find out highest spend card type and lowest spent card type for each city, display the output in ascending order of city.

 
Table: credit_card_transactions
+------------------+-------------+
| COLUMN_NAME      | DATA_TYPE   |
+------------------+-------------+
| transaction_id   | int         |
| city             | varchar(10) |
| transaction_date | date        |
| card_type        | varchar(12) |
| gender           | varchar(1)  |
| amount           | int         |
+------------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    city,
    MAX(CASE WHEN rn_desc = 1 THEN card_type END) AS highest_spent_card_type,
    MAX(CASE WHEN rn_asc = 1 THEN card_type END) AS lowest_spent_card_type
FROM (
    SELECT 
        city,
        card_type,
        SUM(amount) AS total_spend,
        ROW_NUMBER() OVER (PARTITION BY city ORDER BY SUM(amount) DESC) AS rn_desc,
        ROW_NUMBER() OVER (PARTITION BY city ORDER BY SUM(amount) ASC) AS rn_asc
    FROM credit_card_transactions
    GROUP BY city, card_type
) ranked
WHERE rn_desc = 1 OR rn_asc = 1
GROUP BY city
ORDER BY city ASC;
```
