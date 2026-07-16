SELECT o.order_id, c.name, c.city, o.amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
ORDER BY o.order_id
