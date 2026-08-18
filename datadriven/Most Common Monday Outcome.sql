-- ======================================================================
-- Most Common Monday Outcome
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/most_common_monday_outcome
-- ======================================================================

/*
The experimentation platform tracks when experiments are created. Among experiments created on a Monday, what are the outcome values and how often does each occur? Rank sorted from most common to least.

Table: experiments(exp_id, exp_name, variant, user_id, outcome, created, platform)

Sample data - experiments ['exp_id', 'exp_name', 'variant', 'user_id', 'outcome', 'created', 'platform']:
  [1053, 'checkout_v3', 'variant_a', 100, 11.3, '2026-02-02', 'android']
  [1106, 'onboard_flow', 'variant_b', 197, 22.6, '2026-03-03', 'web']
  [1159, 'pricing_tier', 'variant_c', 294, 33.9, '2026-04-04', 'iOS']
  [1212, 'search_rank', 'holdout', 391, 45.2, '2026-05-05', 'Android']
  [1265, 'rec_model_b', 'control', 488, 56.5, '2026-06-06', None]

Expected output ['outcome', 'cnt']:
  [None, 3]
  [70.1, 2]
  [65, 2]
  [92.7, 1]
  [87.6, 1]
*/


-- Write your SQL solution below:

SELECT outcome, COUNT(*) AS cnt
FROM experiments
WHERE CAST(strftime('%w', created) AS INTEGER) = 1
GROUP BY outcome
ORDER BY cnt DESC
