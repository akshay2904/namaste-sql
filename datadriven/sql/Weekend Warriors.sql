-- ======================================================================
-- Weekend Warriors
-- ======================================================================
-- Difficulty : Easy
-- Company    : Merilytics
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/weekend_warriors
-- ======================================================================

/*
A mobile fitness app suspects its members behave differently on weekends than on weekdays. For each event type, split the total event count into a weekend bucket and a weekday bucket, with the most weekend-heavy types first.

Table: event_data(event_id, event_type, user_id, event_timestamp, payload, tags, properties)

Sample data - event_data ['event_id', 'event_type', 'user_id', 'event_timestamp', 'payload', 'tags', 'properties']:
  [3059, 'button_click', 100, '2026-02-02 01:07:00', '{"button_id": "cancel", "element_class": "btn-primary", "position": {"x": 13, "y": 7}}', '["desktop", "web", "returning"]', '{"os": "Edge", "language": "US", "screen_size": "en", "utm_source": "mobile"}']
  [3118, 'purchase', 197, '2026-03-03 02:14:00', '{"amount": 56.93, "currency": "GBP", "items": [{"sku": "SKU1002", "qty": 3}]}', '["ios", "premium", "new_user", "organic"]', '{"country": "Windows", "device_type": "FR", "referrer": "fr", "utm_medium": "1920x1080", "browser": "twitter"}']
  [3177, 'signup', 294, '2026-04-04 03:21:00', '{"signup_method": "apple", "referral_code": "REF3X", "accepted_terms": true}', '["android", "free", "campaign_a", "referral", "experiment_v1"]', '{"language": "iOS", "screen_size": "es", "utm_source": "desktop", "session_id": "bing", "os": "organic"}']
  [3236, 'login', 391, '2026-05-05 04:28:00', '{"login_method": "password", "remember_me": true, "mfa_used": false}', '["web", "returning"]', '{"device_type": "JP", "referrer": "ja", "utm_medium": "1440x900"}']
  [3295, 'logout', 488, '2026-06-06 05:35:00', '{"action": "logout", "value": 50}', '["premium", "new_user", "organic"]', '{"screen_size": "de", "utm_source": "tablet", "session_id": "amazon", "os": "Chrome"}']

Expected output ['event_type', 'weekend_count', 'weekday_count']:
  ['purchase', 11, 18]
  ['share', 6, 6]
  ['page_view', 6, 11]
  ['login', 5, 8]
  ['error', 5, 8]
*/


-- Write your SQL solution below:

SELECT event_type,
       SUM(CASE WHEN strftime('%w', event_timestamp) IN ('0', '6')
                THEN 1 ELSE 0 END) AS weekend_count,
       SUM(CASE WHEN strftime('%w', event_timestamp) NOT IN ('0', '6')
                THEN 1 ELSE 0 END) AS weekday_count
FROM event_data
GROUP BY event_type
ORDER BY weekend_count DESC
