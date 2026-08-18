-- ======================================================================
-- Feature Flag Fan vs Detractor Pairs
-- ======================================================================
-- Difficulty : Hard
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/feature_flag_fan_vs_detractor_pairs
-- ======================================================================

/*
Rank enabled users by rollout percentage descending, and disabled users by rollout ascending. Pair the #1 fan with the #1 detractor, #2 with #2, and so on. Break ties by flag ID ascending, and show both user IDs.

Table: feat_flags(flag_id, flag_name, enabled, rollout, owner, created, updated)

Sample data - feat_flags ['flag_id', 'flag_name', 'enabled', 'rollout', 'owner', 'created', 'updated']:
  [131, 'new_checkout', 0, None, 'engineering', '2025-02-02', '2026-02-02']
  [162, 'beta_search', 0, None, 'growth', '2025-03-03', '2026-03-03']
  [193, 'ai_recs', 1, 39, 'platform', '2025-04-04', '2026-04-04']
  [224, 'live_chat', 0, None, 'mobile', '2025-05-05', '2026-05-05']
  [255, 'video_upload', 0, None, 'data', '2025-06-06', '2026-06-06']

Expected output ['fan_owner', 'opponent_owner']:
  ['platform', 'engineering']
  ['platform', 'growth']
  ['platform', 'mobile']
  ['product', 'engineering']
  ['product', 'growth']
*/


-- Write your SQL solution below:

WITH fans AS (
  SELECT owner,
         ROW_NUMBER() OVER (ORDER BY rollout DESC, flag_id ASC) AS rn
  FROM feat_flags
  WHERE enabled = 1
),
opponents AS (
  SELECT owner,
         ROW_NUMBER() OVER (ORDER BY rollout ASC, flag_id ASC) AS rn
  FROM feat_flags
  WHERE enabled = 0
)
SELECT f.owner AS fan_owner,
       o.owner AS opponent_owner
FROM fans f
INNER JOIN opponents o ON f.rn = o.rn
ORDER BY f.rn;
