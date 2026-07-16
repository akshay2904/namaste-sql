WITH order_stats AS (
    SELECT
        customer_id,
        COUNT(*)              AS total_orders,
        ROUND(AVG(amount), 2) AS avg_order_value
    FROM orders
    GROUP BY customer_id
),
rating_stats AS (
    SELECT
        customer_id,
        ROUND(AVG(score), 2) AS avg_rating
    FROM ratings
    GROUP BY customer_id
)
SELECT
    o.customer_id,
    o.total_orders,
    o.avg_order_value,
    r.avg_rating,
    ROUND(
        (o.total_orders * 0.3) + (o.avg_order_value * 0.5) + (r.avg_rating * 0.2),
        2
    ) AS loyalty_score
FROM order_stats o
JOIN rating_stats r ON o.customer_id = r.customer_id
ORDER BY loyalty_score DESC
