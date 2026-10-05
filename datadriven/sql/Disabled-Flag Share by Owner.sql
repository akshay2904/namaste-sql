-- ======================================================================
-- Disabled-Flag Share by Owner
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/disabled_flag_ratio
-- ======================================================================

/*
The platform team is auditing feature-flag hygiene by owning team. For each owner, what fraction of their feature flags are disabled (enabled = 0)? Return the owner and the disabled fraction, highest first.

Table: feat_flags(flag_id, flag_name, enabled, rollout, owner, created, updated)

Sample data - feat_flags ['flag_id', 'flag_name', 'enabled', 'rollout', 'owner', 'created', 'updated']:
  [131, 'new_checkout', 0, None, 'engineering', '2025-02-02', '2026-02-02']
  [162, 'beta_search', 0, None, 'growth', '2025-03-03', '2026-03-03']
  [193, 'ai_recs', 1, 39, 'platform', '2025-04-04', '2026-04-04']
  [224, 'live_chat', 0, None, 'mobile', '2025-05-05', '2026-05-05']
  [255, 'video_upload', 0, None, 'data', '2025-06-06', '2026-06-06']

Expected output ['owner', 'disabled_ratio']:
  ['data', 1]
  ['engineering', 1]
  ['growth', 1]
  ['platform', 0]
  ['product', 0]
*/


-- Write your SQL solution below:

SELECT owner, ROUND(CAST(SUM(CASE WHEN enabled=0 THEN 1 ELSE 0 END) AS REAL)/COUNT(*),3) AS disabled_ratio FROM feat_flags GROUP BY owner ORDER BY disabled_ratio DESC, owner
