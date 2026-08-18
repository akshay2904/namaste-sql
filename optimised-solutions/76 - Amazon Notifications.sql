-- ======================================================================
-- 76 - Amazon Notifications
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Amazon
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/76-amazon-notifications
-- ======================================================================

/*
Your task is to analyze the effectiveness of Amazon's notifications in driving user engagement and conversions, considering the user purchase data. A purchase is considered to be associated with a notification if the purchase happens within the timeframe of earliest of below 2 events:
1-  2 hours from notification delivered time
2-  Next notification delivered time.

Each notification is sent for a particular product id but a customer may purchase same or another product. Considering these rules write an SQL to find number of purchases associated with each notification for same product or a different product in 2 separate columns, display the output in ascending order of notification id.

 

Table:notifications
+-----------------+------------+
| COLUMN_NAME     | DATA_TYPE  |
+-----------------+------------+
| notification_id | int        |
| delivered_at    | datetime   |
| product_id      | varchar(2) |
+-----------------+------------+

Table:purchases 
+--------------------+------------+
| COLUMN_NAME        | DATA_TYPE  |
+--------------------+------------+
| product_id         | varchar(2) |
| purchase_timestamp | datetime   |
| user_id            | int        |
+--------------------+------------+
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH notification_windows AS (
    SELECT
        notification_id,
        product_id,
        delivered_at,
        -- Window end = min(delivered_at + 2 hours, next notification delivered_at)
        LEAST(
            delivered_at + INTERVAL '2 hours',
            COALESCE(
                LEAD(delivered_at) OVER (ORDER BY delivered_at, notification_id),
                delivered_at + INTERVAL '2 hours'  -- no next notification => use 2hr cap
            )
        ) AS window_end
    FROM notifications
),
purchase_matches AS (
    SELECT
        nw.notification_id,
        nw.product_id AS notif_product_id,
        p.product_id  AS purchase_product_id
    FROM notification_windows nw
    JOIN purchases p
        ON p.purchase_timestamp >= nw.delivered_at
       AND p.purchase_timestamp <  nw.window_end
)
SELECT
    notification_id,
    -- Purchases for the SAME product as the notification
    COUNT(CASE WHEN notif_product_id = purchase_product_id THEN 1 END) AS same_product_purchases,
    -- Purchases for a DIFFERENT product than the notification
    COUNT(CASE WHEN notif_product_id <> purchase_product_id THEN 1 END) AS different_product_purchases
FROM purchase_matches
GROUP BY notification_id
ORDER BY notification_id;


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    n.notification_id,
    -- Same product purchases within the notification window
    COUNT(
        CASE
            WHEN p.product_id = n.product_id THEN 1
        END
    ) AS same_product_purchases,
    -- Different product purchases within the notification window
    COUNT(
        CASE
            WHEN p.product_id <> n.product_id THEN 1
        END
    ) AS different_product_purchases
FROM notifications n
LEFT JOIN purchases p
    ON p.purchase_timestamp >= n.delivered_at
   AND p.purchase_timestamp < (
           -- Subquery: find min of (delivered_at + 2hr) and next notification time
           SELECT LEAST(
               n.delivered_at + INTERVAL '2 hours',
               COALESCE(
                   -- Next notification delivered after current one
                   (
                       SELECT MIN(n2.delivered_at)
                       FROM notifications n2
                       WHERE n2.delivered_at > n.delivered_at
                   ),
                   n.delivered_at + INTERVAL '2 hours'
               )
           )
       )
GROUP BY n.notification_id, n.product_id
ORDER BY n.notification_id;
