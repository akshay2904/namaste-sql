-- ======================================================================
-- 198 - Customer Revenue Report
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Hackerrank
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/198-customer-revenue-report
-- ======================================================================

/*
As part of NamasteMart's e-commerce marketing analytics, they need a revenue report for their customers in July, 2021. Revenue from a customer is the sum of the values described below.

type=BUY, the customer purchased something, the transaction amount is potential revenue
type=SELL, the customer sold something, NamasteMart collects a fee, 10% of the transaction amount is potential revenue

Status determines how a transaction is treated.

status = COMPLETED, the transaction is included
status = PENDING, the transaction is ignored
status = CANCELED, the transaction is void, 1% of the transaction amount is deducted from revenue

Requirements:

Columns to report are customer, buy, sell, total.
buy, and sell are revenues for buy and sell transactions, respectively.
total is the sum of buy and sell.
Round to 2 places after the decimal.
Order the records descending by total.

 
Table: transactions
+--------------+--------------+----------------------------------+
| COLUMN_NAME  | DATA_TYPE    | DESCRIPTION                      |
+--------------+--------------+----------------------------------+
| dt           | VARCHAR(19)  | Transaction timestamp            |
| customer     | VARCHAR(64)  | Customer email address           |
| type         | VARCHAR(4)   | Transaction type                 |
| amount       | DECIMAL(4,2) | Transaction amount               |
| status       | VARCHAR(9)   | Transaction status               |
+--------------+--------------+----------------------------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
  customer,
  ROUND(COALESCE(SUM(CASE 
    WHEN type = 'BUY' AND status = 'COMPLETED' THEN amount
    WHEN type = 'BUY' AND status = 'CANCELED' THEN -0.01 * amount
    ELSE 0
  END), 0), 2) AS buy,
  ROUND(COALESCE(SUM(CASE 
    WHEN type = 'SELL' AND status = 'COMPLETED' THEN 0.10 * amount
    WHEN type = 'SELL' AND status = 'CANCELED' THEN -0.01 * amount
    ELSE 0
  END), 0), 2) AS sell,
  ROUND(COALESCE(SUM(CASE 
    WHEN status = 'COMPLETED' AND type = 'BUY' THEN amount
    WHEN status = 'COMPLETED' AND type = 'SELL' THEN 0.10 * amount
    WHEN status = 'CANCELED' THEN -0.01 * amount
    ELSE 0
  END), 0), 2) AS total
FROM transactions
WHERE dt >= '2021-07-01' AND dt < '2021-08-01'
GROUP BY customer
ORDER BY total DESC;
```
