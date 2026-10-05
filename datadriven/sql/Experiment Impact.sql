-- ======================================================================
-- Experiment Impact
-- ======================================================================
-- Difficulty : Hard
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/experiment_impact
-- ======================================================================

/*
The data science team is auditing how each experiment fared inside the variant buckets it ran in: for every experiment and variant pairing in experiments, take the average outcome and the participant count, ignoring rows where the outcome was never recorded. Within each variant, ordered from the highest average outcome down, give each experiment a competition standing where tied experiments share a slot and a slot equals one plus the number of experiments in that variant with a strictly higher average, plus a tier standing where ties again share a number but the numbers stay consecutive with no gaps so the next lower average is always the next number up. Return the exp_name, variant, average outcome, participant count, competition standing, and tier standing.

Table: experiments(exp_id, exp_name, variant, user_id, outcome, created, platform)

Sample data - experiments ['exp_id', 'exp_name', 'variant', 'user_id', 'outcome', 'created', 'platform']:
  [1053, 'checkout_v3', 'variant_a', 100, 11.3, '2026-02-02', 'android']
  [1106, 'onboard_flow', 'variant_b', 197, 22.6, '2026-03-03', 'web']
  [1159, 'pricing_tier', 'variant_c', 294, 33.9, '2026-04-04', 'iOS']
  [1212, 'search_rank', 'holdout', 391, 45.2, '2026-05-05', 'Android']
  [1265, 'rec_model_b', 'control', 488, 56.5, '2026-06-06', None]

Expected output ['exp_name', 'variant', 'avg_out', 'participants', 'rnk', 'tier']:
  ['notif_freq', 'control', 91, 2, 1, 1]
  ['search_rank', 'holdout', 71.2, 4, 1, 1]
  ['onboard_flow', 'variant_a', 93.8, 2, 1, 1]
  ['checkout_v3', 'variant_b', 77.43333333333332, 6, 1, 1]
  ['new_feed_algo', 'variant_c', 92.4, 4, 1, 1]
*/


-- Write your SQL solution below:

WITH exp_avgs AS (
  SELECT exp_name, variant,
         AVG(outcome) AS avg_out,
         COUNT(*) AS participants
  FROM experiments
  WHERE outcome IS NOT NULL
  GROUP BY exp_name, variant
)
SELECT e1.exp_name, e1.variant, e1.avg_out, e1.participants,
       1 + (SELECT COUNT(*) FROM exp_avgs e2
            WHERE e2.variant = e1.variant
              AND e2.avg_out > e1.avg_out) AS rnk,
       DENSE_RANK() OVER (PARTITION BY e1.variant ORDER BY e1.avg_out DESC) AS tier
FROM exp_avgs e1
ORDER BY e1.variant, rnk, e1.exp_name
