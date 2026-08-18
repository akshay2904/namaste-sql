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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH user_stats AS (
    -- Count emails sent and received per user in a single pass using conditional aggregation
    SELECT
        u.user_id,
        COUNT(DISTINCT CASE WHEN g.from_user = u.user_id THEN g.email_day || g.to_user END) AS emails_sent,
        COUNT(DISTINCT CASE WHEN g.to_user   = u.user_id THEN g.email_day || g.from_user END) AS emails_received
    FROM (
        SELECT from_user AS user_id FROM gmail_data
        UNION
        SELECT to_user   AS user_id FROM gmail_data
    ) u
    JOIN gmail_data g
        ON g.from_user = u.user_id OR g.to_user = u.user_id
    GROUP BY u.user_id
),
response_rates AS (
    SELECT
        user_id,
        emails_sent,
        emails_received,
        -- Response rate as percentage: sent / received * 100
        ROUND(emails_sent::numeric / emails_received * 100, 2) AS response_rate,
        NTILE(4) OVER (ORDER BY ROUND(emails_sent::numeric / emails_received * 100, 2) DESC) AS quartile
    FROM user_stats
    WHERE emails_sent >= 1
      AND emails_received >= 1
)
SELECT
    user_id,
    emails_sent,
    emails_received,
    response_rate
FROM response_rates
WHERE quartile = 1
ORDER BY response_rate DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH sent_counts AS (
    -- Count emails sent per user
    SELECT
        from_user AS user_id,
        COUNT(*) AS emails_sent
    FROM gmail_data
    GROUP BY from_user
),
received_counts AS (
    -- Count emails received per user
    SELECT
        to_user AS user_id,
        COUNT(*) AS emails_received
    FROM gmail_data
    GROUP BY to_user
),
user_response_rates AS (
    -- Join sent and received, filter users with at least 1 sent and 1 received
    SELECT
        s.user_id,
        s.emails_sent,
        r.emails_received,
        ROUND(s.emails_sent::numeric / r.emails_received * 100, 2) AS response_rate
    FROM sent_counts s
    INNER JOIN received_counts r
        ON s.user_id = r.user_id
    WHERE s.emails_sent >= 1
      AND r.emails_received >= 1
),
threshold AS (
    -- Find the 75th percentile cutoff (top 25% have response_rate >= this value)
    SELECT
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY response_rate) AS percentile_75
    FROM user_response_rates
)
SELECT
    u.user_id,
    u.emails_sent,
    u.emails_received,
    u.response_rate
FROM user_response_rates u
CROSS JOIN threshold t
WHERE u.response_rate >= t.percentile_75
ORDER BY u.response_rate DESC;
