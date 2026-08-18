-- ======================================================================
-- 162 -  Ski Slope
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Pwc
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/162-ski-slope
-- ======================================================================

/*
A ski resort company is planning to construct a new ski slope using a pre-existing network of mountain huts and trails between them. 

 

A new slope has to begin at one of the mountain huts, have a middle station at another hut connected with the first one by a direct trail, and end
at the third mountain hut which is also connected by a direct trail to the second hut.

The altitude of the three huts chosen for constructing the ski slope has to be strictly decreasing.

You are given two SQL tables, mountain_huts and trails , with the following structure:
 
Table: mountain_huts
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| id		  | INTEGER  |
| name	      | VARCHAR  |
| altitude    | INTEGER  |
+-------------+----------+

Table: trails 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| hutl        | INTEGER  |
| hut2        | INTEGER  |
+-------------+----------+
Each entry in the table trails represents a direct connection between huts with IDs hut1 and hut2.

Note that all trails are bidirectional.

 

Write a query that finds all triplets (startpt, middlept, endpt ) representing the mountain huts that may be used for the construction of a ski slope.  Sort the output by  startpt, middlept, endpt .
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH bidirectional_trails AS (
    -- Expand trails to include both directions
    SELECT hut1 AS from_hut, hut2 AS to_hut FROM trails
    UNION
    SELECT hut2 AS from_hut, hut1 AS to_hut FROM trails
)
SELECT
    h1.name AS startpt,
    h2.name AS middlept,
    h3.name AS endpt
FROM bidirectional_trails t1
JOIN bidirectional_trails t2
    ON t1.to_hut = t2.from_hut
    AND t1.from_hut <> t2.to_hut  -- avoid going back to start
JOIN mountain_huts h1 ON h1.id = t1.from_hut
JOIN mountain_huts h2 ON h2.id = t1.to_hut
JOIN mountain_huts h3 ON h3.id = t2.to_hut
WHERE h1.altitude > h2.altitude
  AND h2.altitude > h3.altitude
ORDER BY startpt, middlept, endpt;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    h1.name AS startpt,
    h2.name AS middlept,
    h3.name AS endpt
FROM mountain_huts h1
JOIN mountain_huts h2 ON h1.altitude > h2.altitude
JOIN mountain_huts h3 ON h2.altitude > h3.altitude
WHERE h1.id <> h2.id
  AND h2.id <> h3.id
  AND h1.id <> h3.id
  -- Check trail exists between h1 and h2 (bidirectional)
  AND (
      EXISTS (SELECT 1 FROM trails WHERE hut1 = h1.id AND hut2 = h2.id)
      OR EXISTS (SELECT 1 FROM trails WHERE hut1 = h2.id AND hut2 = h1.id)
  )
  -- Check trail exists between h2 and h3 (bidirectional)
  AND (
      EXISTS (SELECT 1 FROM trails WHERE hut1 = h2.id AND hut2 = h3.id)
      OR EXISTS (SELECT 1 FROM trails WHERE hut1 = h3.id AND hut2 = h2.id)
  )
ORDER BY startpt, middlept, endpt;
