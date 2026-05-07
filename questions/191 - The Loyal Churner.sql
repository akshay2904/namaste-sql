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

```sql
WITH ordered_events AS (
  -- Order events by user and date
  SELECT 
    user_id,
    event_type,
    event_date,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_date) as event_seq
  FROM subscriptions
),
paired_events AS (
  -- Pair each cancel with the next subscribe (if it exists)
  SELECT 
    user_id,
    event_type,
    event_date,
    LEAD(event_type) OVER (PARTITION BY user_id ORDER BY event_date) as next_event_type,
    LEAD(event_date) OVER (PARTITION BY user_id ORDER BY event_date) as next_event_date
  FROM ordered_events
),
churn_events AS (
  -- Identify churns: cancels not followed by re-subscribe within 30 days
  SELECT 
    user_id,
    event_date as cancel_date,
    CASE 
      WHEN next_event_type IS NULL THEN TRUE
      WHEN next_event_type = 'subscribe' AND EXTRACT(DAY FROM next_event_date - event_date) > 30 THEN TRUE
      ELSE FALSE
    END as is_churned
  FROM paired_events
  WHERE event_type = 'cancel'
),
subscribe_cancel_pairs AS (
  -- Pair each subscribe with its next cancel to calculate days subscribed
  SELECT 
    user_id,
    event_type,
    event_date,
    LEAD(event_type) OVER (PARTITION BY user_id ORDER BY event_date) as next_event_type,
    LEAD(event_date) OVER (PARTITION BY user_id ORDER BY event_date) as next_event_date,
    EXTRACT(DAY FROM LEAD(event_date) OVER (PARTITION BY user_id ORDER BY event_date) - event_date) as days_subscribed
  FROM ordered_events
),
days_before_churn AS (
  -- Join subscribes with their cancel dates that resulted in churns
  SELECT 
    sc.user_id,
    sc.days_subscribed,
    ce.cancel_date
  FROM subscribe_cancel_pairs sc
  INNER JOIN churn_events ce 
    ON sc.user_id = ce.user_id 
    AND sc.next_event_date = ce.cancel_date
    AND ce.is_churned = TRUE
    AND sc.event_type = 'subscribe'
    AND sc.next_event_type = 'cancel'
),
user_churn_stats AS (
  SELECT 
    user_id,
    COUNT(*) as churn_count,
    ROUND(AVG(days_subscribed)::NUMERIC, 2) as avg_days_before_churn
  FROM days_before_churn
  GROUP BY user_id
  HAVING COUNT(*) >= 2
)
SELECT 
  user_id,
  churn_count,
  avg_days_before_churn
FROM user_churn_stats
ORDER BY user_id;
```
