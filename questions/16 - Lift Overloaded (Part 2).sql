-- ======================================================================
-- 16 - Lift Overloaded (Part 2)
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Meta
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/16-lift-overloaded-part-2
-- ======================================================================

/*
You are given a table of list of lifts , their maximum capacity and people along with their weight and gender who wants to enter into it. You need to make sure maximum people enter into the lift without lift getting overloaded but you need to give preference to female passengers first.

For each lift find the comma separated list of people who can be accomodated. The comma separated list should have female first and then people in the order of their weight in increasing order, display the output in increasing order of id.

 
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
| gender         | varchar(1)  |
| lift_id        | int         |
+----------------+-------------+
*/


-- Write your SQL solution below:

```sql
WITH female_passengers AS (
  SELECT 
    lift_id,
    passenger_name,
    weight_kg,
    gender,
    ROW_NUMBER() OVER (PARTITION BY lift_id ORDER BY weight_kg ASC) as row_num
  FROM lift_passengers
  WHERE gender = 'F'
),
male_passengers AS (
  SELECT 
    lift_id,
    passenger_name,
    weight_kg,
    gender,
    ROW_NUMBER() OVER (PARTITION BY lift_id ORDER BY weight_kg ASC) as row_num
  FROM lift_passengers
  WHERE gender = 'M'
),
female_cumulative AS (
  SELECT 
    lift_id,
    passenger_name,
    weight_kg,
    SUM(weight_kg) OVER (PARTITION BY lift_id ORDER BY row_num) as cumulative_weight,
    row_num
  FROM female_passengers
),
female_selected AS (
  SELECT 
    lift_id,
    passenger_name,
    weight_kg,
    cumulative_weight
  FROM female_cumulative
  WHERE cumulative_weight <= (SELECT capacity_kg FROM lifts WHERE lifts.id = female_cumulative.lift_id)
),
remaining_capacity AS (
  SELECT 
    l.id as lift_id,
    l.capacity_kg - COALESCE(SUM(fs.weight_kg), 0) as available_capacity
  FROM lifts l
  LEFT JOIN female_selected fs ON l.id = fs.lift_id
  GROUP BY l.id, l.capacity_kg
),
male_cumulative AS (
  SELECT 
    mp.lift_id,
    mp.passenger_name,
    mp.weight_kg,
    SUM(mp.weight_kg) OVER (PARTITION BY mp.lift_id ORDER BY mp.row_num) as cumulative_weight,
    mp.row_num,
    rc.available_capacity
  FROM male_passengers mp
  JOIN remaining_capacity rc ON mp.lift_id = rc.lift_id
),
male_selected AS (
  SELECT 
    lift_id,
    passenger_name,
    weight_kg
  FROM male_cumulative
  WHERE cumulative_weight <= available_capacity
),
combined_passengers AS (
  SELECT 
    lift_id,
    passenger_name,
    weight_kg,
    'F' as gender,
    1 as gender_order
  FROM female_selected
  UNION ALL
  SELECT 
    lift_id,
    passenger_name,
    weight_kg,
    'M' as gender,
    2 as gender_order
  FROM male_selected
)
SELECT 
  l.id,
  STRING_AGG(cp.passenger_name, ', ' ORDER BY cp.gender_order, cp.weight_kg) as passengers
FROM lifts l
LEFT JOIN combined_passengers cp ON l.id = cp.lift_id
GROUP BY l.id
ORDER BY l.id;
```
