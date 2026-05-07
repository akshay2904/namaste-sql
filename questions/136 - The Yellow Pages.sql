-- ======================================================================
-- 136 - The Yellow Pages
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Htc global
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/136-the-yellow-pages
-- ======================================================================

/*
To enhance the functionality of "The Yellow Pages" website, create a SQL query to generate a report of companies, including their phone numbers and ratings. The query must account for the following:

Columns in the output:

name: The company name as per below rules:
    For promoted companies:
        Format: [PROMOTED] <company_name>.
    For non-promoted companies:
        Format: <company_name>.

phone: The company phone number.

 

rating: The overall star rating of the company as per rules below:
    Promoted companies : should always have NULL as their rating.
    For non-promoted companies:
        Format: <#_stars> (<average_rating>, based on <total_reviews> reviews), where:
        <#_stars>: Rounded down average rating to the nearest whole number.
        <average_rating>: Exact average rating rounded to 1 decimal place.
        <total_reviews>: Total number of reviews across all categories for the company.

 

Rules: Non-promoted companies should only be included if their average rating is 1 star or higher.

 

Results should be sorted:
By promotion status (promoted first).
In descending order of the average rating (before rounding).
By the total number of reviews (descending).

 

Table: companies
+------------+----------+
| COLUMN_NAME| DATA_TYPE|
+------------+----------+
| id         | int      |
| name       | VARCHAR  | 
| phone      | VARCHAR  | 
| is_promoted| int      | 
+------------+----------+Table: categories
+------------+----------+
| COLUMN_NAME| DATA_TYPE|
+------------+----------+
| company_id | int      |
| name       | VARCHAR  | 
| rating     | decimal  | 
+------------+----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    CASE 
        WHEN c.is_promoted = 1 THEN '[PROMOTED] ' || c.name
        ELSE c.name
    END AS name,
    c.phone,
    CASE 
        WHEN c.is_promoted = 1 THEN NULL
        ELSE FLOOR(AVG(cat.rating)) || ' (' || ROUND(AVG(cat.rating), 1) || ', based on ' || COUNT(cat.rating) || ' reviews)'
    END AS rating
FROM companies c
LEFT JOIN categories cat ON c.id = cat.company_id
GROUP BY c.id, c.name, c.phone, c.is_promoted
HAVING c.is_promoted = 1 OR (c.is_promoted = 0 AND AVG(COALESCE(cat.rating, 0)) >= 1)
ORDER BY 
    c.is_promoted DESC,
    AVG(COALESCE(cat.rating, 0)) DESC,
    COUNT(cat.rating) DESC;
```
