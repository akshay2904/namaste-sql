-- ======================================================================
-- App Stability by Region
-- ======================================================================
-- Difficulty : Medium
-- Company    : Visa
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/app_stability_by_region
-- ======================================================================

/*
The mobile team is weighing the next rollout and wants to see where the app keeps falling over. Looking only at app opens and crashes, count each for every tag set and event timestamp, and report the crash rate as crashes divided by opens, rounded to four decimal places.

Table: event_data(event_id, event_type, user_id, event_timestamp, payload, tags, properties)

Sample data - event_data ['event_id', 'event_type', 'user_id', 'event_timestamp', 'payload', 'tags', 'properties']:
  [3059, 'button_click', 100, '2026-02-02 01:07:00', '{"button_id": "cancel", "element_class": "btn-primary", "position": {"x": 13, "y": 7}}', '["desktop", "web", "returning"]', '{"os": "Edge", "language": "US", "screen_size": "en", "utm_source": "mobile"}']
  [3118, 'purchase', 197, '2026-03-03 02:14:00', '{"amount": 56.93, "currency": "GBP", "items": [{"sku": "SKU1002", "qty": 3}]}', '["ios", "premium", "new_user", "organic"]', '{"country": "Windows", "device_type": "FR", "referrer": "fr", "utm_medium": "1920x1080", "browser": "twitter"}']
  [3177, 'signup', 294, '2026-04-04 03:21:00', '{"signup_method": "apple", "referral_code": "REF3X", "accepted_terms": true}', '["android", "free", "campaign_a", "referral", "experiment_v1"]', '{"language": "iOS", "screen_size": "es", "utm_source": "desktop", "session_id": "bing", "os": "organic"}']
  [3236, 'login', 391, '2026-05-05 04:28:00', '{"login_method": "password", "remember_me": true, "mfa_used": false}', '["web", "returning"]', '{"device_type": "JP", "referrer": "ja", "utm_medium": "1440x900"}']
  [3295, 'logout', 488, '2026-06-06 05:35:00', '{"action": "logout", "value": 50}', '["premium", "new_user", "organic"]', '{"screen_size": "de", "utm_source": "tablet", "session_id": "amazon", "os": "Chrome"}']

Expected output ['event_timestamp', 'tags', 'num_opens', 'num_crashes', 'crash_rate']:
  ['2022-03-24 03:57:00', '["mobile", "android", "free", "campaign_a", "referral"]', 0, 1, None]
  ['2022-12-09 12:12:00', '["ios", "premium"]', 1, 0, 0]
  ['2023-01-10 13:19:00', '["android", "free", "campaign_a"]', 0, 1, None]
  ['2023-10-23 22:34:00', '["premium", "new_user", "organic", "beta"]', 1, 0, 0]
  ['2024-11-24 23:41:00', '["free", "campaign_a", "referral", "experiment_v1", "desktop"]', 0, 1, None]
*/


-- Write your SQL solution below:

SELECT
  event_timestamp,
  tags,
  SUM(CASE WHEN event_type = 'open'  THEN 1 ELSE 0 END) AS num_opens,
  SUM(CASE WHEN event_type = 'crash' THEN 1 ELSE 0 END) AS num_crashes,
  ROUND(
    SUM(CASE WHEN event_type = 'crash' THEN 1 ELSE 0 END) * 1.0
    / SUM(CASE WHEN event_type = 'open' THEN 1 ELSE 0 END),
    4
  ) AS crash_rate
FROM event_data
WHERE event_type IN ('open', 'crash')
GROUP BY event_timestamp, tags
