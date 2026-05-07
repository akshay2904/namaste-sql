-- ======================================================================
-- 43 - Customer Retention
-- ======================================================================
-- Difficulty : Extreme Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/43-customer-retention
-- ======================================================================

/*
Customer retention can be defined as number of customers who continue to make purchases over a certain period compared to the total number of customers. Here's a step-by-step approach to calculate customer retention rate:
1- Determine the number of customers who made purchases 
in the current period (e.g., month: m )
2- Identify the number of customers from month m who made purchases 
in month m+1 , m+2 as well.
Suppose you are a data analyst working for Amazon. The company is interested in measuring customer retention over the months to understand how many customers continue to make purchases over time. Your task is to write an SQL to derive customer retention month over month, display the output in ascending order of current year, month & future year, month.

 
Table: orders
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| order_id    | int       |
| customer_id | int       |
| order_date  | date      |
+-------------+-----------+
*/


-- Write your SQL solution below:

```sql
WITH monthly_customers AS (
  -- Get unique customers for each month
  SELECT DISTINCT
    EXTRACT(YEAR FROM order_date)::INT AS year,
    EXTRACT(MONTH FROM order_date)::INT AS month,
    customer_id
  FROM orders
),
current_month AS (
  -- Get customers in current month (m)
  SELECT
    year AS current_year,
    month AS current_month,
    COUNT(DISTINCT customer_id) AS customers_in_month
  FROM monthly_customers
  GROUP BY year, month
),
retention_months AS (
  -- Join current month customers with future months to find retention
  SELECT
    cm.current_year,
    cm.current_month,
    fm.year AS future_year,
    fm.month AS future_month,
    COUNT(DISTINCT cm_cust.customer_id) AS retained_customers
  FROM current_month cm
  JOIN monthly_customers cm_cust 
    ON cm.current_year = EXTRACT(YEAR FROM 
       DATE_TRUNC('month', DATE_MAKE(cm.current_year, cm.current_month, 1))::DATE)::INT
    AND cm.current_month = EXTRACT(MONTH FROM 
       DATE_TRUNC('month', DATE_MAKE(cm.current_year, cm.current_month, 1))::DATE)::INT
  JOIN monthly_customers fm 
    ON cm_cust.customer_id = fm.customer_id
    AND (fm.year > cm.current_year 
         OR (fm.year = cm.current_year AND fm.month > cm.current_month))
  GROUP BY cm.current_year, cm.current_month, fm.year, fm.month
)
SELECT
  rm.current_year,
  rm.current_month,
  rm.future_year,
  rm.future_month,
  cm.customers_in_month,
  rm.retained_customers,
  ROUND(100.0 * rm.retained_customers / cm.customers_in_month, 2) AS retention_rate_percent
FROM retention_months rm
JOIN current_month cm 
  ON rm.current_year = cm.current_year 
  AND rm.current_month = cm.current_month
ORDER BY rm.current_year, rm.current_month, rm.future_year, rm.future_month;
```
