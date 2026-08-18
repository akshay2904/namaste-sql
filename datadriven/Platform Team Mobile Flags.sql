-- ======================================================================
-- Platform Team Mobile Flags
-- ======================================================================
-- Difficulty : Easy
-- Company    : Vesta Innovations
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/platform_team_mobile_flags
-- ======================================================================

/*
Which feature flags are owned by the 'platform' team and have 'mobile' in the flag name? Show the owner and the flag name.

Table: feat_flags(flag_id, flag_name, enabled, rollout, owner, created, updated)

Sample data - feat_flags ['flag_id', 'flag_name', 'enabled', 'rollout', 'owner', 'created', 'updated']:
  [131, 'new_checkout', 0, None, 'engineering', '2025-02-02', '2026-02-02']
  [162, 'beta_search', 0, None, 'growth', '2025-03-03', '2026-03-03']
  [193, 'ai_recs', 1, 39, 'platform', '2025-04-04', '2026-04-04']
  [224, 'live_chat', 0, None, 'mobile', '2025-05-05', '2026-05-05']
  [255, 'video_upload', 0, None, 'data', '2025-06-06', '2026-06-06']

Expected output ['owner', 'flag_name']:
  ['platform', 'mobile_v2']
  ['platform', 'mobile_v2']
  ['platform', 'mobile_v2']
  ['platform', 'mobile_v2']
  ['platform', 'mobile_v2']
*/


-- Write your SQL solution below:

SELECT owner, flag_name
FROM feat_flags
WHERE owner = 'platform'
  AND flag_name LIKE '%mobile%'
