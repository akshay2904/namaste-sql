-- ======================================================================
-- Who Moved the Needle
-- ======================================================================
-- Difficulty : Medium
-- Company    : Spotify
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_10_ab_test_variants
-- ======================================================================

/*
We're compiling a leaderboard for the onboarding_v3 experiment, where a user's standing is the total metric value they drove. Return the users in the top ten standings, biggest first, along with the variant each was assigned.

Table: ab_results(result_id, test_name, variant, user_id, metric, value, created)

Sample data - ab_results ['result_id', 'test_name', 'variant', 'user_id', 'metric', 'value', 'created']:
  [237, 'new_homepage', 'treatment_a', 100, 'click_rate', 13.7, '2026-02-02']
  [274, 'pricing_page', 'treatment_b', 197, 'revenue', 27.4, '2026-03-03']
  [311, 'onboarding_v3', 'Control', 294, 'bounce', 41.1, '2026-04-04']
  [348, 'search_algo_b', 'CONTROL', 391, 'time_on_page', 54.8, '2026-05-05']
  [385, 'rec_engine_v2', 'control', 488, 'signup', 68.5, '2026-06-06']

Expected output ['rnk', 'variant', 'user_id', 'total_value']:
  [1, 'treatment_a', 4950, 197.4]
  [2, 'treatment_b', 8442, 183.8]
  [3, 'treatment_a', 2040, 175.4]
  [5, 'Control', 9024, 148.2]
  [8, 'CONTROL', 9606, 112.6]
*/


-- Write your SQL solution below:

SELECT rnk, variant, user_id, total_value
FROM (
  SELECT variant, user_id, SUM(value) AS total_value,
    DENSE_RANK() OVER (ORDER BY SUM(value) DESC) AS rnk
  FROM ab_results
  WHERE test_name = 'onboarding_v3'
  GROUP BY variant, user_id
)
WHERE rnk <= 10
ORDER BY rnk ASC, variant ASC, user_id ASC
