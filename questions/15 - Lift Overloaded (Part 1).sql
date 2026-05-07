-- ======================================================================
-- 15 - Lift Overloaded (Part 1)
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Meta
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/15-lift-overloaded-part-1
-- ======================================================================

/*
You are given a table of list of lifts , their maximum capacity and people along with their weight who wants to enter into it. You need to make sure maximum people enter into the lift without lift getting overloaded.

For each lift find the comma separated list of people who can be accommodated. The comma separated list should have people in the order of their weight in increasing order, display the output in increasing order of id.

 
Table: lifts
+-------------+-----------+
| COLUMN_NAME | DATA_TYPE |
+-------------+-----------+
| capacity_kg | int       |
| id          | int       |
+-------------+-----------+Table: lift_passengers
+----------------+-------------+
| COLUMN_NAME    | DATA_TYPE   |
+----------------+-------------+
| passenger_name | varchar(10) |
| weight_kg      | int         |
| lift_id        | int         |
+----------------+-------------+
*/


-- Write your SQL solution below:

```sql
WITH ranked_passengers AS (
  SELECT 
    lift_id,
    passenger_name,
    weight_kg,
    ROW_NUMBER() OVER (PARTITION BY lift_id ORDER BY weight_kg ASC) as rn
  FROM lift_passengers
),
cumulative_weight AS (
  SELECT 
    lift_id,
    passenger_name,
    weight_kg,
    rn,
    SUM(weight_kg) OVER (PARTITION BY lift_id ORDER BY rn ASC) as total_weight
  FROM ranked_passengers
),
filtered_passengers AS (
  SELECT 
    lift_id,
    passenger_name,
    weight_kg,
    rn
  FROM cumulative_weight c
  WHERE total_weight <= (SELECT capacity_kg FROM lifts WHERE id = c.lift_id)
)
SELECT 
  l.id,
  STRING_AGG(fp.passenger_name, ', ' ORDER BY fp.weight_kg ASC) as passengers
FROM lifts l
LEFT JOIN filtered_passengers fp ON l.id = fp.lift_id
GROUP BY l.id
ORDER BY l.id;
```
