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

```sql
SELECT DISTINCT
    h1.id AS startpt,
    h2.id AS middlept,
    h3.id AS endpt
FROM mountain_huts h1
JOIN trails t1 ON (h1.id = t1.hut1 OR h1.id = t1.hut2)
JOIN mountain_huts h2 ON (h2.id = t1.hut1 OR g2.id = t1.hut2) AND h2.id != h1.id
JOIN trails t2 ON (h2.id = t2.hut1 OR h2.id = t2.hut2)
JOIN mountain_huts h3 ON (h3.id = t2.hut1 OR h3.id = t2.hut2) AND h3.id != h2.id AND h3.id != h1.id
WHERE h1.altitude > h2.altitude AND h2.altitude > h3.altitude
ORDER BY startpt, middlept, endpt;
```

Wait, let me correct that - there was a typo in my join condition:

```sql
SELECT DISTINCT
    h1.id AS startpt,
    h2.id AS middlept,
    h3.id AS endpt
FROM mountain_huts h1
JOIN trails t1 ON (h1.id = t1.hut1 OR h1.id = t1.hut2)
JOIN mountain_huts h2 ON (h2.id = t1.hut1 OR h2.id = t1.hut2) AND h2.id != h1.id
JOIN trails t2 ON (h2.id = t2.hut1 OR h2.id = t2.hut2)
JOIN mountain_huts h3 ON (h3.id = t2.hut1 OR h3.id = t2.hut2) AND h3.id != h2.id AND h3.id != h1.id
WHERE h1.altitude > h2.altitude AND h2.altitude > h3.altitude
ORDER BY startpt, middlept, endpt;
```
