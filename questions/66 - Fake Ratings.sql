-- ======================================================================
-- 66 - Fake Ratings
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/66-fake-ratings
-- ======================================================================

/*
As an analyst at Amazon, you are responsible for ensuring the integrity of product ratings on the platform. Fake ratings can distort the perception of product quality and mislead customers. To maintain trust and reliability, you need to identify potential fake ratings that deviate significantly from the average ratings for each product.
Write an SQL query to identify the single rating that is farthest (in absolute value) from the average rating value for each product, display rating details in ascending order of rating id.

 
Table : product_ratings
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| rating_id   | int          |
| product_id  | int          |
| user_id     | int          |
| rating      | decimal(2,1) |
+-------------+--------------+
*/


-- Write your SQL solution below:

```sql
WITH product_avg AS (
  SELECT 
    product_id,
    AVG(rating) AS avg_rating
  FROM product_ratings
  GROUP BY product_id
),
rating_deviation AS (
  SELECT 
    pr.rating_id,
    pr.product_id,
    pr.user_id,
    pr.rating,
    pa.avg_rating,
    ABS(pr.rating - pa.avg_rating) AS deviation,
    ROW_NUMBER() OVER (PARTITION BY pr.product_id ORDER BY ABS(pr.rating - pa.avg_rating) DESC) AS rn
  FROM product_ratings pr
  JOIN product_avg pa ON pr.product_id = pa.product_id
)
SELECT 
  rating_id,
  product_id,
  user_id,
  rating
FROM rating_deviation
WHERE rn = 1
ORDER BY rating_id ASC;
```
