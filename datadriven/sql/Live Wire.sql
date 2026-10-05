-- ======================================================================
-- Live Wire
-- ======================================================================
-- Difficulty : Medium
-- Company    : Netflix
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/currently_active_feature_flags
-- ======================================================================

/*
Every change to a feature flag is written as a new row, so a single flag shows up many times across its history. For each owning team, find the flag they touched most recently and when that change landed, with the most recently active team first.

Table: feat_flags(flag_id, flag_name, enabled, rollout, owner, created, updated)

Sample data - feat_flags ['flag_id', 'flag_name', 'enabled', 'rollout', 'owner', 'created', 'updated']:
  [131, 'new_checkout', 0, None, 'engineering', '2025-02-02', '2026-02-02']
  [162, 'beta_search', 0, None, 'growth', '2025-03-03', '2026-03-03']
  [193, 'ai_recs', 1, 39, 'platform', '2025-04-04', '2026-04-04']
  [224, 'live_chat', 0, None, 'mobile', '2025-05-05', '2026-05-05']
  [255, 'video_upload', 0, None, 'data', '2025-06-06', '2026-06-06']

Expected output ['owner', 'flag_name', 'last_changed']:
  ['data', 'ai_recs', '2026-12-28']
  ['product', 'dark_mode', '2026-12-05']
  ['mobile', 'beta_search', '2026-11-27']
  ['platform', 'new_checkout', '2026-10-26']
  ['engineering', 'video_upload', '2026-08-28']
*/


-- Write your SQL solution below:

WITH ranked AS (
    SELECT
        owner,
        flag_name,
        updated,
        ROW_NUMBER() OVER (
            PARTITION BY owner
            ORDER BY updated DESC, flag_id DESC
        ) AS rn
    FROM feat_flags
)
SELECT
    owner,
    flag_name,
    updated AS last_changed
FROM ranked
WHERE rn = 1
ORDER BY last_changed DESC
