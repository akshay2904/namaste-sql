-- ======================================================================
-- 23 - Product Recommendation
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/23-product-recommendation
-- ======================================================================

/*
Product recommendation. Just the basic type (“customers who bought this also bought…”). That, in its simplest form, is an outcome of basket analysis. Write a SQL to find the product pairs which have been purchased together in same order along with the purchase frequency (count of times they have been purchased together). Based on this data Amazon can recommend frequently bought together products to other users.

Order the output by purchase frequency in descending order. Please make in the output first product column has id greater than second product column. 

 
Table: orders (primary key : order_id)
+-------------+------------+
| COLUMN_NAME | DATA_TYPE  |
+-------------+------------+
| order_id    | int        |
| customer_id | int        |
| product_id  | varchar(2) |
+-------------+------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    CASE 
        WHEN o1.product_id > o2.product_id THEN o1.product_id
        ELSE o2.product_id
    END AS product_1,
    CASE 
        WHEN o1.product_id > o2.product_id THEN o2.product_id
        ELSE o1.product_id
    END AS product_2,
    COUNT(*) AS purchase_frequency
FROM orders o1
INNER JOIN orders o2 
    ON o1.order_id = o2.order_id 
    AND o1.product_id < o2.product_id
GROUP BY 
    CASE 
        WHEN o1.product_id > o2.product_id THEN o1.product_id
        ELSE o2.product_id
    END,
    CASE 
        WHEN o1.product_id > o2.product_id THEN o2.product_id
        ELSE o1.product_id
    END
ORDER BY purchase_frequency DESC;
```
