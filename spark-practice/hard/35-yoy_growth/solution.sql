WITH lagged AS (
    SELECT category,
           year,
           revenue,
           LAG(revenue) OVER (PARTITION BY category ORDER BY year) AS prev_revenue
    FROM annual_revenue
)
SELECT category,
       year,
       revenue,
       ROUND((revenue - prev_revenue) / prev_revenue * 100, 2) AS yoy_growth_pct
FROM lagged
ORDER BY category, year
