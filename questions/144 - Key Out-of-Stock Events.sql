-- ======================================================================
-- 144 - Key Out-of-Stock Events
-- ======================================================================
-- Difficulty : Extreme Hard
-- Category   : Analytics
-- Companies  : Pattern
-- Access     : Free
-- URL        : https://www.namastesql.com/coding-problems/144-key-out-of-stock-events
-- ======================================================================

/*
You are working with a large dataset of out-of-stock (OOS) events for products across multiple marketplaces.Each record in the dataset represents an OOS event for a specific product (MASTER_ID) in a specific marketplace (MARKETPLACE_ID) on a specific date (OOS_DATE). The combination of (MASTER_ID, MARKETPLACE_ID, OOS_DATE) is always unique. Your task is to identify key OOS event dates for each product and marketplace combination.

 

Steps to identify key OOS events :
Identify the earliest OOS event for each (MASTER_ID, MARKETPLACE_ID).
Recursively find the next OOS event that occurs at least 7 days after the previous event.
Continue this process until no more OOS events meet the condition.

 
Table: DETAILED_OOS_EVENTS
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| MASTER_ID     | VARCHAR  |
| MARKETPLACE_ID| INTEGER  | 
| OOS_DATE      | DATE     | 
+---------------+----------+
Order the result by MASTER_ID, MARKETPLACE_ID, OOS_DATE
*/


-- Write your SQL solution below:

```sql
WITH RECURSIVE key_oos_events AS (
  -- Base case: Find the earliest OOS event for each (MASTER_ID, MARKETPLACE_ID)
  SELECT 
    MASTER_ID,
    MARKETPLACE_ID,
    OOS_DATE,
    ROW_NUMBER() OVER (PARTITION BY MASTER_ID, MARKETPLACE_ID ORDER BY OOS_DATE) as event_rank
  FROM DETAILED_OOS_EVENTS
  
  UNION ALL
  
  -- Recursive case: Find next OOS event at least 7 days after the previous one
  SELECT 
    doe.MASTER_ID,
    doe.MARKETPLACE_ID,
    doe.OOS_DATE,
    koe.event_rank + 1
  FROM DETAILED_OOS_EVENTS doe
  INNER JOIN key_oos_events koe 
    ON doe.MASTER_ID = koe.MASTER_ID
    AND doe.MARKETPLACE_ID = koe.MARKETPLACE_ID
    AND doe.OOS_DATE > koe.OOS_DATE
    AND doe.OOS_DATE >= koe.OOS_DATE + INTERVAL 7 DAY
  WHERE koe.event_rank = (
    -- Only join with the most recent key event to avoid duplicate paths
    SELECT MAX(event_rank)
    FROM key_oos_events koe2
    WHERE koe2.MASTER_ID = koe.MASTER_ID
    AND koe2.MARKETPLACE_ID = koe.MARKETPLACE_ID
  )
)
SELECT DISTINCT
  MASTER_ID,
  MARKETPLACE_ID,
  OOS_DATE
FROM key_oos_events
ORDER BY MASTER_ID, MARKETPLACE_ID, OOS_DATE;
```
