-- ======================================================================
-- Flag Check
-- ======================================================================
-- Difficulty : Easy
-- Company    : N/A
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/flag_check
-- ======================================================================

/*
Release engineering is auditing the feature flag system before a major rollout. They want to see the overall adoption rate of enabled flags, broken down by owner. For each flag owner, show how many flags they own, the number that are currently enabled, and the average rollout percentage across their flags. Skip any flags with no rollout value on file. Present owners from the highest number of enabled flags to the lowest.

Table: feat_flags(flag_id, flag_name, enabled, rollout, owner, created, updated)

Sample data - feat_flags ['flag_id', 'flag_name', 'enabled', 'rollout', 'owner', 'created', 'updated']:
  [131, 'new_checkout', 0, None, 'engineering', '2025-02-02', '2026-02-02']
  [162, 'beta_search', 0, None, 'growth', '2025-03-03', '2026-03-03']
  [193, 'ai_recs', 1, 39, 'platform', '2025-04-04', '2026-04-04']
  [224, 'live_chat', 0, None, 'mobile', '2025-05-05', '2026-05-05']
  [255, 'video_upload', 0, None, 'data', '2025-06-06', '2026-06-06']

Expected output ['owner', 'total_flags', 'enabled_count', 'avg_rollout']:
  ['platform', 34, 34, 51.23529411764706]
  ['product', 32, 32, 50.5]
*/


-- Write your SQL solution below:

SELECT owner, COUNT(*) AS total_flags, SUM(enabled) AS enabled_count, AVG(rollout) AS avg_rollout FROM feat_flags WHERE rollout IS NOT NULL GROUP BY owner ORDER BY enabled_count DESC, owner ASC
