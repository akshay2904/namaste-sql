-- ======================================================================
-- Fastest Page View to Click
-- ======================================================================
-- Difficulty : Hard
-- Company    : Meta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/fastest_page_view_to_click
-- ======================================================================

/*
Events are logged with event_type values of 'page_view' and 'button_click'. Find the smallest time gap between any page view and the next button click in the global event stream. Show the user who viewed the page, the page view time, the click time, and the gap in seconds. Return only the single fastest transition.

Table: event_data(event_id, event_type, user_id, event_timestamp, payload, tags, properties)

Sample data - event_data ['event_id', 'event_type', 'user_id', 'event_timestamp', 'payload', 'tags', 'properties']:
  [3059, 'button_click', 100, '2026-02-02 01:07:00', '{"button_id": "cancel", "element_class": "btn-primary", "position": {"x": 13, "y": 7}}', '["desktop", "web", "returning"]', '{"os": "Edge", "language": "US", "screen_size": "en", "utm_source": "mobile"}']
  [3118, 'purchase', 197, '2026-03-03 02:14:00', '{"amount": 56.93, "currency": "GBP", "items": [{"sku": "SKU1002", "qty": 3}]}', '["ios", "premium", "new_user", "organic"]', '{"country": "Windows", "device_type": "FR", "referrer": "fr", "utm_medium": "1920x1080", "browser": "twitter"}']
  [3177, 'signup', 294, '2026-04-04 03:21:00', '{"signup_method": "apple", "referral_code": "REF3X", "accepted_terms": true}', '["android", "free", "campaign_a", "referral", "experiment_v1"]', '{"language": "iOS", "screen_size": "es", "utm_source": "desktop", "session_id": "bing", "os": "organic"}']
  [3236, 'login', 391, '2026-05-05 04:28:00', '{"login_method": "password", "remember_me": true, "mfa_used": false}', '["web", "returning"]', '{"device_type": "JP", "referrer": "ja", "utm_medium": "1440x900"}']
  [3295, 'logout', 488, '2026-06-06 05:35:00', '{"action": "logout", "value": 50}', '["premium", "new_user", "organic"]', '{"screen_size": "de", "utm_source": "tablet", "session_id": "amazon", "os": "Chrome"}']

Expected output ['user_id', 'page_view_time', 'click_time', 'gap_seconds']:
  [None, '2026-03-15 14:38:00', '2026-03-16 15:45:00', 90420.00000178814]
*/


-- Write your SQL solution below:

WITH events_ordered AS (
  SELECT user_id, event_type, event_timestamp,
    LEAD(event_type) OVER (ORDER BY event_timestamp) AS next_type,
    LEAD(event_timestamp) OVER (ORDER BY event_timestamp) AS next_ts,
    LEAD(user_id) OVER (ORDER BY event_timestamp) AS next_user
  FROM event_data
  WHERE event_type IN ('page_view', 'button_click')
),
gaps AS (
  SELECT user_id,
    event_timestamp AS page_view_time,
    next_ts AS click_time,
    next_user AS click_user,
    (JULIANDAY(next_ts) - JULIANDAY(event_timestamp)) * 86400 AS gap_seconds
  FROM events_ordered
  WHERE event_type = 'page_view' AND next_type = 'button_click'
)
SELECT user_id, page_view_time, click_time, gap_seconds
FROM gaps
ORDER BY gap_seconds ASC
LIMIT 1
