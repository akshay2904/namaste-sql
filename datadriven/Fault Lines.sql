-- ======================================================================
-- Fault Lines
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/error_rate_by_region
-- ======================================================================

/*
The reliability team is building a daily failure report and treats each user's age_bucket as a stand-in for region. Looking only at open, error, and crash events, give them for every day and region the number of error and crash events as a share of the number of opens.

Table: event_data(event_id, event_type, user_id, event_timestamp, payload, tags, properties)

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Sample data - event_data ['event_id', 'event_type', 'user_id', 'event_timestamp', 'payload', 'tags', 'properties']:
  [3059, 'button_click', 100, '2026-02-02 01:07:00', '{"button_id": "cancel", "element_class": "btn-primary", "position": {"x": 13, "y": 7}}', '["desktop", "web", "returning"]', '{"os": "Edge", "language": "US", "screen_size": "en", "utm_source": "mobile"}']
  [3118, 'purchase', 197, '2026-03-03 02:14:00', '{"amount": 56.93, "currency": "GBP", "items": [{"sku": "SKU1002", "qty": 3}]}', '["ios", "premium", "new_user", "organic"]', '{"country": "Windows", "device_type": "FR", "referrer": "fr", "utm_medium": "1920x1080", "browser": "twitter"}']
  [3177, 'signup', 294, '2026-04-04 03:21:00', '{"signup_method": "apple", "referral_code": "REF3X", "accepted_terms": true}', '["android", "free", "campaign_a", "referral", "experiment_v1"]', '{"language": "iOS", "screen_size": "es", "utm_source": "desktop", "session_id": "bing", "os": "organic"}']
  [3236, 'login', 391, '2026-05-05 04:28:00', '{"login_method": "password", "remember_me": true, "mfa_used": false}', '["web", "returning"]', '{"device_type": "JP", "referrer": "ja", "utm_medium": "1440x900"}']
  [3295, 'logout', 488, '2026-06-06 05:35:00', '{"action": "logout", "value": 50}', '["premium", "new_user", "organic"]', '{"screen_size": "de", "utm_source": "tablet", "session_id": "amazon", "os": "Chrome"}']

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Expected output ['event_day', 'region', 'error_rate']:
  ['2022-03-24', '35-44', None]
  ['2022-06-11', '45-54', None]
  ['2022-12-09', '25-34', 0]
  ['2023-01-10', '35-44', None]
  ['2023-04-25', '45-54', None]
*/


-- Write your SQL solution below:

SELECT substr(ed.event_timestamp, 1, 10) AS event_day,
       u.age_bucket AS region,
       CAST(SUM(CASE WHEN ed.event_type IN ('error', 'crash') THEN 1 ELSE 0 END) AS REAL)
         / SUM(CASE WHEN ed.event_type = 'open' THEN 1 ELSE 0 END) AS error_rate
FROM event_data ed
JOIN users u ON ed.user_id = u.user_id
WHERE ed.event_type IN ('open', 'error', 'crash')
GROUP BY event_day, region
