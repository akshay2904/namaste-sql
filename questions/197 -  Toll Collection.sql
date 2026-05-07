-- ======================================================================
-- 197 -  Toll Collection
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Uber
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/197-toll-collection
-- ======================================================================

/*
You are given a table toll_log that records vehicle crossings at a toll plaza. Each row represents one crossing event. Write a SQL query to calculate the total toll amount collected per day for each vehicle type.
The output should contain: crossing_date , vehicle_type, total_amount. Sort the result by crossing_date , vehicle_type.

 

Toll pricing rules

Base Toll:

Motorcycle → 0

Car → 40

Bus → 70

Truck → 80

Return same day rule:

If the same vehicle crosses again same day , apply discounted toll:

Car → 20

Bus → 30

Truck → 40

Motorcycle → 0

 

If a vehicle crosses more than twice on the same day, the toll should alternate between full toll and discounted toll for each crossing.

Example:
If a vehicle crosses 3 times on the same day,
1st crossing → Full toll
2nd crossing → Discounted toll
3rd crossing → Full toll

 
Table: vehicles
+--------------+------------+
| COLUMN_NAME  | DATA_TYPE  |
+--------------+------------+
| id           | INT        |
| vehicle_no   | VARCHAR    |
| vehicle_type | VARCHAR    |
+--------------+------------+Table: toll_log
+--------------+------------+
| COLUMN_NAME  | DATA_TYPE  |
+--------------+------------+
| txn_id       | INT        |
| vehicle_id   | INT        |
| crossing_time| TIMESTAMP  |
+--------------+------------+
*/


-- Write your SQL solution below:

```sql
WITH toll_rates AS (
  SELECT 'Motorcycle' AS vehicle_type, 0 AS full_toll, 0 AS discounted_toll
  UNION ALL
  SELECT 'Car', 40, 20
  UNION ALL
  SELECT 'Bus', 70, 30
  UNION ALL
  SELECT 'Truck', 80, 40
),
crossings_with_sequence AS (
  SELECT 
    tl.txn_id,
    v.vehicle_id,
    v.vehicle_type,
    DATE(tl.crossing_time) AS crossing_date,
    ROW_NUMBER() OVER (PARTITION BY v.vehicle_id, DATE(tl.crossing_time) ORDER BY tl.crossing_time) AS crossing_sequence
  FROM toll_log tl
  INNER JOIN vehicles v ON tl.vehicle_id = v.id
),
crossings_with_toll AS (
  SELECT 
    cws.crossing_date,
    cws.vehicle_type,
    cws.vehicle_id,
    CASE 
      WHEN MOD(cws.crossing_sequence, 2) = 1 THEN tr.full_toll
      ELSE tr.discounted_toll
    END AS toll_amount
  FROM crossings_with_sequence cws
  INNER JOIN toll_rates tr ON cws.vehicle_type = tr.vehicle_type
)
SELECT 
  crossing_date,
  vehicle_type,
  SUM(toll_amount) AS total_amount
FROM crossings_with_toll
GROUP BY crossing_date, vehicle_type
ORDER BY crossing_date, vehicle_type;
```
