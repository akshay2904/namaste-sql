-- ======================================================================
-- Higher Performing Variant
-- ======================================================================
-- Difficulty : Easy
-- Company    : Airbnb
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/higher_performing_variant
-- ======================================================================

/*
We ran an A/B test with control and treatment variants. Which variant produces a higher average metric value? Return only the winning variant with its average rounded to 2 decimal places.

Table: ab_results(result_id, test_name, variant, user_id, metric, value, created)

Sample data - ab_results ['result_id', 'test_name', 'variant', 'user_id', 'metric', 'value', 'created']:
  [237, 'new_homepage', 'treatment_a', 100, 'click_rate', 13.7, '2026-02-02']
  [274, 'pricing_page', 'treatment_b', 197, 'revenue', 27.4, '2026-03-03']
  [311, 'onboarding_v3', 'Control', 294, 'bounce', 41.1, '2026-04-04']
  [348, 'search_algo_b', 'CONTROL', 391, 'time_on_page', 54.8, '2026-05-05']
  [385, 'rec_engine_v2', 'control', 488, 'signup', 68.5, '2026-06-06']

Expected output ['variant', 'avg_value']:
  ['CONTROL', 50.55]
*/


-- Write your SQL solution below:

SELECT variant, ROUND(AVG(value), 2) AS avg_value
FROM ab_results
GROUP BY variant
ORDER BY avg_value DESC
LIMIT 1
