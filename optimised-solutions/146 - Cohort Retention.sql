-- ======================================================================
-- 146 - Cohort Retention
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Khan academy
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/146-cohort-retention
-- ======================================================================

/*
Khan Academy capture data on how users are using their product, with the schemas below. Using this data they would like to report on monthly “engaged” retention rates. Monthly “engaged” retention is defined here as the % of users from each registration cohort that continued to use the product as an “engaged” user having met the threshold of >= 30 minutes per month. They are looking for the retention metric calculated for within 1-3 calendar months post registration.

 
Table: users
+-------------------+----------+
| COLUMN_NAME       | DATA_TYPE|
+-------------------+----------+
| user_id           | VARCHAR  |
| registration_date | DATE     | 
+-------------+----------------+Table: usage_data 
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| user_id     | VARCHAR  |
| usage_date  | DATE     | 
| location    | VARCHAR  | 
| time_spent  | INTEGER  | 
+-------------+----------+
 

Write a SQL query whose output is in the following format using the input tables in the editor:

 | registration_month  | total_users     | m1_retention    | m2_retention  | m3_retention

 | 2019-01 | 3 | 66.67  | 33.33 | 33.33

 | 2019-02 | 2 | 100.00 | 0.00 | 50.00

 

Explanation:
user aaa used the product 2 times within the first month (2019-01-03, 2019-02-01), 0 times in the 2nd month, and 1 time in the 3rd month (2019-03-04), post the user aaa’s initial registration (2019-01-03). User bbb used the product once in 1st month (2019-01-03) and once in 2nd month (2019-02-04) post registration (2019-01-02), but the 1st month usage is <30 minutes so the user doesn’t count in the m1_retention metric. Note that we want to calculate this usage metric as across all geographies.  Round the result to 2 decimal places.

Also note that m1 time period is exact one month from registration date not just the month of registration. Similarly m2 and m3.
*/


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH user_cohorts AS (
    -- Extract registration month and month boundaries for each user
    SELECT
        user_id,
        DATE_TRUNC('month', registration_date) AS registration_month,
        registration_date,
        -- Define calendar month windows for m1, m2, m3 post registration
        DATE_TRUNC('month', registration_date + INTERVAL '1 month')  AS m1_start,
        DATE_TRUNC('month', registration_date + INTERVAL '2 months') AS m2_start,
        DATE_TRUNC('month', registration_date + INTERVAL '3 months') AS m3_start
    FROM users
),
monthly_usage AS (
    -- Aggregate time spent per user per calendar month
    SELECT
        user_id,
        DATE_TRUNC('month', usage_date) AS usage_month,
        SUM(time_spent) AS total_time
    FROM usage_data
    GROUP BY user_id, DATE_TRUNC('month', usage_date)
),
user_engagement AS (
    -- Join cohort info with monthly usage to determine engagement per period
    SELECT
        uc.user_id,
        uc.registration_month,
        -- m1: calendar month that starts 1 month after registration month
        MAX(CASE WHEN mu.usage_month = uc.m1_start AND mu.total_time >= 30 THEN 1 ELSE 0 END) AS engaged_m1,
        MAX(CASE WHEN mu.usage_month = uc.m2_start AND mu.total_time >= 30 THEN 1 ELSE 0 END) AS engaged_m2,
        MAX(CASE WHEN mu.usage_month = uc.m3_start AND mu.total_time >= 30 THEN 1 ELSE 0 END) AS engaged_m3
    FROM user_cohorts uc
    LEFT JOIN monthly_usage mu ON uc.user_id = mu.user_id
    GROUP BY uc.user_id, uc.registration_month
)
SELECT
    TO_CHAR(registration_month, 'YYYY-MM') AS registration_month,
    COUNT(user_id)                          AS total_users,
    ROUND(100.0 * SUM(engaged_m1) / COUNT(user_id), 2) AS m1_retention,
    ROUND(100.0 * SUM(engaged_m2) / COUNT(user_id), 2) AS m2_retention,
    ROUND(100.0 * SUM(engaged_m3) / COUNT(user_id), 2) AS m3_retention
FROM user_engagement
GROUP BY registration_month
ORDER BY registration_month;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    TO_CHAR(DATE_TRUNC('month', u.registration_date), 'YYYY-MM') AS registration_month,
    COUNT(DISTINCT u.user_id) AS total_users,

    -- M1 retention: % of cohort users who spent >= 30 min in the calendar month
    -- that is exactly 1 month after their registration month
    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN EXISTS (
                SELECT 1
                FROM usage_data ud
                WHERE ud.user_id = u.user_id
                  AND DATE_TRUNC('month', ud.usage_date) =
                      DATE_TRUNC('month', u.registration_date + INTERVAL '1 month')
                GROUP BY ud.user_id
                HAVING SUM(ud.time_spent) >= 30
            ) THEN u.user_id
        END) / COUNT(DISTINCT u.user_id),
    2) AS m1_retention,

    -- M2 retention: 2 months after registration month
    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN EXISTS (
                SELECT 1
                FROM usage_data ud
                WHERE ud.user_id = u.user_id
                  AND DATE_TRUNC('month', ud.usage_date) =
                      DATE_TRUNC('month', u.registration_date + INTERVAL '2 months')
                GROUP BY ud.user_id
                HAVING SUM(ud.time_spent) >= 30
            ) THEN u.user_id
        END) / COUNT(DISTINCT u.user_id),
    2) AS m2_retention,

    -- M3 retention: 3 months after registration month
    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN EXISTS (
                SELECT 1
                FROM usage_data ud
                WHERE ud.user_id = u.user_id
                  AND DATE_TRUNC('month', ud.usage_date) =
                      DATE_TRUNC('month', u.registration_date + INTERVAL '3 months')
                GROUP BY ud.user_id
                HAVING SUM(ud.time_spent) >= 30
            ) THEN u.user_id
        END) / COUNT(DISTINCT u.user_id),
    2) AS m3_retention

FROM users u
GROUP BY DATE_TRUNC('month', u.registration_date)
ORDER BY registration_month;
