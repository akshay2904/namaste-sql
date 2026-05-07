-- ======================================================================
-- 63 - Prime Subscription
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/63-prime-subscription
-- ======================================================================

/*
Amazon, the world's largest online retailer, offers various services to its customers, including Amazon Prime membership, Video streaming, Amazon Music, Amazon Pay, and more. The company is interested in analyzing which of its services are most effective at converting regular customers into Amazon Prime members.
You are given a table of events which consists services accessed by each users along with service access date. This table also contains the event when customer bought the prime membership (type='prime').

 

Write an SQL to get date when each customer became prime member, last service used and last service access date (just before becoming prime member). If a customer never became prime member, then populate only the last service used and last service access date by the customer, display the output in ascending order of last service access date.

 
Table: users
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| name        | varchar(15) |
| user_id     | int         |
+-------------+-------------+Table : events
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| user_id     | int         |
| type        | varchar(15) |
| access_date | date        |
+-------------+-------------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    u.user_id,
    u.name,
    MAX(CASE WHEN e.type = 'prime' THEN e.access_date END) AS prime_member_date,
    MAX(CASE WHEN e.type != 'prime' THEN e.type END) 
        OVER (PARTITION BY u.user_id ORDER BY e.access_date DESC ROWS BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING) AS last_service_used,
    MAX(CASE WHEN e.type != 'prime' THEN e.access_date END) 
        OVER (PARTITION BY u.user_id ORDER BY e.access_date DESC ROWS BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING) AS last_service_access_date
FROM users u
LEFT JOIN events e ON u.user_id = e.user_id
GROUP BY u.user_id, u.name
ORDER BY last_service_access_date ASC;
```

Wait, let me reconsider. The requirement is to get the last service used BEFORE becoming prime member (if they became prime). Here's the corrected solution:

```sql
WITH ranked_events AS (
    SELECT 
        user_id,
        type,
        access_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY access_date DESC) AS rn
    FROM events
),
prime_dates AS (
    SELECT 
        user_id,
        access_date AS prime_member_date
    FROM events
    WHERE type = 'prime'
),
last_before_prime AS (
    SELECT 
        e.user_id,
        e.type AS last_service_used,
        e.access_date AS last_service_access_date
    FROM events e
    LEFT JOIN prime_dates p ON e.user_id = p.user_id
    WHERE e.type != 'prime'
        AND (p.prime_member_date IS NULL OR e.access_date < p.prime_member_date)
    QUALIFY ROW_NUMBER() OVER (PARTITION BY e.user_id ORDER BY e.access_date DESC) = 1
)
SELECT 
    u.user_id,
    u.name,
    p.prime_member_date,
    lbp.last_service_used,
    lbp.last_service_access_date
FROM users u
LEFT JOIN prime_dates p ON u.user_id = p.user_id
LEFT JOIN last_before_prime lbp ON u.user_id = lbp.user_id
ORDER BY lbp.last_service_access_date ASC;
```
