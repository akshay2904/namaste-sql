-- ======================================================================
-- The Space Between
-- ======================================================================
-- Difficulty : Hard
-- Company    : Meta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/average_event_progression_time
-- ======================================================================

/*
An onboarding team measures user momentum as the average gap, in seconds, between each of a user's events and the one immediately before it, where event_timestamp is stored as a Unix epoch second. For each user with more than one recorded event, return that average gap, ignoring events with no user attached, ordered by user ID.

Table: event_data(event_id, event_type, user_id, event_timestamp, payload, tags, properties)

Sample data - event_data ['event_id', 'event_type', 'user_id', 'event_timestamp', 'payload', 'tags', 'properties']:
  [3059, 'button_click', 100, '2026-02-02 01:07:00', '{"button_id": "cancel", "element_class": "btn-primary", "position": {"x": 13, "y": 7}}', '["desktop", "web", "returning"]', '{"os": "Edge", "language": "US", "screen_size": "en", "utm_source": "mobile"}']
  [3118, 'purchase', 197, '2026-03-03 02:14:00', '{"amount": 56.93, "currency": "GBP", "items": [{"sku": "SKU1002", "qty": 3}]}', '["ios", "premium", "new_user", "organic"]', '{"country": "Windows", "device_type": "FR", "referrer": "fr", "utm_medium": "1920x1080", "browser": "twitter"}']
  [3177, 'signup', 294, '2026-04-04 03:21:00', '{"signup_method": "apple", "referral_code": "REF3X", "accepted_terms": true}', '["android", "free", "campaign_a", "referral", "experiment_v1"]', '{"language": "iOS", "screen_size": "es", "utm_source": "desktop", "session_id": "bing", "os": "organic"}']
  [3236, 'login', 391, '2026-05-05 04:28:00', '{"login_method": "password", "remember_me": true, "mfa_used": false}', '["web", "returning"]', '{"device_type": "JP", "referrer": "ja", "utm_medium": "1440x900"}']
  [3295, 'logout', 488, '2026-06-06 05:35:00', '{"action": "logout", "value": 50}', '["premium", "new_user", "organic"]', '{"screen_size": "de", "utm_source": "tablet", "session_id": "amazon", "os": "Chrome"}']

Expected output ['user_id', 'avg_progression_seconds']:
  [100, 4]
  [197, 3]
  [294, 2]
  [391, 1]
  [488, 0]
*/


-- Write your SQL solution below:

WITH event_gaps AS (
  SELECT
    user_id,
    event_timestamp,
    LAG(event_timestamp) OVER (
      PARTITION BY user_id ORDER BY event_timestamp, event_id
    ) AS prev_timestamp
  FROM event_data
  WHERE user_id IS NOT NULL
)
SELECT
  user_id,
  AVG(event_timestamp - prev_timestamp) AS avg_progression_seconds
FROM event_gaps
WHERE prev_timestamp IS NOT NULL
GROUP BY user_id
ORDER BY user_id;
