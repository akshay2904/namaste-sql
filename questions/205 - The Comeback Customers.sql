-- ======================================================================
-- 205 - The Comeback Customers
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/205-the-comeback-customers
-- ======================================================================

/*
You work at an e-commerce company. The marketing team wants to identify “Comeback Customers” — customers who had a period of inactivity (no orders for 60 or more days) and then came back to purchase again. The team wants to understand their buying behaviour before and after the comeback.

---

Table: orders
One row per order placed by a customer.
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| order_id      | INT       |
| customer_id   | INT       |
| order_date    | DATE      |
| order_amount  | INT       |
+---------------+-----------+
---

The Ask

Find all comeback customers and return one row per customer:

- `customer_id`
- `gap_days` — the longest gap (in days) between any two consecutive orders
- `orders_before_comeback` — number of orders placed before the gap
- `orders_after_comeback` — number of orders placed after the gap
- `spend_before_comeback` — total amount spent before the gap
- `spend_after_comeback` — total amount spent after the gap
- `comeback_date` — the order date when they came back after the longest gap

Constraints & Traps:

> - Only consider customers who have placed **at least 2 orders**
> - Gap is measured between **consecutive orders** sorted by date
> - If a customer has **multiple gaps ≥ 60 days**, report only the **longest gap**
> - If two gaps are equal in length, pick the **earliest one**
> - Customers with **no gap ≥ 60 days** should not appear in the result
> - `orders_before_comeback` and `orders_after_comeback` are split at the longest gap
*/


-- Write your SQL solution below:

```sql
WITH customer_orders AS (
  -- Get all orders with row numbers for consecutive order analysis
  SELECT
    customer_id,
    order_id,
    order_date,
    order_amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_num,
    LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date
  FROM orders
),
gaps_calculated AS (
  -- Calculate gaps between consecutive orders
  SELECT
    customer_id,
    order_id,
    order_date,
    order_amount,
    order_num,
    DATEDIFF(day, prev_order_date, order_date) AS gap_days
  FROM customer_orders
  WHERE prev_order_date IS NOT NULL
),
comeback_candidates AS (
  -- Find customers with at least one gap >= 60 days
  SELECT
    customer_id,
    MAX(gap_days) AS max_gap_days
  FROM gaps_calculated
  WHERE gap_days >= 60
  GROUP BY customer_id
),
longest_gaps AS (
  -- For each comeback customer, identify their longest gap (earliest if tied)
  SELECT
    g.customer_id,
    g.gap_days,
    g.order_date,
    g.order_num,
    ROW_NUMBER() OVER (PARTITION BY g.customer_id ORDER BY g.gap_days DESC, g.order_date ASC) AS gap_rank
  FROM gaps_calculated g
  INNER JOIN comeback_candidates cc ON g.customer_id = cc.customer_id
  WHERE g.gap_days = cc.max_gap_days
),
comeback_info AS (
  -- Get the comeback order details for each customer
  SELECT
    customer_id,
    gap_days,
    order_date AS comeback_date,
    order_num AS comeback_order_num
  FROM longest_gaps
  WHERE gap_rank = 1
),
final_result AS (
  SELECT
    ci.customer_id,
    ci.gap_days,
    ci.comeback_date,
    ci.comeback_order_num,
    -- Count orders before comeback (orders before the comeback_order_num)
    SUM(CASE WHEN co.order_num < ci.comeback_order_num THEN 1 ELSE 0 END) AS orders_before_comeback,
    -- Count orders after comeback (orders after the comeback_order_num)
    SUM(CASE WHEN co.order_num >= ci.comeback_order_num THEN 1 ELSE 0 END) AS orders_after_comeback,
    -- Sum amounts before comeback
    SUM(CASE WHEN co.order_num < ci.comeback_order_num THEN co.order_amount ELSE 0 END) AS spend_before_comeback,
    -- Sum amounts after comeback (including the comeback order itself)
    SUM(CASE WHEN co.order_num >= ci.comeback_order_num THEN co.order_amount ELSE 0 END) AS spend_after_comeback
  FROM comeback_info ci
  INNER JOIN customer_orders co ON ci.customer_id = co.customer_id
  GROUP BY ci.customer_id, ci.gap_days, ci.comeback_date, ci.comeback_order_num
)
SELECT
  customer_id,
  gap_days,
  orders_before_comeback,
  orders_after_comeback,
  spend_before_comeback,
  spend_after_comeback,
  comeback_date
FROM final_result
ORDER BY customer_id;
```
