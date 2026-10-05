-- ======================================================================
-- Left On
-- ======================================================================
-- Difficulty : Medium
-- Company    : Salesforce
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/long_running_feature_flags
-- ======================================================================

/*
We're auditing feature flags that got left on too long: surface the ones created more than 730 days before May 1, 2026. For each, show its name, owner, how many whole years it's been since creation, and whether it's still enabled, counting a flag with no updated timestamp as still on.

Table: feat_flags(flag_id, flag_name, enabled, rollout, owner, created, updated)

Sample data - feat_flags ['flag_id', 'flag_name', 'enabled', 'rollout', 'owner', 'created', 'updated']:
  [131, 'new_checkout', 0, None, 'engineering', '2025-02-02', '2026-02-02']
  [162, 'beta_search', 0, None, 'growth', '2025-03-03', '2026-03-03']
  [193, 'ai_recs', 1, 39, 'platform', '2025-04-04', '2026-04-04']
  [224, 'live_chat', 0, None, 'mobile', '2025-05-05', '2026-05-05']
  [255, 'video_upload', 0, None, 'data', '2025-06-06', '2026-06-06']

Expected output ['flag_name', 'owner', 'still_enabled', 'years_since_creation']:
  ['ai_recs', 'engineering', 'No', 2]
  ['ai_recs', 'engineering', 'No', 2]
  ['ai_recs', 'platform', 'Yes', 2]
  ['ai_recs', 'platform', 'Yes', 2]
  ['beta_search', 'growth', 'No', 3]
*/


-- Write your SQL solution below:

SELECT flag_name, owner,
       CASE WHEN enabled = 1 OR updated IS NULL THEN 'Yes' ELSE 'No' END AS still_enabled,
       CAST((JULIANDAY('2026-05-01') - JULIANDAY(created)) / 365 AS INTEGER) AS years_since_creation
FROM feat_flags
WHERE JULIANDAY('2026-05-01') - JULIANDAY(created) > 730
ORDER BY flag_name, owner, years_since_creation DESC, still_enabled
