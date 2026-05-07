-- ======================================================================
-- 139 - Quarterly sales Analysis
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Microsoft
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/139-quarterly-sales-analysis
-- ======================================================================

/*
Given a sales dataset that records daily transactions for various products, write an SQL query to calculate last quarter's total sales and quarter-to-date (QTD) sales for each product, helping analyze past performance and current trends.

 
Table: sales
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id          | int      |
| product_id  | int      | 
| sale_date   | date     | 
| sales_amount | int      | 
+-------------+----------+
*/


-- Write your SQL solution below:

```sql
SELECT
    product_id,
    SUM(CASE 
        WHEN QUARTER(sale_date) = QUARTER(CURDATE()) - 1 
        AND YEAR(sale_date) = YEAR(CURDATE()) - (CASE WHEN QUARTER(CURDATE()) = 1 THEN 1 ELSE 0 END)
        THEN sales_amount 
        ELSE 0 
    END) AS last_quarter_total_sales,
    SUM(CASE 
        WHEN QUARTER(sale_date) = QUARTER(CURDATE())
        AND YEAR(sale_date) = YEAR(CURDATE())
        AND sale_date <= CURDATE()
        THEN sales_amount 
        ELSE 0 
    END) AS qtd_sales
FROM sales
GROUP BY product_id
ORDER BY product_id;
```

Or for PostgreSQL compatibility:

```sql
SELECT
    product_id,
    SUM(CASE 
        WHEN EXTRACT(QUARTER FROM sale_date) = EXTRACT(QUARTER FROM CURRENT_DATE) - 1
        AND EXTRACT(YEAR FROM sale_date) = EXTRACT(YEAR FROM CURRENT_DATE) - CASE WHEN EXTRACT(QUARTER FROM CURRENT_DATE) = 1 THEN 1 ELSE 0 END
        THEN sales_amount 
        ELSE 0 
    END) AS last_quarter_total_sales,
    SUM(CASE 
        WHEN EXTRACT(QUARTER FROM sale_date) = EXTRACT(QUARTER FROM CURRENT_DATE)
        AND EXTRACT(YEAR FROM sale_date) = EXTRACT(YEAR FROM CURRENT_DATE)
        AND sale_date <= CURRENT_DATE
        THEN sales_amount 
        ELSE 0 
    END) AS qtd_sales
FROM sales
GROUP BY product_id
ORDER BY product_id;
```
