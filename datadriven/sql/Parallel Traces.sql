-- ======================================================================
-- Parallel Traces
-- ======================================================================
-- Difficulty : Medium
-- Company    : Airbnb
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/cross_variant_user_pairs
-- ======================================================================

/*
The experimentation team is looking for cross-variant contamination. Pair users who participated in the same experiment under different variants but on the same platform. Show both user IDs for each qualifying pair.

Table: experiments(exp_id, exp_name, variant, user_id, outcome, created, platform)

Sample data - experiments ['exp_id', 'exp_name', 'variant', 'user_id', 'outcome', 'created', 'platform']:
  [1053, 'checkout_v3', 'variant_a', 100, 11.3, '2026-02-02', 'android']
  [1106, 'onboard_flow', 'variant_b', 197, 22.6, '2026-03-03', 'web']
  [1159, 'pricing_tier', 'variant_c', 294, 33.9, '2026-04-04', 'iOS']
  [1212, 'search_rank', 'holdout', 391, 45.2, '2026-05-05', 'Android']
  [1265, 'rec_model_b', 'control', 488, 56.5, '2026-06-06', None]

Expected output ['user_id1', 'user_id2']:
  [100, 876]
  [100, 1652]
  [100, 2428]
  [100, 3204]
  [100, 4756]
*/


-- Write your SQL solution below:

SELECT DISTINCT e1.user_id AS user_id1, e2.user_id AS user_id2
FROM experiments e1
JOIN experiments e2
  ON e1.exp_name = e2.exp_name
  AND e1.platform = e2.platform
  AND e1.variant != e2.variant
  AND e1.user_id < e2.user_id
ORDER BY user_id1, user_id2
