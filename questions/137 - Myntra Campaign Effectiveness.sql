-- ======================================================================
-- 137 - Myntra Campaign Effectiveness
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Myntra
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/137-myntra-campaign-effectiveness
-- ======================================================================

/*
Myntra marketing team wants to measure the effectiveness of recent campaigns aimed at acquiring new customers. A new customer is defined as someone who made their first-ever purchase during a specific period, with no prior purchase history.

They have asked you to identify the new customers acquired in the last 3 months, excluding the current month. Output should display customer id and their first purchase date. Order the result by customer id.

For example:
If today is March 15, 2025, the SQL should give customers whose first purchase falls in the range from December 1, 2024, to February 28, 2025, and should not include any new customers made in March 2025.
 
Table: transactions
+---------------+------------+
| COLUMN_NAME     | DATA_TYPE|
+-----------------+----------+
| transaction_id  | int      |
| customer_id     | int      | 
| transaction_date| date     | 
| amount          | int      | 
+-----------------+----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    customer_id,
    MIN(transaction_date) AS first_purchase_date
FROM 
    transactions
WHERE 
    transaction_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '3 months')
    AND transaction_date < DATE_TRUNC('month', CURRENT_DATE)
GROUP BY 
    customer_id
HAVING 
    COUNT(*) >= 1
    AND MIN(transaction_date) >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '3 months')
ORDER BY 
    customer_id;
```
