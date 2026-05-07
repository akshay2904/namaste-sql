-- ======================================================================
-- 19 - Order Fulfilment
-- ======================================================================
-- Difficulty : Extreme Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/19-order-fulfilment
-- ======================================================================

/*
You are given two tables: products and orders. The products table contains information about each product, including the product ID and available quantity in the warehouse. The orders table contains details about customer orders, including the order ID, product ID, order date, and quantity requested by the customer.

Write an SQL query to generate a report listing the orders that can be fulfilled based on the available inventory in the warehouse, following a first-come-first-serve approach based on the order date. Each row in the report should include the order ID, product name, quantity requested by the customer, quantity actually fulfilled, and a comments column as below:

If the order can be completely fulfilled then 'Full Order'.

If the order can be partially fulfilled then 'Partial Order'.

If order cannot be fulfilled at all then 'No Order' .

Display the output in ascending order of order id.

 
Table: products
+--------------------+-------------+
| COLUMN_NAME        | DATA_TYPE   |
+--------------------+-------------+
| product_id         | int         |
| product_name       | varchar(10) |
| available_quantity | int         |
+--------------------+-------------+

Table: orders
+--------------------+-----------+
| COLUMN_NAME        | DATA_TYPE |
+--------------------+-----------+
| order_id           | int       |
| product_id         | int       |
| order_date         | date      |
| quantity_requested | int       |
+--------------------+-----------+
*/


-- Write your SQL solution below:

```sql
WITH ordered_requests AS (
  -- Assign running total of quantity requested per product in order date sequence
  SELECT 
    o.order_id,
    o.product_id,
    o.order_date,
    o.quantity_requested,
    p.product_name,
    p.available_quantity,
    SUM(o.quantity_requested) OVER (
      PARTITION BY o.product_id 
      ORDER BY o.order_date, o.order_id
    ) AS cumulative_quantity
  FROM orders o
  JOIN products p ON o.product_id = p.product_id
),
fulfillment AS (
  -- Calculate quantity fulfilled for each order based on available inventory
  SELECT 
    order_id,
    product_name,
    quantity_requested,
    available_quantity,
    CASE 
      -- Previous cumulative quantity (cumulative before this order)
      WHEN LAG(cumulative_quantity, 1, 0) OVER (
        PARTITION BY product_id 
        ORDER BY order_date, order_id
      ) >= available_quantity THEN 0
      -- Quantity fulfilled is minimum of what's requested and what's available
      ELSE LEAST(
        quantity_requested,
        available_quantity - LAG(cumulative_quantity, 1, 0) OVER (
          PARTITION BY product_id 
          ORDER BY order_date, order_id
        )
      )
    END AS quantity_fulfilled
  FROM ordered_requests
)
SELECT 
  order_id,
  product_name,
  quantity_requested,
  quantity_fulfilled,
  CASE 
    WHEN quantity_fulfilled = quantity_requested THEN 'Full Order'
    WHEN quantity_fulfilled > 0 THEN 'Partial Order'
    ELSE 'No Order'
  END AS comments
FROM fulfillment
ORDER BY order_id ASC;
```
