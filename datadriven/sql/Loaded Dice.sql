-- ======================================================================
-- Loaded Dice
-- ======================================================================
-- Difficulty : Hard
-- Company    : Goldman Sachs
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/weighted_variant_selection
-- ======================================================================

/*
An A/B testing platform picks which feature flag to show by treating each flag's rollout percentage as its weight, so a flag with no rollout set is out of the running. For every flag still in play, report its selection probability (its share of the total rollout) and a cumulative probability that adds up those shares starting from the smallest rollout and climbing to the largest.

Table: feat_flags(flag_id, flag_name, rollout)

Sample data - feat_flags ['flag_id', 'flag_name', 'enabled', 'rollout', 'owner', 'created', 'updated']:
  [131, 'new_checkout', 0, None, 'engineering', '2025-02-02', '2026-02-02']
  [162, 'beta_search', 0, None, 'growth', '2025-03-03', '2026-03-03']
  [193, 'ai_recs', 1, 39, 'platform', '2025-04-04', '2026-04-04']
  [224, 'live_chat', 0, None, 'mobile', '2025-05-05', '2026-05-05']
  [255, 'video_upload', 0, None, 'data', '2025-06-06', '2026-06-06']

Expected output ['flag_id', 'flag_name', 'rollout', 'probability', 'cumulative_prob']:
  [1774, 'live_chat', 2, 0.0005955926146515784, 0.0005955926146515784]
  [10003254, 'live_chat', 2, 0.0005955926146515784, 0.0011911852293031567]
  [1309, 'mobile_v2', 7, 0.002084574151280524, 0.003275759380583681]
  [10003239, 'mobile_v2', 7, 0.002084574151280524, 0.005360333531864205]
  [2983, 'ai_recs', 9, 0.0026801667659321023, 0.008040500297796307]
*/


-- Write your SQL solution below:

SELECT
    flag_id,
    flag_name,
    rollout,
    CAST(rollout AS REAL) / SUM(rollout) OVER () AS probability,
    SUM(CAST(rollout AS REAL)) OVER (
        ORDER BY rollout, flag_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) / SUM(rollout) OVER () AS cumulative_prob
FROM feat_flags
WHERE rollout IS NOT NULL
ORDER BY rollout, flag_id
