-- ======================================================================
-- 204 - The Silent Bestsellers
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Flipkart
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/204-the-silent-bestsellers
-- ======================================================================

/*
You work at a retail analytics company managing data for a chain of stores across multiple cities. The product team wants to identify "Silent Bestsellers" — products that are among the top 3 best-selling products by revenue in their category, but have never been promoted or discounted in any way.

The idea is simple — these products sell well purely on merit, with no marketing push. The business wants to reward these products with premium shelf placement.

---

Table: sales
One row per sale transaction.
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| sale_id       | INT       |
| product_id    | INT       |
| category      | VARCHAR   |
| store_id      | INT       |
| sale_date     | DATE      |
| quantity      | INT       |
| unit_price    | DECIMAL   |
+---------------+-----------+
Table: promotions
One row per product promotion event.
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| promotion_id  | INT       |
| product_id    | INT       |
| store_id      | INT       |
| promo_start   | DATE      |
| promo_end     | DATE      |
+---------------+-----------+
---

The Ask:

Find all Silent Bestsellers and return:

- `product_id`
- `category`
- `total_revenue` — total revenue across all stores and all time
- `revenue_rank` — rank within their category by total revenue
- `stores_sold_in` — number of distinct stores the product was sold in
- `first_sale_date` — earliest sale date for this product
- `last_sale_date` — most recent sale date for this product

order the result by product id, category and revenue rank.

Constraints & Traps:

> - A product is a **Silent Bestseller** if it ranks **top 3 by total revenue within its category**
> - A product is **disqualified** if it appears in the `promotions` table **at any store, ever** — even if the promotion was in a different store than where it sold well
> - Revenue = `quantity * unit_price`
> - If two products have the same revenue, use **DENSE_RANK** so both can qualify and ranking should be done only within qualified products. 
> - A product must have been sold in **at least 2 stores** to qualify
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH never_promoted AS (
    -- Products that have NEVER appeared in promotions table at any store
    SELECT DISTINCT product_id
    FROM sales
    WHERE product_id NOT IN (SELECT DISTINCT product_id FROM promotions)
),
product_revenue AS (
    -- Aggregate revenue and store/date metrics for never-promoted products
    SELECT
        s.product_id,
        s.category,
        SUM(s.quantity * s.unit_price)  AS total_revenue,
        COUNT(DISTINCT s.store_id)      AS stores_sold_in,
        MIN(s.sale_date)                AS first_sale_date,
        MAX(s.sale_date)                AS last_sale_date
    FROM sales s
    INNER JOIN never_promoted np ON s.product_id = np.product_id
    GROUP BY s.product_id, s.category
    HAVING COUNT(DISTINCT s.store_id) >= 2  -- must have sold in at least 2 stores
),
ranked AS (
    -- Dense rank within category among qualified products only
    SELECT
        product_id,
        category,
        total_revenue,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS revenue_rank,
        stores_sold_in,
        first_sale_date,
        last_sale_date
    FROM product_revenue
)
SELECT
    product_id,
    category,
    total_revenue,
    revenue_rank,
    stores_sold_in,
    first_sale_date,
    last_sale_date
FROM ranked
WHERE revenue_rank <= 3
ORDER BY product_id, category, revenue_rank;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    base.product_id,
    base.category,
    base.total_revenue,
    -- Compute dense rank manually via correlated subquery
    (
        SELECT COUNT(DISTINCT inner_q.total_revenue)
        FROM (
            SELECT
                s2.product_id,
                SUM(s2.quantity * s2.unit_price) AS total_revenue
            FROM sales s2
            WHERE s2.category = base.category
              AND s2.product_id NOT IN (SELECT DISTINCT product_id FROM promotions)
            GROUP BY s2.product_id
            HAVING COUNT(DISTINCT s2.store_id) >= 2
        ) inner_q
        WHERE inner_q.total_revenue > base.total_revenue
    ) + 1                               AS revenue_rank,
    base.stores_sold_in,
    base.first_sale_date,
    base.last_sale_date
FROM (
    -- Qualified products: never promoted, sold in >= 2 stores
    SELECT
        s.product_id,
        s.category,
        SUM(s.quantity * s.unit_price)  AS total_revenue,
        COUNT(DISTINCT s.store_id)      AS stores_sold_in,
        MIN(s.sale_date)                AS first_sale_date,
        MAX(s.sale_date)                AS last_sale_date
    FROM sales s
    WHERE s.product_id NOT IN (SELECT DISTINCT product_id FROM promotions)
    GROUP BY s.product_id, s.category
    HAVING COUNT(DISTINCT s.store_id) >= 2
) base
WHERE (
    -- Keep only top 3 revenue ranks within category (dense rank <= 3)
    SELECT COUNT(DISTINCT inner_q2.total_revenue)
    FROM (
        SELECT
            s3.product_id,
            SUM(s3.quantity * s3.unit_price) AS total_revenue
        FROM sales s3
        WHERE s3.category = base.category
          AND s3.product_id NOT IN (SELECT DISTINCT product_id FROM promotions)
        GROUP BY s3.product_id
        HAVING COUNT(DISTINCT s3.store_id) >= 2
    ) inner_q2
    WHERE inner_q2.total_revenue > base.total_revenue
) < 3                                   -- fewer than 3 distinct revenues are higher => rank <= 3
ORDER BY base.product_id, base.category, revenue_rank;
