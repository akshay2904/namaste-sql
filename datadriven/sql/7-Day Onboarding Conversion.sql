-- ======================================================================
-- 7-Day Onboarding Conversion
-- ======================================================================
-- Difficulty : Hard
-- Company    : General Assembly
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/7_day_onboarding_conversion
-- ======================================================================

/*
The growth team is evaluating early onboarding for a board review. For users who entered an experiment during the first 7 days of January 2026, determine what percentage completed at least one meaningful session (duration greater than zero) within 7 days of entering the experiment. Break the results down by platform and experiment entry date, showing total users, converted users, and the conversion percentage.

Table: experiments(exp_id, exp_name, variant, user_id, outcome, created, platform)

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Sample data - experiments ['exp_id', 'exp_name', 'variant', 'user_id', 'outcome', 'created', 'platform']:
  [1053, 'checkout_v3', 'variant_a', 100, 11.3, '2026-02-02', 'android']
  [1106, 'onboard_flow', 'variant_b', 197, 22.6, '2026-03-03', 'web']
  [1159, 'pricing_tier', 'variant_c', 294, 33.9, '2026-04-04', 'iOS']
  [1212, 'search_rank', 'holdout', 391, 45.2, '2026-05-05', 'Android']
  [1265, 'rec_model_b', 'control', 488, 56.5, '2026-06-06', None]

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Expected output ['platform', 'signup_date', 'total_users', 'converted_users', 'conversion_rate']:
  [None, '2026-01-02', 1, 0, 0]
  ['Android', '2026-01-01', 1, 0, 0]
  ['Android', '2026-01-05', 1, 0, 0]
*/


-- Write your SQL solution below:

WITH signups AS (
    SELECT user_id, platform, DATE(created) AS signup_date
    FROM experiments
    WHERE DATE(created) BETWEEN '2026-01-01' AND '2026-01-07'
),
engagement AS (
    SELECT
        s.platform,
        s.signup_date,
        s.user_id,
        CASE
            WHEN COUNT(CASE WHEN us.session_duration_sec > 0 THEN 1 END) > 0
            THEN 1 ELSE 0
        END AS converted
    FROM signups s
    LEFT JOIN user_sessions us
        ON s.user_id = us.user_id
       AND julianday(us.session_start) - julianday(s.signup_date) BETWEEN 0 AND 7
    GROUP BY s.platform, s.signup_date, s.user_id
)
SELECT
    platform,
    signup_date,
    COUNT(*) AS total_users,
    SUM(converted) AS converted_users,
    CAST(SUM(converted) AS REAL) / CAST(COUNT(*) AS REAL) * 100 AS conversion_rate
FROM engagement
GROUP BY platform, signup_date
ORDER BY platform, signup_date
