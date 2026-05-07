-- ======================================================================
-- 81 - Consistent Growth
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Google
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/81-consistent-growth
-- ======================================================================

/*
In a financial analysis project, you are tasked with identifying companies that have consistently increased their revenue by at least 25% every year. You have a table named revenue that contains information about the revenue of different companies over several years.
Your goal is to find companies whose revenue has increased by at least 25% every year consecutively. So for example If a company's revenue has increased by 25% or more for three consecutive years but not for the fourth year, it will not be considered.

Write an SQL query to retrieve the names of companies that meet the criteria mentioned above along with total lifetime revenue , display the output in ascending order of company id
Table : revenue 
+-------------+---------------+
| COLUMN_NAME | DATA_TYPE     |
+-------------+---------------+
| company_id  | int           |
| year        | int           |
| revenue     | decimal(10,2) |
+-------------+---------------+
*/


-- Write your SQL solution below:

```sql
WITH yearly_growth AS (
  SELECT
    company_id,
    year,
    revenue,
    LAG(revenue) OVER (PARTITION BY company_id ORDER BY year) AS prev_revenue,
    CASE 
      WHEN LAG(revenue) OVER (PARTITION BY company_id ORDER BY year) IS NOT NULL
      THEN (revenue - LAG(revenue) OVER (PARTITION BY company_id ORDER BY year)) / LAG(revenue) OVER (PARTITION BY company_id ORDER BY year)
      ELSE NULL
    END AS growth_rate
  FROM revenue
),
growth_check AS (
  SELECT
    company_id,
    year,
    CASE WHEN growth_rate >= 0.25 THEN 1 ELSE 0 END AS meets_threshold
  FROM yearly_growth
  WHERE growth_rate IS NOT NULL
),
consecutive_years AS (
  SELECT
    company_id,
    year,
    meets_threshold,
    year - ROW_NUMBER() OVER (PARTITION BY company_id, meets_threshold ORDER BY year) AS group_id
  FROM growth_check
),
valid_companies AS (
  SELECT
    company_id,
    COUNT(*) AS consecutive_growth_years
  FROM consecutive_years
  WHERE meets_threshold = 1
  GROUP BY company_id, group_id
  HAVING COUNT(*) = (SELECT COUNT(DISTINCT year) - 1 FROM revenue r WHERE r.company_id = consecutive_years.company_id)
)
SELECT
  r.company_id,
  (SELECT company_name FROM revenue WHERE company_id = r.company_id LIMIT 1) AS company_name,
  SUM(r.revenue) AS total_lifetime_revenue
FROM revenue r
WHERE r.company_id IN (SELECT company_id FROM valid_companies)
GROUP BY r.company_id
ORDER BY r.company_id ASC;
```

Wait, let me reconsider this solution. The requirement is that the company must have increased revenue by at least 25% EVERY year consecutively with NO breaks. Let me provide a cleaner approach:

```sql
WITH yearly_growth AS (
  SELECT
    company_id,
    year,
    revenue,
    LAG(revenue) OVER (PARTITION BY company_id ORDER BY year) AS prev_revenue
  FROM revenue
),
growth_rates AS (
  SELECT
    company_id,
    year,
    revenue,
    CASE 
      WHEN prev_revenue IS NOT NULL AND (revenue - prev_revenue) / prev_revenue >= 0.25 THEN 1
      ELSE 0
    END AS meets_threshold
  FROM yearly_growth
),
consecutive_groups AS (
  SELECT
    company_id,
    year,
    meets_threshold,
    SUM(CASE WHEN meets_threshold = 0 THEN 1 ELSE 0 END) OVER (PARTITION BY company_id ORDER BY year) AS group_id
  FROM growth_rates
  WHERE prev_revenue IS NOT NULL
),
valid_companies AS (
  SELECT DISTINCT company_id
  FROM consecutive_groups
  GROUP BY company_id, group_id
  HAVING SUM(meets_threshold) = COUNT(*) AND COUNT(*) = (SELECT COUNT(DISTINCT year) - 1 FROM revenue r2 WHERE r2.company_id = consecutive_groups.company_id)
)
SELECT
  company_id,
  SUM(revenue) AS total_lifetime_revenue
FROM revenue
WHERE company_id IN (SELECT company_id FROM valid_companies)
GROUP BY company_id
ORDER BY company_id ASC;
```
