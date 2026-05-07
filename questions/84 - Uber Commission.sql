-- ======================================================================
-- 84 - Uber Commission
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Uber
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/84-uber-commission
-- ======================================================================

/*
In a bustling city, Uber operates a fleet of drivers who provide transportation services to passengers. As part of Uber's policy, drivers are subject to a commission deduction from their total earnings. The commission rate is determined based on the average rating received by the driver over their recent trips. This ensures that drivers delivering exceptional service are rewarded with lower commission rates, while those with lower ratings are subject to higher commission rates. 

Commission Calculation: For the first 3 trips of each driver, a standard commission rate of 24% is applied.
After the first 3 trips, the commission rate is determined based on the average rating of the driver's last 3 trips before the current trip:
If the average rating is between 4.7 and 5 (inclusive), the commission rate is 20%.
If the average rating is between 4.5 and 4.7 (inclusive), the commission rate is 23%.
For any other average rating, the default commission rate remains at 24%.

Write an SQL query to calculate the total earnings for each driver after deducting Uber's commission, considering the commission rates as per the given criteria, display the output in ascending order of driver id.

 

Table: trips 
+-------------+--------------+
| COLUMN_NAME | DATA_TYPE    |
+-------------+--------------+
| trip_id     | int          |
| driver_id   | int          |
| fare        | int          |
| rating      | decimal(3,2) |
+-------------+--------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    driver_id,
    ROUND(SUM(fare * (1 - commission_rate / 100.0)), 2) AS total_earnings
FROM (
    SELECT 
        trip_id,
        driver_id,
        fare,
        rating,
        ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY trip_id) AS trip_number,
        CASE 
            WHEN ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY trip_id) <= 3 THEN 24
            ELSE CASE 
                WHEN AVG(rating) OVER (
                    PARTITION BY driver_id 
                    ORDER BY trip_id 
                    ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING
                ) BETWEEN 4.7 AND 5 THEN 20
                WHEN AVG(rating) OVER (
                    PARTITION BY driver_id 
                    ORDER BY trip_id 
                    ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING
                ) BETWEEN 4.5 AND 4.7 THEN 23
                ELSE 24
            END
        END AS commission_rate
    FROM trips
) AS trip_with_commission
GROUP BY driver_id
ORDER BY driver_id ASC;
```
