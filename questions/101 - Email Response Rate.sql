-- ======================================================================
-- 101 - Email Response Rate
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Google
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/101-email-response-rate
-- ======================================================================

/*
Given a sample table with emails sent vs. received by the users, calculate the response rate (%) which is given as emails sent/ emails received. For simplicity consider sent emails are delivered. List all the users that fall under the top 25 percent based on the highest response rate.
Please consider users who have sent at least one email and have received at least one email.

 
Table : gmail_data
+-------------+-------------+
| COLUMN_NAME | DATA_TYPE   |
+-------------+-------------+
| from_user   | varchar(20) |
| to_user     | varchar(20) |
| email_day   | date        |
+-------------+-------------+
*/


-- Write your SQL solution below:

```sql
WITH user_email_stats AS (
  -- Calculate emails sent and received for each user
  SELECT 
    user_id,
    COALESCE(sent, 0) as emails_sent,
    COALESCE(received, 0) as emails_received,
    ROUND(100.0 * COALESCE(sent, 0) / COALESCE(received, 0), 2) as response_rate
  FROM (
    SELECT 
      COALESCE(s.from_user, r.to_user) as user_id,
      s.sent_count as sent,
      r.received_count as received
    FROM (
      SELECT from_user, COUNT(*) as sent_count
      FROM gmail_data
      GROUP BY from_user
    ) s
    FULL OUTER JOIN (
      SELECT to_user, COUNT(*) as received_count
      FROM gmail_data
      GROUP BY to_user
    ) r ON s.from_user = r.to_user
  )
  WHERE COALESCE(sent, 0) > 0 AND COALESCE(received, 0) > 0
),
ranked_users AS (
  -- Calculate percentile rank for response rates
  SELECT 
    user_id,
    emails_sent,
    emails_received,
    response_rate,
    PERCENT_RANK() OVER (ORDER BY response_rate ASC) as percentile_rank
  FROM user_email_stats
)
SELECT 
  user_id,
  emails_sent,
  emails_received,
  response_rate
FROM ranked_users
WHERE percentile_rank >= 0.75
ORDER BY response_rate DESC;
```
