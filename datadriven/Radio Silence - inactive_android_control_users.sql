-- ======================================================================
-- Radio Silence
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/inactive_android_control_users
-- ======================================================================

/*
Our mobile A/B tests keep a control group that runs on Android, and we're checking which of those users have gone quiet. For each one whose account is no longer active, return their age bracket alongside the platform and variant, oldest experiment assignment first.

Table: experiments(exp_id, exp_name, variant, user_id, outcome, created, platform)

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - experiments ['exp_id', 'exp_name', 'variant', 'user_id', 'outcome', 'created', 'platform']:
  [1053, 'checkout_v3', 'variant_a', 100, 11.3, '2026-02-02', 'android']
  [1106, 'onboard_flow', 'variant_b', 197, 22.6, '2026-03-03', 'web']
  [1159, 'pricing_tier', 'variant_c', 294, 33.9, '2026-04-04', 'iOS']
  [1212, 'search_rank', 'holdout', 391, 45.2, '2026-05-05', 'Android']
  [1265, 'rec_model_b', 'control', 488, 56.5, '2026-06-06', None]

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['user_id', 'age_bucket', 'platform', 'variant']:
  [2428, '55-64', 'android', 'control']
  [2428, '55-64', 'android', 'control']
  [6308, '35-44', 'android', 'control']
  [6308, '35-44', 'android', 'control']
*/


-- Write your SQL solution below:

SELECT e.user_id, u.age_bucket, e.platform, e.variant
FROM experiments e
INNER JOIN users u ON e.user_id = u.user_id
WHERE e.variant = 'control'
  AND e.platform = 'android'
  AND u.account_status <> 'active'
ORDER BY e.created ASC;
