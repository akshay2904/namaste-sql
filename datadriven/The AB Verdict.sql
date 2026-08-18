-- ======================================================================
-- The A/B Verdict
-- ======================================================================
-- Difficulty : Medium
-- Company    : Google
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/experiment_conversion_pivot
-- ======================================================================

/*
For each experiment on the A/B testing platform, show the count of positive outcomes (where the outcome value is greater than zero), the count of non-positive outcomes, and the average outcome value.

Table: experiments(exp_id, exp_name, variant, user_id, outcome, created, platform)

Sample data - experiments ['exp_id', 'exp_name', 'variant', 'user_id', 'outcome', 'created', 'platform']:
  [1053, 'checkout_v3', 'variant_a', 100, 11.3, '2026-02-02', 'android']
  [1106, 'onboard_flow', 'variant_b', 197, 22.6, '2026-03-03', 'web']
  [1159, 'pricing_tier', 'variant_c', 294, 33.9, '2026-04-04', 'iOS']
  [1212, 'search_rank', 'holdout', 391, 45.2, '2026-05-05', 'Android']
  [1265, 'rec_model_b', 'control', 488, 56.5, '2026-06-06', None]

Expected output ['exp_name', 'control_conversions', 'treatment_conversions']:
  ['checkout_v3', 4, 0]
  ['home_layout', 6, 0]
  ['new_feed_algo', 4, 0]
  ['notif_freq', 2, 0]
  ['rec_model_b', 6, 0]
*/


-- Write your SQL solution below:

SELECT exp_name,
       SUM(CASE WHEN variant = 'control' AND outcome > 0 THEN 1 ELSE 0 END) AS control_conversions,
       SUM(CASE WHEN variant = 'treatment' AND outcome > 0 THEN 1 ELSE 0 END) AS treatment_conversions
FROM experiments
GROUP BY exp_name
ORDER BY exp_name
