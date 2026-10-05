-- ======================================================================
-- Proof of Presence
-- ======================================================================
-- Difficulty : Medium
-- Company    : Meta
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/2fa_confirmation_rate
-- ======================================================================

/*
The security team is measuring how reliably users complete two-factor authentication, counting only the pushes that were actually delivered. For each client platform, find the confirmation rate: the share of delivered pushes the user opened.

Table: push_notifs_2fa(notif_id, user_id, title, platform, status, sent_at, opened, campaign)

Sample data - push_notifs_2fa ['notif_id', 'user_id', 'title', 'platform', 'status', 'sent_at', 'opened', 'campaign']:
  [1001, 101, 'Your 2FA code', 'android', 'delivered', '2026-02-02 01:07:00', 1, 'login_feb']
  [1002, 102, 'Your 2FA code', 'android', 'delivered', '2026-02-03 02:10:00', 1, 'login_feb']
  [1003, 103, 'Your 2FA code', 'android', 'delivered', '2026-02-04 03:15:00', 0, 'login_feb']
  [1004, 104, 'Your 2FA code', 'ios', 'delivered', '2026-02-05 04:20:00', 1, 'login_feb']
  [1005, 105, 'Your 2FA code', 'ios', 'delivered', '2026-02-06 05:25:00', 0, 'login_feb']

Expected output ['platform', 'confirmation_rate']:
  ['android', 0.67]
  ['ios', 0.5]
  ['web', 0.33]
*/


-- Write your SQL solution below:

SELECT
    platform,
    ROUND(
        1.0 * SUM(CASE WHEN opened = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS confirmation_rate
FROM push_notifs_2fa
WHERE status = 'delivered'
GROUP BY platform
ORDER BY confirmation_rate DESC
