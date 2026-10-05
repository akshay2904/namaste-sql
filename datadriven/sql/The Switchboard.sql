-- ======================================================================
-- The Switchboard
-- ======================================================================
-- Difficulty : Medium
-- Company    : Credit Karma
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/binary_flag_indicators
-- ======================================================================

/*
A feature-flag service writes a new record every time a flag is switched on or off, so one flag can appear many times with different settings. For each flag, give its current state as two indicators: a 1/0 for whether it is enabled and a 1/0 for whether it is disabled.

Table: feat_flags(flag_id, flag_name, enabled, rollout, owner, created, updated)

Sample data - feat_flags ['flag_id', 'flag_name', 'enabled', 'rollout', 'owner', 'created', 'updated']:
  [131, 'new_checkout', 0, None, 'engineering', '2025-02-02', '2026-02-02']
  [162, 'beta_search', 0, None, 'growth', '2025-03-03', '2026-03-03']
  [193, 'ai_recs', 1, 39, 'platform', '2025-04-04', '2026-04-04']
  [224, 'live_chat', 0, None, 'mobile', '2025-05-05', '2026-05-05']
  [255, 'video_upload', 0, None, 'data', '2025-06-06', '2026-06-06']

Expected output ['flag_name', 'enabled_flag', 'disabled_flag']:
  ['ai_recs', 0, 1]
  ['beta_search', 0, 1]
  ['bulk_export', 0, 1]
  ['dark_mode', 1, 0]
  ['live_chat', 0, 1]
*/


-- Write your SQL solution below:

WITH latest AS (
    SELECT
        flag_name,
        enabled,
        ROW_NUMBER() OVER (
            PARTITION BY flag_name
            ORDER BY updated DESC, flag_id DESC
        ) AS rn
    FROM feat_flags
)
SELECT
    flag_name,
    enabled AS enabled_flag,
    1 - enabled AS disabled_flag
FROM latest
WHERE rn = 1
ORDER BY flag_name;
