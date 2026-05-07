-- ======================================================================
-- 21 - Uber Profit Rides
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Uber
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/21-uber-profit-rides
-- ======================================================================

/*
A profit ride for a Uber driver is considered when the start location and start time of a ride exactly match with the previous ride's end location and end time. 

Write an SQL to calculate total number of rides and total profit rides by each driver, display the output in ascending order of id.

 
Table: drivers
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| id          | varchar(10) |
| start_loc   | varchar(1)  |
| start_time  | time        |
| end_loc     | varchar(1)  |
| end_time    | time        |
+-------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    d.id,
    COUNT(*) AS total_rides,
    SUM(CASE 
        WHEN d.start_loc = LAG(d.end_loc) OVER (PARTITION BY d.id ORDER BY d.start_time) 
         AND d.start_time = LAG(d.end_time) OVER (PARTITION BY d.id ORDER BY d.start_time) 
        THEN 1 
        ELSE 0 
    END) AS profit_rides
FROM drivers d
GROUP BY d.id
ORDER BY d.id ASC;
```
