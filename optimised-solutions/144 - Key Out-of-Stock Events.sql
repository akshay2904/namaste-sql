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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_events AS (
    -- Assign row numbers to order events per (MASTER_ID, MARKETPLACE_ID)
    SELECT
        MASTER_ID,
        MARKETPLACE_ID,
        OOS_DATE,
        ROW_NUMBER() OVER (PARTITION BY MASTER_ID, MARKETPLACE_ID ORDER BY OOS_DATE) AS rn
    FROM DETAILED_OOS_EVENTS
),
recursive_chain AS (
    -- Anchor: pick the earliest OOS event for each (MASTER_ID, MARKETPLACE_ID)
    SELECT
        MASTER_ID,
        MARKETPLACE_ID,
        OOS_DATE,
        rn
    FROM ranked_events
    WHERE rn = 1

    UNION ALL

    -- Recursive step: find the next eligible event >= 7 days after current
    SELECT
        r.MASTER_ID,
        r.MARKETPLACE_ID,
        r.OOS_DATE,
        r.rn
    FROM recursive_chain rc
    JOIN ranked_events r
        ON  r.MASTER_ID        = rc.MASTER_ID
        AND r.MARKETPLACE_ID   = rc.MARKETPLACE_ID
        AND r.OOS_DATE        >= rc.OOS_DATE + INTERVAL '7 days'
        -- Among all qualifying rows, pick only the immediately next one
        AND r.rn = (
            SELECT MIN(r2.rn)
            FROM ranked_events r2
            WHERE r2.MASTER_ID       = rc.MASTER_ID
              AND r2.MARKETPLACE_ID  = rc.MARKETPLACE_ID
              AND r2.OOS_DATE       >= rc.OOS_DATE + INTERVAL '7 days'
        )
)
SELECT
    MASTER_ID,
    MARKETPLACE_ID,
    OOS_DATE
FROM recursive_chain
ORDER BY MASTER_ID, MARKETPLACE_ID, OOS_DATE;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH RECURSIVE base_events AS (
    -- Get all events ordered; we'll walk through them iteratively
    SELECT
        MASTER_ID,
        MARKETPLACE_ID,
        OOS_DATE
    FROM DETAILED_OOS_EVENTS
),
anchor AS (
    -- Anchor: the earliest OOS date per (MASTER_ID, MARKETPLACE_ID)
    SELECT
        b.MASTER_ID,
        b.MARKETPLACE_ID,
        b.OOS_DATE
    FROM base_events b
    WHERE b.OOS_DATE = (
        SELECT MIN(b2.OOS_DATE)
        FROM base_events b2
        WHERE b2.MASTER_ID       = b.MASTER_ID
          AND b2.MARKETPLACE_ID  = b.MARKETPLACE_ID
    )
    -- Deduplicate in case of ties (though problem states uniqueness of the triple)
    GROUP BY b.MASTER_ID, b.MARKETPLACE_ID, b.OOS_DATE

    UNION ALL

    -- Recursive step: find the minimum OOS_DATE that is >= 7 days after current
    SELECT
        a.MASTER_ID,
        a.MARKETPLACE_ID,
        next_event.next_date AS OOS_DATE
    FROM anchor a
    JOIN (
        -- Subquery to find the next qualifying date for each (MASTER_ID, MARKETPLACE_ID, current date)
        SELECT
            e.MASTER_ID,
            e.MARKETPLACE_ID,
            -- We'll join on the previous anchor date in the outer query
            e.OOS_DATE                          AS next_date,
            MIN(e.OOS_DATE) OVER ()             AS dummy  -- placeholder; real filter in JOIN
        FROM base_events e
    ) next_event
        ON  next_event.MASTER_ID       = a.MASTER_ID
        AND next_event.MARKETPLACE_ID  = a.MARKETPLACE_ID
        AND next_event.next_date = (
            -- Subquery: find the single minimum date >= current + 7 days
            SELECT MIN(e2.OOS_DATE)
            FROM base_events e2
            WHERE e2.MASTER_ID       = a.MASTER_ID
              AND e2.MARKETPLACE_ID  = a.MARKETPLACE_ID
              AND e2.OOS_DATE       >= a.OOS_DATE + INTERVAL '7 days'
        )
        AND next_event.next_date IS NOT NULL
)
SELECT
    MASTER_ID,
    MARKETPLACE_ID,
    OOS_DATE
FROM anchor
ORDER BY MASTER_ID, MARKETPLACE_ID, OOS_DATE;
