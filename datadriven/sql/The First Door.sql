-- ======================================================================
-- The First Door
-- ======================================================================
-- Difficulty : Medium
-- Company    : Capital One
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/first_touch_attribution
-- ======================================================================

/*
Marketing credits each user's acquisition to their first-touch channel: whatever they did first. For each user, return the user_id and that first event's `event_type`, labeled `first_channel`.

Table: event_data(event_id, user_id, event_type, event_timestamp)

Sample data - event_data ['event_id', 'event_type', 'user_id', 'event_timestamp', 'payload', 'tags', 'properties']:
  [3059, 'button_click', 100, '2026-02-02 01:07:00', '{"button_id": "cancel", "element_class": "btn-primary", "position": {"x": 13, "y": 7}}', '["desktop", "web", "returning"]', '{"os": "Edge", "language": "US", "screen_size": "en", "utm_source": "mobile"}']
  [3118, 'purchase', 197, '2026-03-03 02:14:00', '{"amount": 56.93, "currency": "GBP", "items": [{"sku": "SKU1002", "qty": 3}]}', '["ios", "premium", "new_user", "organic"]', '{"country": "Windows", "device_type": "FR", "referrer": "fr", "utm_medium": "1920x1080", "browser": "twitter"}']
  [3177, 'signup', 294, '2026-04-04 03:21:00', '{"signup_method": "apple", "referral_code": "REF3X", "accepted_terms": true}', '["android", "free", "campaign_a", "referral", "experiment_v1"]', '{"language": "iOS", "screen_size": "es", "utm_source": "desktop", "session_id": "bing", "os": "organic"}']
  [3236, 'login', 391, '2026-05-05 04:28:00', '{"login_method": "password", "remember_me": true, "mfa_used": false}', '["web", "returning"]', '{"device_type": "JP", "referrer": "ja", "utm_medium": "1440x900"}']
  [3295, 'logout', 488, '2026-06-06 05:35:00', '{"action": "logout", "value": 50}', '["premium", "new_user", "organic"]', '{"screen_size": "de", "utm_source": "tablet", "session_id": "amazon", "os": "Chrome"}']

Expected output ['user_id', 'first_channel']:
  [None, 'page_view']
  [100, 'button_click']
  [197, 'purchase']
  [294, 'signup']
  [391, 'login']
*/


-- Write your SQL solution below:

WITH ranked AS (
    SELECT user_id,
           event_type,
           ROW_NUMBER() OVER (
               PARTITION BY user_id
               ORDER BY event_timestamp ASC, event_type ASC
           ) AS rn
    FROM event_data
)
SELECT user_id,
       event_type AS first_channel
FROM ranked
WHERE rn = 1
ORDER BY user_id;
