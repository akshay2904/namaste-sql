-- ======================================================================
-- 191 - The Loyal Churner
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Netflix
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/191-the-loyal-churner
-- ======================================================================

/*
You work at a subscription-based OTT platform (think Netflix-style). The platform tracks when users start and canceltheir subscriptions. A user can re-subscribe multiple times.

A user is considered "churned" if they cancelled and did not re-subscribe within 30 days.

 

Find all users who have churned at least twice — meaning they cancelled, came back, and churned again. For each such user, return:

user_id

churn_count — how many times they have churned

avg_days_before_churn — average number of days they stayed subscribed before each churn event (round 2 decimal places)

Constraints & Traps:

A single user can have multiple subscribe/cancel cycles

If a cancel is followed by a re-subscribe within 30 days, it does NOT count as a churn

Days subscribed = days between a subscribe event and its paired cancel event

Events are not guaranteed to be ordered in the table

 
Table: subscriptions
+------------+-----------+
| COLUMN_NAME| DATA_TYPE |
+------------+-----------+
| user_id    | INT       |
| event_type | VARCHAR   |
| event_date | DATE      |
+------------+-----------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ordered_events AS (
    -- Assign row numbers to order events per user chronologically
    SELECT
        user_id,
        event_type,
        event_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_date, event_type DESC) AS rn
        -- event_type DESC: 'subscribe' before 'cancel' if same date (s > c alphabetically? No)
        -- Actually 'subscribe' > 'cancel' alphabetically, so DESC puts subscribe first
    FROM subscriptions
),

subscribe_events AS (
    -- Get each subscribe event with the next subscribe date (for pairing logic)
    SELECT
        user_id,
        event_date AS subscribe_date,
        rn,
        -- Next subscribe date for this user (to find cancel events in between)
        LEAD(event_date) OVER (PARTITION BY user_id ORDER BY rn) AS next_event_date,
        LEAD(event_type) OVER (PARTITION BY user_id ORDER BY rn) AS next_event_type
    FROM ordered_events
    WHERE event_type = 'subscribe'
),

cancel_events AS (
    SELECT
        user_id,
        event_date AS cancel_date,
        rn
    FROM ordered_events
    WHERE event_type = 'cancel'
),

-- Pair each subscribe with its immediate following cancel
paired_cycles AS (
    SELECT
        s.user_id,
        s.subscribe_date,
        c.cancel_date,
        -- Days subscribed in this cycle
        (c.cancel_date - s.subscribe_date) AS days_subscribed,
        -- Find the next subscribe date after this cancel
        MIN(s2.subscribe_date) FILTER (WHERE s2.subscribe_date > c.cancel_date)
            OVER (PARTITION BY s.user_id ORDER BY c.cancel_date
                  ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS next_subscribe_date
    FROM subscribe_events s
    JOIN cancel_events c
        ON s.user_id = c.user_id
        -- The cancel must come after this subscribe
        AND c.cancel_date > s.subscribe_date
        -- No other subscribe between this subscribe and the cancel
        AND NOT EXISTS (
            SELECT 1 FROM subscribe_events s2
            WHERE s2.user_id = s.user_id
              AND s2.subscribe_date > s.subscribe_date
              AND s2.subscribe_date < c.cancel_date
        )
        -- No other cancel between this subscribe and the paired cancel
        AND NOT EXISTS (
            SELECT 1 FROM cancel_events c2
            WHERE c2.user_id = c.user_id
              AND c2.cancel_date > s.subscribe_date
              AND c2.cancel_date < c.cancel_date
        )
),

-- Determine if each cycle ended in a churn (no re-subscribe within 30 days)
churn_flags AS (
    SELECT
        p.user_id,
        p.subscribe_date,
        p.cancel_date,
        p.days_subscribed,
        -- Next subscribe date after this cancel
        MIN(s.subscribe_date) AS next_subscribe_date
    FROM paired_cycles p
    LEFT JOIN subscribe_events s
        ON s.user_id = p.user_id
        AND s.subscribe_date > p.cancel_date
    GROUP BY p.user_id, p.subscribe_date, p.cancel_date, p.days_subscribed
),

churn_details AS (
    SELECT
        user_id,
        subscribe_date,
        cancel_date,
        days_subscribed,
        -- Churn = no re-subscribe within 30 days of cancel
        CASE
            WHEN next_subscribe_date IS NULL
              OR (next_subscribe_date - cancel_date) > 30
            THEN 1
            ELSE 0
        END AS is_churn
    FROM churn_flags
),

user_churn_summary AS (
    SELECT
        user_id,
        SUM(is_churn) AS churn_count,
        ROUND(AVG(CASE WHEN is_churn = 1 THEN days_subscribed END), 2) AS avg_days_before_churn
    FROM churn_details
    GROUP BY user_id
)

SELECT
    user_id,
    churn_count,
    avg_days_before_churn
FROM user_churn_summary
WHERE churn_count >= 2
ORDER BY user_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Step 1: Pair each subscribe with its next cancel (brute force via self-join)
-- Step 2: Find next subscribe after each cancel to assess churn
-- Step 3: Filter users with >= 2 churns

WITH sub_events AS (
    SELECT user_id, event_date AS sub_date
    FROM subscriptions
    WHERE event_type = 'subscribe'
),

can_events AS (
    SELECT user_id, event_date AS can_date
    FROM subscriptions
    WHERE event_type = 'cancel'
),

-- For each subscribe, find the EARLIEST cancel that comes after it
-- with no other subscribe in between (immediate next cancel)
paired AS (
    SELECT
        s.user_id,
        s.sub_date,
        -- Earliest cancel after this subscribe
        MIN(c.can_date) AS can_date
    FROM sub_events s
    JOIN can_events c
        ON s.user_id = c.user_id
        AND c.can_date > s.sub_date
        -- No subscribe between this subscribe and the cancel
        AND NOT EXISTS (
            SELECT 1 FROM sub_events s2
            WHERE s2.user_id = s.user_id
              AND s2.sub_date > s.sub_date
              AND s2.sub_date < c.can_date
        )
    GROUP BY s.user_id, s.sub_date
),

-- For each cancel, find the next subscribe (if any)
paired_with_next_sub AS (
    SELECT
        p.user_id,
        p.sub_date,
        p.can_date,
        (p.can_date - p.sub_date) AS days_subscribed,
        -- Earliest re-subscribe after this cancel
        (
            SELECT MIN(s2.sub_date)
            FROM sub_events s2
            WHERE s2.user_id = p.user_id
              AND s2.sub_date > p.can_date
        ) AS next_sub_date
    FROM paired p
),

-- Mark each cycle as churn or not
churn_cycles AS (
    SELECT
        user_id,
        sub_date,
        can_date,
        days_subscribed,
        CASE
            WHEN next_sub_date IS NULL OR (next_sub_date - can_date) > 30
            THEN 1
            ELSE 0
        END AS is_churn
    FROM paired_with_next_sub
),

-- Aggregate per user
user_summary AS (
    SELECT
        user_id,
        SUM(is_churn) AS churn_count,
        ROUND(
            SUM(CASE WHEN is_churn = 1 THEN days_subscribed ELSE 0 END) * 1.0
            / NULLIF(SUM(is_churn), 0),
            2
        ) AS avg_days_before_churn
    FROM churn_cycles
    GROUP BY user_id
    HAVING SUM(is_churn) >= 2
)

SELECT
    user_id,
    churn_count,
    avg_days_before_churn
FROM user_summary
ORDER BY user_id;
