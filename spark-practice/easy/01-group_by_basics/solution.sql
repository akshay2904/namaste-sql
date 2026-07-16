SELECT customer_id, SUM(amount) AS total_amount
FROM data
GROUP BY customer_id
