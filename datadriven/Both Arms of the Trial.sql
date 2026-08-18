-- ======================================================================
-- Both Arms of the Trial
-- ======================================================================
-- Difficulty : Easy
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/multi_variant_experiments
-- ======================================================================

/*
Our experimentation platform logs one record per user assignment, tagged with the feature test and the variant that user landed in. Find the tests that reached both the 'variant_a' and 'variant_b' groups, returning the test name for each.

Table: experiments(exp_id, exp_name, variant, user_id, outcome, created, platform)

Sample data - experiments ['exp_id', 'exp_name', 'variant', 'user_id', 'outcome', 'created', 'platform']:
  [1053, 'checkout_v3', 'variant_a', 100, 11.3, '2026-02-02', 'android']
  [1106, 'onboard_flow', 'variant_b', 197, 22.6, '2026-03-03', 'web']
  [1159, 'pricing_tier', 'variant_c', 294, 33.9, '2026-04-04', 'iOS']
  [1212, 'search_rank', 'holdout', 391, 45.2, '2026-05-05', 'Android']
  [1265, 'rec_model_b', 'control', 488, 56.5, '2026-06-06', None]

Expected output ['exp_name']:
  ['checkout_v3']
  ['home_layout']
  ['new_feed_algo']
  ['notif_freq']
  ['onboard_flow']
*/


-- Write your SQL solution below:

SELECT exp_name
FROM experiments
GROUP BY exp_name
HAVING SUM(CASE WHEN variant = 'variant_a' THEN 1 ELSE 0 END) > 0
   AND SUM(CASE WHEN variant = 'variant_b' THEN 1 ELSE 0 END) > 0
ORDER BY exp_name
