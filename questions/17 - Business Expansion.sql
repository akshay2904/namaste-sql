-- ======================================================================
-- 17 - Business Expansion
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/17-business-expansion
-- ======================================================================

/*
Amazon is expanding their pharmacy business to new cities every year. You are given a table of business operations where you have information about cities where Amazon is doing operations along with the business date information.

Write a SQL to find year wise number of new cities added to the business, display the output in increasing order of year.

 
Table: business_operations
+---------------+-----------+
| COLUMN_NAME   | DATA_TYPE |
+---------------+-----------+
| business_date | date      |
| city_id       | int       |
+---------------+-----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    YEAR(MIN(business_date)) AS year,
    COUNT(DISTINCT city_id) AS new_cities
FROM 
    business_operations
GROUP BY 
    YEAR(MIN(business_date))
ORDER BY 
    year ASC;
```

Wait, let me reconsider. The above approach won't work correctly because we need to find the first year each city appeared, then count distinct cities per year.

```sql
SELECT 
    EXTRACT(YEAR FROM first_business_date) AS year,
    COUNT(*) AS new_cities
FROM (
    SELECT 
        city_id,
        MIN(business_date) AS first_business_date
    FROM 
        business_operations
    GROUP BY 
        city_id
) AS city_first_appearance
GROUP BY 
    EXTRACT(YEAR FROM first_business_date)
ORDER BY 
    year ASC;
```
