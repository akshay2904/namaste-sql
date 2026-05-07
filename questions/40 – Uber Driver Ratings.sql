-- ======================================================================
-- 40 – Uber Driver Ratings
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Uber
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/40-uber-driver-ratings
-- ======================================================================

/*
Suppose you are a data analyst working for ride-sharing platform Uber. Uber is interested in analyzing the performance of drivers based on their ratings and wants to categorize them into different performance tiers. 

Write an SQL query to categorize drivers equally into three performance tiers (Top, Middle, and Bottom) based on their average ratings. Drivers with the highest average ratings should be placed in the top tier, drivers with ratings below the top tier but above the bottom tier should be placed in the middle tier, and drivers with the lowest average ratings should be placed in the bottom tier. Sort the output in decreasing order of average rating.

 
Table : driver_ratings
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| driver_id   | int          |
| avg_rating  | decimal(3,2) |
+-------------+--------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    driver_id,
    avg_rating,
    CASE 
        WHEN avg_rating >= PERCENTILE_CONT(0.6666) WITHIN GROUP (ORDER BY avg_rating) OVER () 
            THEN 'Top'
        WHEN avg_rating >= PERCENTILE_CONT(0.3333) WITHIN GROUP (ORDER BY avg_rating) OVER () 
            THEN 'Middle'
        ELSE 'Bottom'
    END AS performance_tier
FROM driver_ratings
ORDER BY avg_rating DESC;
```
