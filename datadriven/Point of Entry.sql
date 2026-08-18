-- ======================================================================
-- Point of Entry
-- ======================================================================
-- Difficulty : Hard
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/viewer_to_purchaser_activity
-- ======================================================================

/*
The growth team is checking whether the people who arrive and simply look around ever turn into buyers. For every user whose very first recorded event was a page view, count how many purchases they later made, and keep the ones who never bought with a count of zero. Order the result from the most purchases down, breaking ties by user ID ascending.

Table: event_data(event_id, event_type, user_id, event_timestamp, payload, tags, properties)

Sample data - event_data ['event_id', 'event_type', 'user_id', 'event_timestamp', 'payload', 'tags', 'properties']:
  [3059, 'button_click', 100, '2026-02-02 01:07:00', '{"button_id": "cancel", "element_class": "btn-primary", "position": {"x": 13, "y": 7}}', '["desktop", "web", "returning"]', '{"os": "Edge", "language": "US", "screen_size": "en", "utm_source": "mobile"}']
  [3118, 'purchase', 197, '2026-03-03 02:14:00', '{"amount": 56.93, "currency": "GBP", "items": [{"sku": "SKU1002", "qty": 3}]}', '["ios", "premium", "new_user", "organic"]', '{"country": "Windows", "device_type": "FR", "referrer": "fr", "utm_medium": "1920x1080", "browser": "twitter"}']
  [3177, 'signup', 294, '2026-04-04 03:21:00', '{"signup_method": "apple", "referral_code": "REF3X", "accepted_terms": true}', '["android", "free", "campaign_a", "referral", "experiment_v1"]', '{"language": "iOS", "screen_size": "es", "utm_source": "desktop", "session_id": "bing", "os": "organic"}']
  [3236, 'login', 391, '2026-05-05 04:28:00', '{"login_method": "password", "remember_me": true, "mfa_used": false}', '["web", "returning"]', '{"device_type": "JP", "referrer": "ja", "utm_medium": "1440x900"}']
  [3295, 'logout', 488, '2026-06-06 05:35:00', '{"action": "logout", "value": 50}', '["premium", "new_user", "organic"]', '{"screen_size": "de", "utm_source": "tablet", "session_id": "amazon", "os": "Chrome"}']

Expected output ['user_id', 'purchase_count']:
  [12128, 5]
  [12031, 4]
  [11934, 3]
  [11837, 2]
  [11740, 1]
*/


-- Write your SQL solution below:

WITH first_events AS (
    SELECT user_id, event_type,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_timestamp) AS rn
    FROM event_data
),
viewer_cohort AS (
    SELECT user_id
    FROM first_events
    WHERE rn = 1 AND event_type = 'page_view'
)
SELECT
    vc.user_id,
    COUNT(e.event_id) AS purchase_count
FROM viewer_cohort vc
LEFT JOIN event_data e
    ON vc.user_id = e.user_id AND e.event_type = 'purchase'
GROUP BY vc.user_id
ORDER BY purchase_count DESC, vc.user_id ASC
