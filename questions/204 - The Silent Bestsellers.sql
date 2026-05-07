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

```sql
WITH sales_with_revenue AS (
  -- Calculate revenue for each sale
  SELECT 
    s.sale_id,
    s.product_id,
    s.category,
    s.store_id,
    s.sale_date,
    s.quantity * s.unit_price AS revenue
  FROM sales s
),
products_with_promotions AS (
  -- Identify all product_ids that have ever been promoted
  SELECT DISTINCT product_id
  FROM promotions
),
category_revenue AS (
  -- Aggregate sales by product and category
  SELECT 
    product_id,
    category,
    SUM(revenue) AS total_revenue,
    COUNT(DISTINCT store_id) AS stores_sold_in,
    MIN(sale_date) AS first_sale_date,
    MAX(sale_date) AS last_sale_date
  FROM sales_with_revenue
  GROUP BY product_id, category
  -- Filter: must be sold in at least 2 stores
  HAVING COUNT(DISTINCT store_id) >= 2
),
ranked_by_category AS (
  -- Rank products within each category by total revenue using DENSE_RANK
  SELECT 
    product_id,
    category,
    total_revenue,
    stores_sold_in,
    first_sale_date,
    last_sale_date,
    DENSE_RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS revenue_rank
  FROM category_revenue
),
top_3_per_category AS (
  -- Filter to only top 3 in each category
  SELECT 
    product_id,
    category,
    total_revenue,
    stores_sold_in,
    first_sale_date,
    last_sale_date,
    revenue_rank
  FROM ranked_by_category
  WHERE revenue_rank <= 3
),
silent_bestsellers AS (
  -- Exclude products that have any promotion record
  SELECT 
    t.product_id,
    t.category,
    t.total_revenue,
    t.revenue_rank,
    t.stores_sold_in,
    t.first_sale_date,
    t.last_sale_date
  FROM top_3_per_category t
  WHERE t.product_id NOT IN (SELECT product_id FROM products_with_promotions)
)
SELECT 
  product_id,
  category,
  total_revenue,
  revenue_rank,
  stores_sold_in,
  first_sale_date,
  last_sale_date
FROM silent_bestsellers
ORDER BY product_id, category, revenue_rank;
```
