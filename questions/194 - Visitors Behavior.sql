-- ======================================================================
-- 194 - Visitors Behavior
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Hackerrank
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/194-visitors-behavior
-- ======================================================================

/*
You are working on developing visitor tracking software and need to get a list of events by quarter in 2021.

 

The result should have the following columns: period , events.

 

period - quarter in 2021 when the event occurred:
Record format is Q##'##, where the placeholders are ## in the order they appear:
Quarter number
The last two digits of the year

 

events - list of event records for a specific quarter of 2021:
Record format is ##=##, where the placeholders are ## in the order they appear:
Event type
Total number of events of this type
Records are separated by semicolon and space

Records are sorted in descending order by the total number of events of this type, and then in ascending order by their type
 

The result should be sorted in ascending order by period.
Table: events
+------------+-------------+
| COLUMN_NAME| DATA_TYPE   |
+------------+-------------+
| dt         | VARCHAR(19) |
| type       | VARCHAR(5) |
+------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
  CONCAT('Q', QUARTER(STR_TO_DATE(dt, '%Y-%m-%d %H:%i:%s')), '''', RIGHT(YEAR(STR_TO_DATE(dt, '%Y-%m-%d %H:%i:%s')), 2)) AS period,
  GROUP_CONCAT(
    CONCAT(type, '=', event_count) 
    ORDER BY event_count DESC, type ASC
    SEPARATOR '; '
  ) AS events
FROM (
  SELECT 
    dt,
    type,
    COUNT(*) AS event_count
  FROM events
  WHERE YEAR(STR_TO_DATE(dt, '%Y-%m-%d %H:%i:%s')) = 2021
  GROUP BY QUARTER(STR_TO_DATE(dt, '%Y-%m-%d %H:%i:%s')), type
) subquery
GROUP BY 
  QUARTER(STR_TO_DATE(dt, '%Y-%m-%d %H:%i:%s')),
  YEAR(STR_TO_DATE(dt, '%Y-%m-%d %H:%i:%s'))
ORDER BY period ASC;
```
