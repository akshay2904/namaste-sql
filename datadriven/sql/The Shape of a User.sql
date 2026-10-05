-- ======================================================================
-- The Shape of a User
-- ======================================================================
-- Difficulty : Medium
-- Company    : Lyft
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/pivot_event_counts
-- ======================================================================

/*
Our product analytics team wants a per-user funnel snapshot pulled from the raw event log. Produce one row per user, with separate columns counting that user's search, add_to_cart, and purchase events.

Table: event_data(event_id, user_id, event_type, event_timestamp)

Sample data - event_data ['event_id', 'event_type', 'user_id', 'event_timestamp', 'payload', 'tags', 'properties']:
  [3059, 'button_click', 100, '2026-02-02 01:07:00', '{"button_id": "cancel", "element_class": "btn-primary", "position": {"x": 13, "y": 7}}', '["desktop", "web", "returning"]', '{"os": "Edge", "language": "US", "screen_size": "en", "utm_source": "mobile"}']
  [3118, 'purchase', 197, '2026-03-03 02:14:00', '{"amount": 56.93, "currency": "GBP", "items": [{"sku": "SKU1002", "qty": 3}]}', '["ios", "premium", "new_user", "organic"]', '{"country": "Windows", "device_type": "FR", "referrer": "fr", "utm_medium": "1920x1080", "browser": "twitter"}']
  [3177, 'signup', 294, '2026-04-04 03:21:00', '{"signup_method": "apple", "referral_code": "REF3X", "accepted_terms": true}', '["android", "free", "campaign_a", "referral", "experiment_v1"]', '{"language": "iOS", "screen_size": "es", "utm_source": "desktop", "session_id": "bing", "os": "organic"}']
  [3236, 'login', 391, '2026-05-05 04:28:00', '{"login_method": "password", "remember_me": true, "mfa_used": false}', '["web", "returning"]', '{"device_type": "JP", "referrer": "ja", "utm_medium": "1440x900"}']
  [3295, 'logout', 488, '2026-06-06 05:35:00', '{"action": "logout", "value": 50}', '["premium", "new_user", "organic"]', '{"screen_size": "de", "utm_source": "tablet", "session_id": "amazon", "os": "Chrome"}']

Expected output ['user_id', 'searches', 'add_to_carts', 'purchases']:
  [None, 0, 13, 0]
  [100, 0, 0, 0]
  [585, 2, 0, 0]
  [1943, 2, 0, 0]
  [8733, 1, 0, 0]
*/


-- Write your SQL solution below:

SELECT
    user_id,
    SUM(CASE WHEN event_type = 'search' THEN 1 ELSE 0 END) AS searches,
    SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_carts,
    SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchases
FROM event_data
GROUP BY user_id
