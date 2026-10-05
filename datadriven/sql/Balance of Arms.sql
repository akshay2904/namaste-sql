-- ======================================================================
-- Balance of Arms
-- ======================================================================
-- Difficulty : Hard
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/experiment_variant_ratios
-- ======================================================================

/*
An experimentation platform needs to confirm each test's groups are balanced before readout, and treats every arm that is not the control group as treatment. For each experiment, find the unique users in control, the unique users in treatment, and the treatment-to-control ratio, leaving the ratio empty when an experiment has no control users.

Table: experiments(exp_id, exp_name, variant, user_id, outcome, created, platform)

Sample data - experiments ['exp_id', 'exp_name', 'variant', 'user_id', 'outcome', 'created', 'platform']:
  [1053, 'checkout_v3', 'variant_a', 100, 11.3, '2026-02-02', 'android']
  [1106, 'onboard_flow', 'variant_b', 197, 22.6, '2026-03-03', 'web']
  [1159, 'pricing_tier', 'variant_c', 294, 33.9, '2026-04-04', 'iOS']
  [1212, 'search_rank', 'holdout', 391, 45.2, '2026-05-05', 'Android']
  [1265, 'rec_model_b', 'control', 488, 56.5, '2026-06-06', None]

Expected output ['exp_name', 'control_users', 'treatment_users', 'treatment_to_control_ratio']:
  ['checkout_v3', 2, 11, 5.5]
  ['home_layout', 3, 9, 3]
  ['new_feed_algo', 2, 10, 5]
  ['notif_freq', 2, 10, 5]
  ['onboard_flow', 3, 10, 3.333]
*/


-- Write your SQL solution below:

SELECT exp_name,
       COUNT(DISTINCT CASE WHEN variant = 'control' THEN user_id END) AS control_users,
       COUNT(DISTINCT CASE WHEN variant <> 'control' THEN user_id END) AS treatment_users,
       ROUND(
           COUNT(DISTINCT CASE WHEN variant <> 'control' THEN user_id END) * 1.0 /
           NULLIF(COUNT(DISTINCT CASE WHEN variant = 'control' THEN user_id END), 0), 3
       ) AS treatment_to_control_ratio
FROM experiments
GROUP BY exp_name
ORDER BY exp_name;
