-- ======================================================================
-- 134 - Dormant Customers
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Swiggy
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/134-dormant-customers
-- ======================================================================

/*
Imagine you are working for Swiggy (a food delivery service platform). As part of your role in the data analytics team, you're tasked with identifying dormant customers - those who have registered on the platform but have not placed any orders recently. Identifying dormant customers is crucial for targeted marketing efforts and customer re-engagement strategies.

 

A dormant customer is defined as a user who registered more than 6 months ago from today but has not placed any orders in the last 3 months. Your query should return the list of dormant customers and order amount of last order placed by them. If no order was placed by a customer then order amount should be 0. order the output by user id.

Note: All the dates are in UTC time zone.

 
Table: users
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| user_id      | int      |
| name         | varchar  | 
| email        | varchar  |
| signup_date  | date     |
+--------------+--------- +Table: orders
+--------------+----------+
| COLUMN_NAME  | DATA_TYPE|
+--------------+----------+
| order_id     | int      |
| order_date   | date     | 
| user_id      | int      |
| order_amount | int      |
+--------------+----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    u.user_id,
    u.name,
    u.email,
    u.signup_date,
    COALESCE(MAX(o.order_amount), 0) AS last_order_amount
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE u.signup_date < CURRENT_DATE - INTERVAL '6 months'
    AND (
        SELECT MAX(order_date) 
        FROM orders 
        WHERE user_id = u.user_id
    ) < CURRENT_DATE - INTERVAL '3 months'
    OR (
        SELECT COUNT(*) 
        FROM orders 
        WHERE user_id = u.user_id
    ) = 0
GROUP BY u.user_id, u.name, u.email, u.signup_date
ORDER BY u.user_id;
```
