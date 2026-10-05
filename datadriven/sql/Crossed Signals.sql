-- ======================================================================
-- Crossed Signals
-- ======================================================================
-- Difficulty : Hard
-- Company    : Etsy
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_flagged_campaign_resolutions
-- ======================================================================

/*
Our ad platform and our ops alerting system share no common key, only a wall clock: line up each alert with the ad impressions that landed in the same hour. For each campaign, report how many alerts it drew and how many of those were marked resolved, most alerts first.

Table: ad_impressions(impression_id, user_id, ad_campaign, impression_time, clicked, revenue)

Table: alert_events(alert_id, svc_name, severity, status, fired_at, ack_by, resolved)

Sample data - ad_impressions ['impression_id', 'user_id', 'ad_campaign', 'impression_time', 'clicked', 'revenue']:
  [253, 100, 'BRAND_AWARENESS_Q1', '2026-02-02 01:07:00', 0, None]
  [306, 197, 'PRODUCT_LAUNCH_X', '2026-03-03 02:14:00', 0, None]
  [359, 294, 'RETARGETING_CART', '2026-04-04 03:21:00', 0, None]
  [412, 391, 'HOLIDAY_PROMO', '2026-05-05 04:28:00', 0, None]
  [465, 488, 'NEW_USER_ACQU', '2026-06-06 05:35:00', 1, 0.2]

Sample data - alert_events ['alert_id', 'svc_name', 'severity', 'status', 'fired_at', 'ack_by', 'resolved']:
  [129, 'payment-api', 'high', 'acknowledged', '2026-02-02 01:07:00', 'bob', '2026-02-02 03:11:00']
  [158, 'user-svc', 'medium', 'resolved', '2026-03-03 02:14:00', 'charlie', '2026-03-03 04:22:00']
  [187, 'search-api', 'low', 'silenced', '2026-04-04 03:21:00', 'dana', None]
  [216, 'gateway', 'Critical', 'firing', '2026-05-05 04:28:00', None, '2026-05-05 06:44:00']
  [245, 'notif-svc', 'HIGH', 'acknowledged', '2026-06-06 05:35:00', 'alice', '2026-06-06 07:55:00']

Expected output ['ad_campaign', 'alert_count', 'resolved_count']:
  ['PRODUCT_LAUNCH_X', 18, 18]
  ['BRAND_AWARENESS_Q1', 18, 0]
  ['HOLIDAY_PROMO', 17, 0]
  ['RETARGETING_CART', 17, 0]
  ['LOYALTY_PROGRAM', 16, 16]
*/


-- Write your SQL solution below:

WITH matched AS (
  SELECT ai.ad_campaign,
         ae.alert_id,
         ae.status
  FROM ad_impressions ai
  INNER JOIN alert_events ae
    ON SUBSTR(ai.impression_time, 1, 13) = SUBSTR(ae.fired_at, 1, 13)
)
SELECT ad_campaign,
       COUNT(DISTINCT alert_id) AS alert_count,
       COUNT(DISTINCT CASE WHEN status = 'resolved' THEN alert_id END) AS resolved_count
FROM matched
GROUP BY ad_campaign
ORDER BY alert_count DESC, resolved_count DESC, ad_campaign
