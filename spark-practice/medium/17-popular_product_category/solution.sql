SELECT category, product_name, total_quantity
FROM (
  SELECT p.category, p.product_name,
         SUM(s.quantity) AS total_quantity,
         RANK() OVER (PARTITION BY p.category ORDER BY SUM(s.quantity) DESC) AS rank
  FROM products p
  JOIN sales s ON p.product_id = s.product_id
  GROUP BY p.category, p.product_name
)
WHERE rank = 1
ORDER BY category
