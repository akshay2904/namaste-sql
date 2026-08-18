-- ======================================================================
-- Feature Flag Engagement Impact
-- ======================================================================
-- Difficulty : Hard
-- Company    : General Assembly
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/feature_flag_engagement_impact
-- ======================================================================

/*
The growth team wants to understand session activity around feature flag launches. For each feature flag, return the flag name, a display name (underscores replaced with spaces), whether the flag is currently enabled, and how many user sessions started in the 30 days following the flag's created date. Flags with zero qualifying sessions should still appear with a session count of zero. Sort by flag name.

Table: feat_flags(flag_id, flag_name, enabled, rollout, owner, created, updated)

Table: user_sessions(session_id, user_id, device_id, session_start, session_duration_sec, pages_viewed)

Table: push_notifs(notif_id, user_id, title, platform, status, sent_at, opened, campaign)

Sample data - feat_flags ['flag_id', 'flag_name', 'enabled', 'rollout', 'owner', 'created', 'updated']:
  [131, 'new_checkout', 0, None, 'engineering', '2025-02-02', '2026-02-02']
  [162, 'beta_search', 0, None, 'growth', '2025-03-03', '2026-03-03']
  [193, 'ai_recs', 1, 39, 'platform', '2025-04-04', '2026-04-04']
  [224, 'live_chat', 0, None, 'mobile', '2025-05-05', '2026-05-05']
  [255, 'video_upload', 0, None, 'data', '2025-06-06', '2026-06-06']

Sample data - user_sessions ['session_id', 'user_id', 'device_id', 'session_start', 'session_duration_sec', 'pages_viewed']:
  [7061, 197, 230, '2026-02-02 01:00:00', 53, 3]
  [7122, 294, 259, '2026-03-03 02:00:00', 76, 6]
  [7183, 391, 288, '2026-04-04 03:00:00', 99, 9]
  [7244, 488, 317, '2026-05-05 04:00:00', 122, 12]
  [7305, 585, 346, '2026-06-06 05:00:00', 145, 15]

Sample data - push_notifs ['notif_id', 'user_id', 'title', 'platform', 'status', 'sent_at', 'opened', 'campaign']:
  [1053, 100, 'New message from team', 'android', 'pending', '2026-02-02 01:07:00', 0, 'winback_feb']
  [1106, 197, 'Weekly digest ready', 'web', 'failed', '2026-03-03 02:14:00', 0, 'promo_summer']
  [1159, 294, 'Price drop alert', 'iOS', 'bounced', '2026-04-04 03:21:00', 1, 'onboard_v2']
  [1212, 391, 'Security alert', 'Android', 'Delivered', '2026-05-05 04:28:00', 0, None]
  [1265, 488, 'Payment received', 'WEB', 'FAILED', '2026-06-06 05:35:00', None, 'loyalty_2024']

Expected output ['flag_name', 'display_name', 'enabled', 'launch_window_sessions']:
  ['ai_recs', 'ai recs', 1, 0]
  ['beta_search', 'beta search', 0, 7]
  ['bulk_export', 'bulk export', 0, 0]
  ['dark_mode', 'dark mode', 0, 5]
  ['live_chat', 'live chat', 0, 0]
*/


-- Write your SQL solution below:

SELECT
    ff.flag_name,
    REPLACE(ff.flag_name, '_', ' ') AS display_name,
    ff.enabled,
    COUNT(us.session_id) AS launch_window_sessions
FROM feat_flags ff
LEFT JOIN user_sessions us
    ON DATE(us.session_start) >= DATE(ff.created)
   AND DATE(us.session_start) <  DATE(ff.created, '+30 days')
GROUP BY ff.flag_id, ff.flag_name, ff.enabled
ORDER BY ff.flag_name
