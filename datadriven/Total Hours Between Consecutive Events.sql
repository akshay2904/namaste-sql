-- ======================================================================
-- Total Hours Between Consecutive Events
-- ======================================================================
-- Difficulty : Hard
-- Company    : Shopify
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/total_hours_between_consecutive_events
-- ======================================================================

/*
Our pipeline tracks user events with timestamps. For each event type, calculate the total hours elapsed between consecutive events of the same type.

Table: event_data(event_id, event_type, user_id, event_timestamp, payload, tags, properties)

Sample data - event_data ['event_id', 'event_type', 'user_id', 'event_timestamp', 'payload', 'tags', 'properties']:
  [3059, 'button_click', 100, '2026-02-02 01:07:00', '{"button_id": "cancel", "element_class": "btn-primary", "position": {"x": 13, "y": 7}}', '["desktop", "web", "returning"]', '{"os": "Edge", "language": "US", "screen_size": "en", "utm_source": "mobile"}']
  [3118, 'purchase', 197, '2026-03-03 02:14:00', '{"amount": 56.93, "currency": "GBP", "items": [{"sku": "SKU1002", "qty": 3}]}', '["ios", "premium", "new_user", "organic"]', '{"country": "Windows", "device_type": "FR", "referrer": "fr", "utm_medium": "1920x1080", "browser": "twitter"}']
  [3177, 'signup', 294, '2026-04-04 03:21:00', '{"signup_method": "apple", "referral_code": "REF3X", "accepted_terms": true}', '["android", "free", "campaign_a", "referral", "experiment_v1"]', '{"language": "iOS", "screen_size": "es", "utm_source": "desktop", "session_id": "bing", "os": "organic"}']
  [3236, 'login', 391, '2026-05-05 04:28:00', '{"login_method": "password", "remember_me": true, "mfa_used": false}', '["web", "returning"]', '{"device_type": "JP", "referrer": "ja", "utm_medium": "1440x900"}']
  [3295, 'logout', 488, '2026-06-06 05:35:00', '{"action": "logout", "value": 50}', '["premium", "new_user", "organic"]', '{"screen_size": "de", "utm_source": "tablet", "session_id": "amazon", "os": "Chrome"}']

Expected output ['event_type', 'total_hours']:
  ['add_to_cart', 36901.63333333656]
  ['button_click', 43438.16666666418]
  ['checkout_start', 35795.800000000745]
  ['crash', 41683.7333333306]
  ['error', 38740.26666665822]
*/


-- Write your SQL solution below:

SELECT event_type, SUM(hours_diff) AS total_hours
FROM (
    SELECT
        event_type,
        (JULIANDAY(event_timestamp) - JULIANDAY(
            LAG(event_timestamp) OVER (
                PARTITION BY event_type
                ORDER BY event_timestamp
            )
        )) * 24 AS hours_diff
    FROM event_data
) gaps
WHERE hours_diff IS NOT NULL
GROUP BY event_type
