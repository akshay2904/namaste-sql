SELECT customer_id FROM orders WHERE product = 'Laptop'
INTERSECT
SELECT customer_id FROM orders WHERE product = 'Phone'
ORDER BY customer_id
