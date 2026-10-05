-- ======================================================================
-- Largest A/B Test by Participants
-- ======================================================================
-- Difficulty : Medium
-- Company    : ESPN
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/largest_a_b_test_by_participants
-- ======================================================================

/*
The data science team is identifying which A/B test drew the widest audience. Which test had the most unique participants? Return the test name and count for the top one.

Table: ab_results(result_id, test_name, variant, user_id, metric, value, created)

Sample data - ab_results ['result_id', 'test_name', 'variant', 'user_id', 'metric', 'value', 'created']:
  [237, 'new_homepage', 'treatment_a', 100, 'click_rate', 13.7, '2026-02-02']
  [274, 'pricing_page', 'treatment_b', 197, 'revenue', 27.4, '2026-03-03']
  [311, 'onboarding_v3', 'Control', 294, 'bounce', 41.1, '2026-04-04']
  [348, 'search_algo_b', 'CONTROL', 391, 'time_on_page', 54.8, '2026-05-05']
  [385, 'rec_engine_v2', 'control', 488, 'signup', 68.5, '2026-06-06']

Expected output ['test_name', 'unique_participants']:
  ['search_algo_b', 17]
*/


-- Write your SQL solution below:

SELECT test_name,
       COUNT(DISTINCT user_id) AS unique_participants
FROM ab_results
GROUP BY test_name
ORDER BY unique_participants DESC
LIMIT 1
