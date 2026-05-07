-- ======================================================================
-- 55 - Lowest Price
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Pwc
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/55-lowest-price
-- ======================================================================

/*
You own a small online store, and want to analyze customer ratings for the products that you're selling. After doing a data pull, you have a list of products and a log of purchases. Within the purchase log, each record includes the number of stars (from 1 to 5) as a customer rating for the product.

For each category, find the lowest price among all products that received at least one 4-star or above rating from customers.
If a product category did not have any products that received at least one 4-star or above rating, the lowest price is considered to be 0. The final output should be sorted by product category in alphabetical order.
Table: products
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| category    | varchar(10) |
| id          | int         |
| name        | varchar(20) |
| price       | int         |
+-------------+-------------+Table: purchases
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| id          | int       |
| product_id  | int       |
| stars       | int       |
+-------------+-----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    p.category,
    COALESCE(MIN(p.price), 0) AS lowest_price
FROM products p
LEFT JOIN purchases pu ON p.id = pu.product_id AND pu.stars >= 4
WHERE pu.product_id IS NOT NULL OR p.id NOT IN (
    SELECT DISTINCT product_id FROM purchases WHERE stars >= 4
)
GROUP BY p.category
ORDER BY p.category ASC;
```

Wait, let me reconsider this logic more carefully:

```sql
SELECT 
    p.category,
    COALESCE(MIN(CASE WHEN pu.stars >= 4 THEN p.price END), 0) AS lowest_price
FROM products p
LEFT JOIN purchases pu ON p.id = pu.product_id
GROUP BY p.category
ORDER BY p.category ASC;
```
