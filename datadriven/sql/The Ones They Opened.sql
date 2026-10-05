-- ======================================================================
-- The Ones They Opened
-- ======================================================================
-- Difficulty : Medium
-- Company    : Amazon
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/top_campaign_by_opens
-- ======================================================================

/*
Our push notification system records an `opened` flag on every notification along with the campaign that sent it. Find the campaigns that pulled more opens than the average campaign, listed with the most opens first.

Table: push_notifs(notif_id, user_id, title, platform, status, sent_at, opened, campaign)

Sample data - push_notifs ['notif_id', 'user_id', 'title', 'platform', 'status', 'sent_at', 'opened', 'campaign']:
  [1053, 100, 'New message from team', 'android', 'pending', '2026-02-02 01:07:00', 0, 'winback_feb']
  [1106, 197, 'Weekly digest ready', 'web', 'failed', '2026-03-03 02:14:00', 0, 'promo_summer']
  [1159, 294, 'Price drop alert', 'iOS', 'bounced', '2026-04-04 03:21:00', 1, 'onboard_v2']
  [1212, 391, 'Security alert', 'Android', 'Delivered', '2026-05-05 04:28:00', 0, None]
  [1265, 488, 'Payment received', 'WEB', 'FAILED', '2026-06-06 05:35:00', None, 'loyalty_2024']

Expected output ['campaign', 'open_count']:
  ['flash_sale', 8]
  ['onboard_v2', 8]
*/


-- Write your SQL solution below:

SELECT campaign, COUNT(*) AS open_count
FROM push_notifs
WHERE opened = 1 AND campaign IS NOT NULL
GROUP BY campaign
HAVING COUNT(*) > (
    SELECT AVG(cnt) FROM (
        SELECT COUNT(*) AS cnt
        FROM push_notifs
        WHERE opened = 1 AND campaign IS NOT NULL
        GROUP BY campaign
    )
)
ORDER BY open_count DESC, campaign
