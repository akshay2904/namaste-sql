-- ======================================================================
-- The Company You Keep
-- ======================================================================
-- Difficulty : Medium
-- Company    : Walmart
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/friday_sessions_for_shared_experiments
-- ======================================================================

/*
On our experimentation platform we only care about users who share an experiment with at least one other user. For each Friday, count how many sessions those users ran, listed from the earliest date.

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Table: experiments(exp_id, exp_name, variant, user_id, outcome, created, platform)

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Sample data - experiments ['exp_id', 'exp_name', 'variant', 'user_id', 'outcome', 'created', 'platform']:
  [1053, 'checkout_v3', 'variant_a', 100, 11.3, '2026-02-02', 'android']
  [1106, 'onboard_flow', 'variant_b', 197, 22.6, '2026-03-03', 'web']
  [1159, 'pricing_tier', 'variant_c', 294, 33.9, '2026-04-04', 'iOS']
  [1212, 'search_rank', 'holdout', 391, 45.2, '2026-05-05', 'Android']
  [1265, 'rec_model_b', 'control', 488, 56.5, '2026-06-06', None]

Expected output ['session_date', 'total_sessions']:
  ['2023-01-13', 1]
  ['2023-05-05', 1]
  ['2023-09-01', 1]
  ['2024-04-26', 1]
  ['2025-11-07', 2]
*/


-- Write your SQL solution below:

WITH shared_experiments AS (
  SELECT DISTINCT e1.exp_name
  FROM experiments e1
  INNER JOIN experiments e2
    ON e1.exp_name = e2.exp_name
   AND e1.user_id <> e2.user_id
),
co_enrolled_users AS (
  SELECT DISTINCT e.user_id
  FROM experiments e
  INNER JOIN shared_experiments s
    ON e.exp_name = s.exp_name
)
SELECT date(us.session_start) AS session_date,
       COUNT(*) AS total_sessions
FROM user_sessions us
INNER JOIN co_enrolled_users cu
  ON us.user_id = cu.user_id
WHERE CAST(strftime('%w', us.session_start) AS INTEGER) = 5
GROUP BY date(us.session_start)
ORDER BY session_date
