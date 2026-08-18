-- ======================================================================
-- Platform Team Feature Flags
-- ======================================================================
-- Difficulty : Easy
-- Company    : City and County of San Francisco
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/platform_team_feature_flags
-- ======================================================================

/*
The platform team is auditing their feature flag inventory before a major release. Pull all fields for every flag they own.

Table: feat_flags(flag_id, flag_name, enabled, rollout, owner, created, updated)

Sample data - feat_flags ['flag_id', 'flag_name', 'enabled', 'rollout', 'owner', 'created', 'updated']:
  [131, 'new_checkout', 0, None, 'engineering', '2025-02-02', '2026-02-02']
  [162, 'beta_search', 0, None, 'growth', '2025-03-03', '2026-03-03']
  [193, 'ai_recs', 1, 39, 'platform', '2025-04-04', '2026-04-04']
  [224, 'live_chat', 0, None, 'mobile', '2025-05-05', '2026-05-05']
  [255, 'video_upload', 0, None, 'data', '2025-06-06', '2026-06-06']

Expected output ['flag_id', 'flag_name', 'enabled', 'rollout', 'owner', 'created', 'updated']:
  [193, 'ai_recs', 1, 39, 'platform', '2025-04-04', '2026-04-04']
  [379, 'mobile_v2', 1, 17, 'platform', '2025-10-10', '2026-10-10']
  [565, 'video_upload', 1, 95, 'platform', '2025-04-16', '2026-04-16']
  [751, 'new_checkout', 1, 73, 'platform', '2025-10-22', '2026-10-22']
  [937, 'bulk_export', 1, 51, 'platform', '2025-04-28', '2026-04-28']
*/


-- Write your SQL solution below:

SELECT *
FROM feat_flags
WHERE owner = 'platform'
