-- ======================================================================
-- 39 - Walmart Sales Pattern
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Walmart
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/39-walmart-sales-pattern
-- ======================================================================

/*
You are tasked with analyzing the sales data of a Walmart chain with multiple stores across different locations. The company wants to identify the highest and lowest sales months for each location for the year 2023 to gain insights into their sales patterns, display the output in ascending order of location. In case of a tie display the latest month.

 
Table: stores
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| store_id    | int         |
| store_name  | varchar(20) |
| location    | varchar(20) |
+-------------+-------------+Table: transactions 
+------------------+-----------+
| COLUMN_NAME      | DATA_TYPE |
+------------------+-----------+
| customer_id      | int       |
| store_id         | int       |
| amount           | int       |
| transaction_date | date      |
| transaction_id   | int       |
+------------------+-----------+
*/


-- Write your SQL solution below:

```sql
WITH monthly_sales AS (
  -- Calculate total sales per location per month for 2023
  SELECT 
    s.location,
    DATE_TRUNC('month', t.transaction_date)::DATE AS month,
    SUM(t.amount) AS total_sales
  FROM transactions t
  JOIN stores s ON t.store_id = s.store_id
  WHERE EXTRACT(YEAR FROM t.transaction_date) = 2023
  GROUP BY s.location, DATE_TRUNC('month', t.transaction_date)
),
ranked_sales AS (
  -- Rank months within each location by sales (desc) then by month (desc for ties)
  SELECT 
    location,
    month,
    total_sales,
    RANK() OVER (PARTITION BY location ORDER BY total_sales DESC, month DESC) AS highest_rank,
    RANK() OVER (PARTITION BY location ORDER BY total_sales ASC, month DESC) AS lowest_rank
  FROM monthly_sales
)
-- Get highest and lowest sales months for each location
SELECT 
  location,
  month AS sales_month,
  total_sales,
  'Highest' AS sales_type
FROM ranked_sales
WHERE highest_rank = 1

UNION ALL

SELECT 
  location,
  month AS sales_month,
  total_sales,
  'Lowest' AS sales_type
FROM ranked_sales
WHERE lowest_rank = 1

ORDER BY location ASC, sales_type DESC;
```
