-- ======================================================================
-- 110 - Laptop to Laptop Bag Conversion Rate
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/110-laptop-to-laptop-bag-conversion-rate
-- ======================================================================

/*
The marketing team at a retail company wants to analyze customer purchasing behavior. They are particularly interested in understanding how many customers who bought a laptop later went on to purchase a laptop bag, with no intermediate purchases in between. Write an SQL to get number of customer in each country who bought laptop and number of customers who bought laptop bag just after buying a laptop. Order the result by country.

 
Table: transactions
+----------------------+------------+
| COLUMN_NAME          | DATA_TYPE  |
+----------------------+------------+
| transaction_id       | int        |
| customer_id          | date       |
| product_name         | varchar(10)|
| transaction_timestamp| datetime   |
| country              | varchar(5) |
+----------------------+------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    country,
    COUNT(DISTINCT CASE WHEN product_name = 'Laptop' THEN customer_id END) AS customers_bought_laptop,
    COUNT(DISTINCT CASE 
        WHEN product_name = 'Laptop Bag' 
        AND EXISTS (
            SELECT 1 
            FROM transactions t2 
            WHERE t2.customer_id = transactions.customer_id 
            AND t2.product_name = 'Laptop' 
            AND t2.transaction_timestamp < transactions.transaction_timestamp 
            AND NOT EXISTS (
                SELECT 1 
                FROM transactions t3 
                WHERE t3.customer_id = transactions.customer_id 
                AND t3.transaction_timestamp > t2.transaction_timestamp 
                AND t3.transaction_timestamp < transactions.transaction_timestamp 
                AND t3.product_name NOT IN ('Laptop', 'Laptop Bag')
            )
        ) 
        THEN customer_id 
    END) AS customers_bought_bag_after_laptop
FROM transactions
GROUP BY country
ORDER BY country;
```
