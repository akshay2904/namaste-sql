-- ======================================================================
-- New vs Returning User Share
-- ======================================================================
-- Difficulty : Hard
-- Company    : Yammer
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/new_vs_returning_user_share
-- ======================================================================

/*
A user is 'new' in the month of their very first event in event_data; in every subsequent month they are 'returning'. For each month, compute the ratio of new users and returning users to total active users. Return the month, new user ratio, and returning user ratio.

Table: event_data(event_id, event_type, user_id, event_timestamp, payload, tags, properties)

Sample data - event_data ['event_id', 'event_type', 'user_id', 'event_timestamp', 'payload', 'tags', 'properties']:
  [3059, 'button_click', 100, '2026-02-02 01:07:00', '{"button_id": "cancel", "element_class": "btn-primary", "position": {"x": 13, "y": 7}}', '["desktop", "web", "returning"]', '{"os": "Edge", "language": "US", "screen_size": "en", "utm_source": "mobile"}']
  [3118, 'purchase', 197, '2026-03-03 02:14:00', '{"amount": 56.93, "currency": "GBP", "items": [{"sku": "SKU1002", "qty": 3}]}', '["ios", "premium", "new_user", "organic"]', '{"country": "Windows", "device_type": "FR", "referrer": "fr", "utm_medium": "1920x1080", "browser": "twitter"}']
  [3177, 'signup', 294, '2026-04-04 03:21:00', '{"signup_method": "apple", "referral_code": "REF3X", "accepted_terms": true}', '["android", "free", "campaign_a", "referral", "experiment_v1"]', '{"language": "iOS", "screen_size": "es", "utm_source": "desktop", "session_id": "bing", "os": "organic"}']
  [3236, 'login', 391, '2026-05-05 04:28:00', '{"login_method": "password", "remember_me": true, "mfa_used": false}', '["web", "returning"]', '{"device_type": "JP", "referrer": "ja", "utm_medium": "1440x900"}']
  [3295, 'logout', 488, '2026-06-06 05:35:00', '{"action": "logout", "value": 50}', '["premium", "new_user", "organic"]', '{"screen_size": "de", "utm_source": "tablet", "session_id": "amazon", "os": "Chrome"}']

Expected output ['month', 'new_user_ratio', 'returning_user_ratio']:
  ['2020-01', 1, 0]
  ['2022-01', 1, 0]
  ['2022-02', 1, 0]
  ['2022-03', 1, 0]
  ['2022-04', 1, 0]
*/


-- Write your SQL solution below:

WITH user_first_month AS (
  SELECT
    user_id,
    strftime('%Y-%m', MIN(event_timestamp)) AS first_month
  FROM event_data
  GROUP BY user_id
),
monthly_active AS (
  SELECT DISTINCT
    user_id,
    strftime('%Y-%m', event_timestamp) AS month
  FROM event_data
)
SELECT
  ma.month,
  CAST(SUM(CASE WHEN ufm.first_month = ma.month THEN 1 ELSE 0 END) AS REAL) / COUNT(*) AS new_user_ratio,
  CAST(SUM(CASE WHEN ufm.first_month < ma.month THEN 1 ELSE 0 END) AS REAL) / COUNT(*) AS returning_user_ratio
FROM monthly_active ma
JOIN user_first_month ufm ON ma.user_id = ufm.user_id
GROUP BY ma.month
ORDER BY ma.month
