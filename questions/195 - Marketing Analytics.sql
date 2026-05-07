-- ======================================================================
-- 195 - Marketing Analytics
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Hackerrank
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/195-marketing-analytics
-- ======================================================================

/*
As part of NamasteMart's e-commerce marketing analytics, the team needs to generate a July 2021 customer revenue summary report. Revenue from a customer is the sum of the values described below.

type=BUY, the customer purchased something, the transaction amount is potential revenue
type=SELL, the customer sold something, HackerMart collects a fee, 10% of the transaction amount is potential revenue
 

Status determines how a transaction is treated.

status = COMPLETED, the transaction is included
status = PENDING, the transaction is ignored
status = CANCELED, the transaction is void, 1% of the transaction amount is deducted from total revenue
 

Columns to report are customer, buy, sell, completed, pending, canceled, total. 
buy, sell, completed, pending, and canceled are the number of transactions that match, and total is the total revenue, calculated as described and rounded to 2 places after the decimal. Sort the result in descending order of total revenue.

 
Table: transactions
+-------------+---------------+
| COLUMN_NAME | DATA_TYPE     |
+-------------+---------------+
| dt          | VARCHAR(19)   |
| customer    | VARCHAR(30)   |
| type        | VARCHAR(4)    |
| amount      | DECIMAL(4,2)  |
| status      | VARCHAR(9)    |
+-------------+---------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
  customer,
  SUM(CASE WHEN type = 'BUY' THEN 1 ELSE 0 END) AS buy,
  SUM(CASE WHEN type = 'SELL' THEN 1 ELSE 0 END) AS sell,
  SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed,
  SUM(CASE WHEN status = 'PENDING' THEN 1 ELSE 0 END) AS pending,
  SUM(CASE WHEN status = 'CANCELED' THEN 1 ELSE 0 END) AS canceled,
  ROUND(
    SUM(
      CASE 
        WHEN status = 'COMPLETED' AND type = 'BUY' THEN amount
        WHEN status = 'COMPLETED' AND type = 'SELL' THEN amount * 0.10
        WHEN status = 'CANCELED' THEN -amount * 0.01
        ELSE 0
      END
    ),
    2
  ) AS total
FROM transactions
WHERE dt >= '2021-07-01' AND dt < '2021-08-01'
GROUP BY customer
ORDER BY total DESC;
```
