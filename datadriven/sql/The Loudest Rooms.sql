-- ======================================================================
-- The Loudest Rooms
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/busiest_route_by_passenger_volume
-- ======================================================================

/*
We run a community app where the people who post in chat channels are the same people we serve ads to. For each channel, find how many ad impressions reached the people who post in it, busiest first.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Table: chat_msgs(msg_id, channel, sender_id, content, msg_type, sent_at, edited, reply_to)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Sample data - chat_msgs ['msg_id', 'channel', 'sender_id', 'content', 'msg_type', 'sent_at', 'edited', 'reply_to']:
  [147, '#engineering', 197, 'Anyone seeing increased latency?', 'file', '2026-02-02 01:07:00', 0, None]
  [194, '#incidents', 294, 'PR #412 ready for review', 'reaction', '2026-03-03 02:14:00', 0, None]
  [241, '#random', 391, 'Dashboard is down', 'thread_reply', '2026-04-04 03:21:00', 0, None]
  [288, '#deployments', 488, 'Fixed the flaky test', 'system', '2026-05-05 04:28:00', 0, None]
  [335, '#data-team', 585, 'Merged the migration', 'Text', '2026-06-06 05:35:00', 0, None]

Expected output ['channel', 'impression_count']:
  ['#deployments', 152]
  ['#incidents', 152]
  ['#random', 120]
  ['#data-team', 98]
  ['#general', 96]
*/


-- Write your SQL solution below:

SELECT cm.channel AS channel,
       COUNT(*) AS impression_count
FROM ad_impressions AS ai
INNER JOIN chat_msgs AS cm
  ON ai.user_id = cm.sender_id
GROUP BY cm.channel
ORDER BY impression_count DESC, cm.channel ASC;
