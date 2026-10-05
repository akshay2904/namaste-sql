-- ======================================================================
-- The Conversion Story
-- ======================================================================
-- Difficulty : Medium
-- Company    : Visa
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/signup_to_subscription_rate
-- ======================================================================

/*
From the event_data table, calculate each referral source's conversion rate from signup to paid purchase. Derive the referral source from the event's tags: classify a row as 'organic' if its tags contain "organic", else 'referral' if it contains "referral", else 'campaign_a' if it contains "campaign_a", else 'campaign_b' if it contains "campaign_b", else 'other'. For each source, the conversion rate is the number of distinct users with a purchase event divided by the number of distinct users with a signup event. Only include sources that have at least one signup. Round the rate to 4 decimal places.

Table: event_data(event_id, event_type, user_id, event_timestamp, payload, tags, properties)

Sample data - event_data ['event_id', 'event_type', 'user_id', 'event_timestamp', 'payload', 'tags', 'properties']:
  [3059, 'button_click', 100, '2026-02-02 01:07:00', '{"button_id": "cancel", "element_class": "btn-primary", "position": {"x": 13, "y": 7}}', '["desktop", "web", "returning"]', '{"os": "Edge", "language": "US", "screen_size": "en", "utm_source": "mobile"}']
  [3118, 'purchase', 197, '2026-03-03 02:14:00', '{"amount": 56.93, "currency": "GBP", "items": [{"sku": "SKU1002", "qty": 3}]}', '["ios", "premium", "new_user", "organic"]', '{"country": "Windows", "device_type": "FR", "referrer": "fr", "utm_medium": "1920x1080", "browser": "twitter"}']
  [3177, 'signup', 294, '2026-04-04 03:21:00', '{"signup_method": "apple", "referral_code": "REF3X", "accepted_terms": true}', '["android", "free", "campaign_a", "referral", "experiment_v1"]', '{"language": "iOS", "screen_size": "es", "utm_source": "desktop", "session_id": "bing", "os": "organic"}']
  [3236, 'login', 391, '2026-05-05 04:28:00', '{"login_method": "password", "remember_me": true, "mfa_used": false}', '["web", "returning"]', '{"device_type": "JP", "referrer": "ja", "utm_medium": "1440x900"}']
  [3295, 'logout', 488, '2026-06-06 05:35:00', '{"action": "logout", "value": 50}', '["premium", "new_user", "organic"]', '{"screen_size": "de", "utm_source": "tablet", "session_id": "amazon", "os": "Chrome"}']

Expected output ['referral_source', 'signup_count', 'purchase_count', 'conversion_rate']:
  ['campaign_a', 1, 0, 0]
  ['organic', 4, 1, 0.25]
  ['other', 1, 9, 9]
  ['referral', 1, 0, 0]
*/


-- Write your SQL solution below:

WITH src AS (
  SELECT user_id, event_type,
    CASE
      WHEN tags LIKE '%"organic"%'    THEN 'organic'
      WHEN tags LIKE '%"referral"%'   THEN 'referral'
      WHEN tags LIKE '%"campaign_a"%' THEN 'campaign_a'
      WHEN tags LIKE '%"campaign_b"%' THEN 'campaign_b'
      ELSE 'other'
    END AS referral_source
  FROM event_data
  WHERE event_type IN ('signup', 'purchase')
)
SELECT referral_source,
       COUNT(DISTINCT CASE WHEN event_type = 'signup'   THEN user_id END) AS signup_count,
       COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchase_count,
       ROUND(COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) * 1.0
             / COUNT(DISTINCT CASE WHEN event_type = 'signup' THEN user_id END), 4) AS conversion_rate
FROM src
GROUP BY referral_source
HAVING COUNT(DISTINCT CASE WHEN event_type = 'signup' THEN user_id END) > 0
ORDER BY referral_source;
