-- ======================================================================
-- 9 - New and Repeat Customers
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Flipkart
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/9-new-and-repeat-customers
-- ======================================================================

/*
Flipkart wants to build a very important business metrics where they want to track on daily basis how many new and repeat customers are purchasing products from their website. A new customer is defined when he purchased anything for the first time from the website and repeat customer is someone who has done at least one purchase in the past.

 

Display order date , new customers , repeat customers  in ascending order of order_date.

 
Table: customer_orders
+--------------+-----------+
| COLUMN_NAME  | DATA_TYPE |
+--------------+-----------+
| order_id     | int       |
| customer_id  | int       |
| order_date   | date      |
| order_amount | int       |
+--------------+-----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    order_date,
    SUM(CASE WHEN first_purchase = 1 THEN 1 ELSE 0 END) AS new_customers,
    SUM(CASE WHEN first_purchase = 0 THEN 1 ELSE 0 END) AS repeat_customers
FROM (
    SELECT 
        order_id,
        customer_id,
        order_date,
        CASE 
            WHEN ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) = 1 
            THEN 1 
            ELSE 0 
        END AS first_purchase
    FROM customer_orders
) subquery
GROUP BY order_date
ORDER BY order_date ASC;
```
