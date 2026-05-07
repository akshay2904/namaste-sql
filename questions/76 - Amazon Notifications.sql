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

```sql
SELECT 
    n.notification_id,
    COALESCE(SUM(CASE WHEN p.product_id = n.product_id THEN 1 ELSE 0 END), 0) AS same_product_purchases,
    COALESCE(SUM(CASE WHEN p.product_id != n.product_id THEN 1 ELSE 0 END), 0) AS different_product_purchases
FROM notifications n
LEFT JOIN purchases p ON n.product_id = p.product_id
WHERE p.purchase_timestamp IS NULL
   OR p.purchase_timestamp > n.delivered_at
   AND p.purchase_timestamp <= LEAST(
       DATE_ADD(n.delivered_at, INTERVAL 2 HOUR),
       COALESCE((
           SELECT MIN(delivered_at) 
           FROM notifications n2 
           WHERE n2.delivered_at > n.delivered_at
       ), DATE_ADD(n.delivered_at, INTERVAL 2 HOUR))
   )
GROUP BY n.notification_id
ORDER BY n.notification_id ASC;
```

Wait, let me reconsider the logic. The join condition should not restrict to same product_id since we need to count all purchases within the timeframe for that user.

```sql
SELECT 
    n.notification_id,
    COALESCE(SUM(CASE WHEN p.product_id = n.product_id THEN 1 ELSE 0 END), 0) AS same_product_purchases,
    COALESCE(SUM(CASE WHEN p.product_id != n.product_id THEN 1 ELSE 0 END), 0) AS different_product_purchases
FROM notifications n
LEFT JOIN purchases p ON p.purchase_timestamp > n.delivered_at
    AND p.purchase_timestamp <= LEAST(
        DATE_ADD(n.delivered_at, INTERVAL 2 HOUR),
        COALESCE((
            SELECT MIN(delivered_at) 
            FROM notifications n2 
            WHERE n2.notification_id > n.notification_id
            LIMIT 1
        ), DATE_ADD(n.delivered_at, INTERVAL 2 HOUR))
    )
GROUP BY n.notification_id
ORDER BY n.notification_id ASC;
```

Actually, we need to consider next notification per user. Let me refine:

```sql
WITH next_notification AS (
    SELECT 
        n1.notification_id,
        MIN(n2.delivered_at) AS next_notification_time
    FROM notifications n1
    LEFT JOIN notifications n2 ON n2.delivered_at > n1.delivered_at
    GROUP BY n1.notification_id
)
SELECT 
    n.notification_id,
    COALESCE(SUM(CASE WHEN p.product_id = n.product_id THEN 1 ELSE 0 END), 0) AS same_product_purchases,
    COALESCE(SUM(CASE WHEN p.product_id != n.product_id THEN 1 ELSE 0 END), 0) AS different_product_purchases
FROM notifications n
LEFT JOIN next_notification nn ON n.notification_id = nn.notification_id
LEFT JOIN purchases p ON p.purchase_timestamp > n.delivered_at
    AND p.purchase_timestamp <= LEAST(
        DATE_ADD(n.delivered_at, INTERVAL 2 HOUR),
        COALESCE(nn.next_notification_time, DATE_ADD(n.delivered_at, INTERVAL 2 HOUR))
    )
GROUP BY n.notification_id
ORDER BY n.notification_id ASC;
```
