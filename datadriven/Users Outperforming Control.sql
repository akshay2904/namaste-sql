-- ======================================================================
-- Users Outperforming Control
-- ======================================================================
-- Difficulty : Medium
-- Company    : Walmart
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/users_outperforming_control
-- ======================================================================

/*
The experimentation team is identifying users who outperformed the control baseline. For each user in treatment_a whose metric value exceeds the average control value for the same test, show the user ID, their treatment value, and the average control value.

Table: ab_results(result_id, test_name, variant, user_id, metric, value, created)

Sample data - ab_results ['result_id', 'test_name', 'variant', 'user_id', 'metric', 'value', 'created']:
  [237, 'new_homepage', 'treatment_a', 100, 'click_rate', 13.7, '2026-02-02']
  [274, 'pricing_page', 'treatment_b', 197, 'revenue', 27.4, '2026-03-03']
  [311, 'onboarding_v3', 'Control', 294, 'bounce', 41.1, '2026-04-04']
  [348, 'search_algo_b', 'CONTROL', 391, 'time_on_page', 54.8, '2026-05-05']
  [385, 'rec_engine_v2', 'control', 488, 'signup', 68.5, '2026-06-06']

Expected output ['user_id', 'treatment_value', 'avg_control_value']:
  [585, 82.2, 48.699999999999996]
  [1070, 50.7, 44.32]
  [2040, 87.7, 39.918181818181814]
  [2525, 56.2, 30.400000000000002]
  [3495, 93.2, 48.699999999999996]
*/


-- Write your SQL solution below:

SELECT
    t.user_id,
    MAX(t.value) AS treatment_value,
    c.avg_control_value
FROM ab_results t
JOIN (
    SELECT test_name, AVG(value) AS avg_control_value
    FROM ab_results
    WHERE LOWER(variant) = 'control'
    GROUP BY test_name
) c ON t.test_name = c.test_name
WHERE t.variant = 'treatment_a'
  AND t.value > c.avg_control_value
GROUP BY t.user_id, c.avg_control_value
ORDER BY t.user_id;
