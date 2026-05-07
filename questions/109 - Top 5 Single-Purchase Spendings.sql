-- ======================================================================
-- 109 - Top 5 Single-Purchase Spendings
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/109-top-5-single-purchase-spendings
-- ======================================================================

/*
Write an SQL to retrieve the top 5 customers who have spent the most on their single purchase. Sort the result by max single purchase in descending order.

 
Table: purchase
+-------------+------------+
|COLUMN_NAME  | DATA_TYPE  |
+-------------+------------+
|customer_id  | int        |
|purchase_date| date       |
|amount       | int        |
+-------------+------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    customer_id,
    MAX(amount) AS max_single_purchase
FROM purchase
GROUP BY customer_id
ORDER BY max_single_purchase DESC
LIMIT 5;
```
