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

```sql
WITH registration_cohorts AS (
  SELECT 
    user_id,
    registration_date,
    TO_CHAR(registration_date, 'YYYY-MM') AS registration_month
  FROM users
),
monthly_usage AS (
  SELECT 
    rc.user_id,
    rc.registration_date,
    rc.registration_month,
    SUM(ud.time_spent) AS total_time_spent,
    EXTRACT(YEAR FROM ud.usage_date) * 12 + EXTRACT(MONTH FROM ud.usage_date) AS usage_month,
    EXTRACT(YEAR FROM rc.registration_date) * 12 + EXTRACT(MONTH FROM rc.registration_date) AS registration_month_num
  FROM registration_cohorts rc
  LEFT JOIN usage_data ud ON rc.user_id = ud.user_id
  GROUP BY rc.user_id, rc.registration_date, rc.registration_month, usage_month
),
engagement_by_month AS (
  SELECT 
    user_id,
    registration_date,
    registration_month,
    (usage_month - registration_month_num) AS months_since_registration,
    CASE WHEN total_time_spent >= 30 THEN 1 ELSE 0 END AS is_engaged
  FROM monthly_usage
  WHERE usage_month IS NOT NULL
),
engaged_users AS (
  SELECT DISTINCT
    registration_month,
    user_id,
    MAX(CASE WHEN months_since_registration = 1 THEN is_engaged ELSE 0 END) AS m1_engaged,
    MAX(CASE WHEN months_since_registration = 2 THEN is_engaged ELSE 0 END) AS m2_engaged,
    MAX(CASE WHEN months_since_registration = 3 THEN is_engaged ELSE 0 END) AS m3_engaged
  FROM engagement_by_month
  GROUP BY registration_month, user_id
),
cohort_stats AS (
  SELECT 
    registration_month,
    COUNT(DISTINCT user_id) AS total_users,
    SUM(m1_engaged) AS m1_engaged_count,
    SUM(m2_engaged) AS m2_engaged_count,
    SUM(m3_engaged) AS m3_engaged_count
  FROM engaged_users
  GROUP BY registration_month
)
SELECT 
  registration_month,
  total_users,
  ROUND(100.0 * m1_engaged_count / total_users, 2) AS m1_retention,
  ROUND(100.0 * m2_engaged_count / total_users, 2) AS m2_retention,
  ROUND(100.0 * m3_engaged_count / total_users, 2) AS m3_retention
FROM cohort_stats
ORDER BY registration_month;
```
