-- ======================================================================
-- Feature Vote Winner
-- ======================================================================
-- Difficulty : Medium
-- Company    : EY
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/feature_vote_winner
-- ======================================================================

/*
We have a feature-voting system where each user splits a single vote equally among all the flags they voted for. Some users abstained (null entries). Calculate the effective vote tally for each flag and find the winner. Include ties. Return the flag name and effective vote total.

Table: feat_flags(flag_id, flag_name, enabled, rollout, owner, created, updated)

Sample data - feat_flags ['flag_id', 'flag_name', 'enabled', 'rollout', 'owner', 'created', 'updated']:
  [131, 'new_checkout', 0, None, 'engineering', '2025-02-02', '2026-02-02']
  [162, 'beta_search', 0, None, 'growth', '2025-03-03', '2026-03-03']
  [193, 'ai_recs', 1, 39, 'platform', '2025-04-04', '2026-04-04']
  [224, 'live_chat', 0, None, 'mobile', '2025-05-05', '2026-05-05']
  [255, 'video_upload', 0, None, 'data', '2025-06-06', '2026-06-06']

Expected output ['flag_name', 'effective_votes']:
  ['two_factor', 0.6029411764705882]
  ['video_upload', 0.6029411764705882]
*/


-- Write your SQL solution below:

WITH voter_counts AS (
  SELECT owner, COUNT(*) AS num_votes
  FROM feat_flags
  WHERE owner IS NOT NULL
  GROUP BY owner
),
weighted AS (
  SELECT f.flag_name,
         SUM(1.0 / CAST(vc.num_votes AS REAL)) AS effective_votes
  FROM feat_flags f
  JOIN voter_counts vc ON f.owner = vc.owner
  WHERE f.owner IS NOT NULL
  GROUP BY f.flag_name
)
SELECT flag_name, effective_votes
FROM weighted
WHERE effective_votes = (SELECT MAX(effective_votes) FROM weighted)
ORDER BY flag_name
