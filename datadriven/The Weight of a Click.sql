-- ======================================================================
-- The Weight of a Click
-- ======================================================================
-- Difficulty : Hard
-- Company    : Mercury Insurance
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/funnel_leakage_report
-- ======================================================================

/*
The growth team wants an engagement breakdown across four commerce events: page_view, search, checkout_start, and purchase. For each event, show how many unique users performed it and that count as a percentage of the four counts combined, most users first.

Table: event_data(event_id, event_type, user_id, event_timestamp, payload, tags, properties)

Sample data - event_data ['event_id', 'event_type', 'user_id', 'event_timestamp', 'payload', 'tags', 'properties']:
  [3059, 'button_click', 100, '2026-02-02 01:07:00', '{"button_id": "cancel", "element_class": "btn-primary", "position": {"x": 13, "y": 7}}', '["desktop", "web", "returning"]', '{"os": "Edge", "language": "US", "screen_size": "en", "utm_source": "mobile"}']
  [3118, 'purchase', 197, '2026-03-03 02:14:00', '{"amount": 56.93, "currency": "GBP", "items": [{"sku": "SKU1002", "qty": 3}]}', '["ios", "premium", "new_user", "organic"]', '{"country": "Windows", "device_type": "FR", "referrer": "fr", "utm_medium": "1920x1080", "browser": "twitter"}']
  [3177, 'signup', 294, '2026-04-04 03:21:00', '{"signup_method": "apple", "referral_code": "REF3X", "accepted_terms": true}', '["android", "free", "campaign_a", "referral", "experiment_v1"]', '{"language": "iOS", "screen_size": "es", "utm_source": "desktop", "session_id": "bing", "os": "organic"}']
  [3236, 'login', 391, '2026-05-05 04:28:00', '{"login_method": "password", "remember_me": true, "mfa_used": false}', '["web", "returning"]', '{"device_type": "JP", "referrer": "ja", "utm_medium": "1440x900"}']
  [3295, 'logout', 488, '2026-06-06 05:35:00', '{"action": "logout", "value": 50}', '["premium", "new_user", "organic"]', '{"screen_size": "de", "utm_source": "tablet", "session_id": "amazon", "os": "Chrome"}']

Expected output ['event_type', 'unique_users', 'pct_of_engaged']:
  ['purchase', 13, 40.6]
  ['checkout_start', 7, 21.9]
  ['search', 7, 21.9]
  ['page_view', 5, 15.6]
*/


-- Write your SQL solution below:

WITH counts AS (
  SELECT event_type, COUNT(DISTINCT user_id) AS unique_users
  FROM event_data
  WHERE event_type IN ('page_view','search','checkout_start','purchase')
  GROUP BY event_type
)
SELECT event_type, unique_users,
       ROUND(CAST(unique_users AS REAL) * 100.0 / (SELECT SUM(unique_users) FROM counts), 1) AS pct_of_engaged
FROM counts
ORDER BY unique_users DESC, event_type
